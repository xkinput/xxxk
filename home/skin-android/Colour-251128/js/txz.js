var htmltxt=`
    <canvas id="gameCanvas">Your browser does not support the HTML5 canvas tag.</canvas>

    <div id="controls">
    <div id="message">Loading...</div>
         <button id="btnPrev" title="Previous Level (P)">Previous</button>
         <button id="btnReset" title="Reset Level (R)">Reset</button>
         <button id="btnUndo" title="Undo Move (U/Z)">Undo</button> <!-- Added Undo Button -->
         <button id="btnNext" title="Next Level (N)">Next</button>
     </div>
`;

function jsload(on){
	var div=$(".jsload div div");        // --- Constants for Tile Types ---
        const TILE_FLOOR = 0;
        const TILE_WALL = 1;
        const TILE_TARGET = 3;
        const TILE_BOX = 4;
        const TILE_BOX_ON_TARGET = 5;

        // --- Level Data ---
        const levelStrings = [
          `
__###___
__#.#___
__#-####
###$-$.#
#.-$@###
####$#__
___#.#__
___###__
          `,
          `
#####____
#@--#____
#-$$#_###
#-$-#_#.#
###-###.#
_##----.#
_#---#--#
_#---####
_#####___
          `,
          `
_#######__
_#-----###
##$###---#
#-@-$--$-#
#-..#-$-##
##..#---#_
_########_
          `,
         `
_####_
##--#_
#@$-#_
##$-##
##-$-#
#.$--#
#..*.#
######
         `,
         `
_####___
_#@-###_
_#-$--#_
###-#-##
#.#-#--#
#.$--#-#
#.---$-#
########
         `
        ];

        // --- Level Parser Function (Unchanged) ---
        function parseLevelString(levelStr) {
            const lines = levelStr.trim().split('\n').map(line => line.trimEnd());
            const height = lines.length;
            if (height === 0) return null;
            const width = Math.max(...lines.map(line => line.length));

            const mapData = [];
            const targetLocations = [];
            let playerPos = null;
            let boxCount = 0;
            let targetCount = 0;

            for (let y = 0; y < height; y++) {
                const row = [];
                const line = lines[y] || '';
                for (let x = 0; x < width; x++) {
                    const char = line[x] || '_';
                    switch (char) {
                        case '#': case '_': case ' ':
                            row.push(TILE_WALL); break;
                        case '-': row.push(TILE_FLOOR); break;
                        case '.':
                            row.push(TILE_TARGET);
                            targetLocations.push({ x, y });
                            targetCount++; break;
                        case '$':
                            row.push(TILE_BOX);
                            boxCount++; break;
                        case '*':
                            row.push(TILE_BOX_ON_TARGET);
                            targetLocations.push({ x, y });
                            boxCount++; targetCount++; break;
                        case '@':
                            row.push(TILE_FLOOR);
                            if (playerPos) console.warn("Multiple player starts ('@'). Using last.");
                            playerPos = { x, y }; break;
                        default:
                            console.warn(`Unknown char '${char}' at (${x},${y}). Treating as Floor.`);
                            row.push(TILE_FLOOR); break;
                    }
                } mapData.push(row);
            }
            if (!playerPos) { console.error("Level parse error: No player start '@'."); return null; }
            if (boxCount !== targetCount) console.warn(`Level warning: Box count (${boxCount}) != Target count (${targetCount}).`);
            if (targetCount === 0 && boxCount > 0) console.warn("Level warning: Boxes exist but no targets found.");
            return { mapData, playerPos, targetLocations };
        }


        // --- Game Class Definition ---
        class Game {
            constructor(levelSet) {
                this.canvas = document.getElementById('gameCanvas');
                this.ctx = this.canvas.getContext('2d');
                this.messageElement = document.getElementById('message');
                this.undoButton = document.getElementById('btnUndo'); // Reference to undo button

                if (!this.ctx) {
                    this.messageElement.textContent = "Error: Canvas not supported.";
                    console.error("Failed to get 2D context");
                    this.disableAllControls();
                    return;
                }

                this.levelSet = levelSet;
                this.currentLevelIndex = 0;
                this.tileSize = 40;
                this.mapData = [];
                this.map = [];
                this.playerPos = {x: 0, y: 0};
                this.targetLocations = [];
                this.moveHistory = []; // *** For Undo ***
                this.isWin = false;
                this.isComplete = false;
                this.isAutoMoving = false; // *** For Click-to-Move ***
                this.autoMoveInterval = null; // *** Store interval ID ***

                this.loadLevel(this.currentLevelIndex);
                this.initEvents();
                this.updateUndoButton(); // Set initial state of undo button
            }

            disableAllControls() {
                document.querySelectorAll('#controls button').forEach(button => button.disabled = true);
            }

            loadLevel(levelIndex) {
                 this.stopAutoMove(); // Stop any ongoing auto-move
                 if (this.isComplete) return;

                if (levelIndex < 0 || levelIndex >= this.levelSet.length) {
                    console.error("Invalid level index:", levelIndex); return;
                }
                const parsedData = parseLevelString(this.levelSet[levelIndex]);
                if (!parsedData) {
                    this.messageElement.textContent = `Error loading level ${levelIndex + 1}`;
                    this.map = []; this.draw(); this.disableAllControls(); return;
                }

                console.log(`Loading Level ${levelIndex + 1}`);
                this.currentLevelIndex = levelIndex;
                this.mapData = parsedData.mapData;
                this.map = this.mapData.map(row => [...row]);
                this.playerPos = parsedData.playerPos;
                this.targetLocations = parsedData.targetLocations;
                this.isWin = false;
                this.isComplete = false;
                this.moveHistory = []; // *** Reset history for new level ***
                this.messageElement.textContent = `Level ${this.currentLevelIndex + 1}`;

                this.resize();
                this.checkWinCondition();
                this.updateUndoButton(); // Update undo button state
            }

            resetLevel() {
                this.stopAutoMove();
                console.log("Resetting level", this.currentLevelIndex + 1);
                this.loadLevel(this.currentLevelIndex);
            }

            nextLevel() {
                this.stopAutoMove();
                if (this.currentLevelIndex + 1 < this.levelSet.length) {
                    this.loadLevel(this.currentLevelIndex + 1);
                } else if (!this.isComplete) {
                    console.log("All levels completed!");
                    this.messageElement.textContent = "You beat all levels!";
                    this.isComplete = true; this.isWin = true;
                    this.updateUndoButton(); this.draw();
                }
            }

            previousLevel() {
                this.stopAutoMove();
                if (this.currentLevelIndex > 0) {
                    this.loadLevel(this.currentLevelIndex - 1);
                }
            }

            resize() {
                this.stopAutoMove(); // Stop auto-move on resize
                if (!this.map || this.map.length === 0) { /* ... error handling ... */ return; }
                const mapWidth = this.map[0].length; const mapHeight = this.map.length;
                const padding = 20;
                const controlsHeight = document.getElementById('controls')?.offsetHeight || 60;
                const messageHeight = this.messageElement?.offsetHeight || 30;
                const availableWidth = window.innerWidth - padding;
                const availableHeight = window.innerHeight - padding - controlsHeight - messageHeight;
                const positiveWidth = Math.max(1, availableWidth); const positiveHeight = Math.max(1, availableHeight);
                const tileSizeWidth = positiveWidth / mapWidth; const tileSizeHeight = positiveHeight / mapHeight;
                this.tileSize = Math.max(10, Math.floor(Math.min(tileSizeWidth, tileSizeHeight)));
                this.canvas.width = mapWidth * this.tileSize; this.canvas.height = mapHeight * this.tileSize;
                this.draw();
            }

            initEvents() {
                // --- Unified Input Handler ---
                const handleInput = (event) => {
                    if (this.isComplete || this.isWin || this.isAutoMoving) return; // Block input if finished or auto-moving

                    event.preventDefault();
                    const rect = this.canvas.getBoundingClientRect();
                    let clientX, clientY;
                    if (event.touches && event.touches.length > 0) {
                        clientX = event.touches[0].clientX; clientY = event.touches[0].clientY;
                    } else if (event.clientX !== undefined) {
                        clientX = event.clientX; clientY = event.clientY;
                    } else return;

                    const canvasX = clientX - rect.left; const canvasY = clientY - rect.top;
                    const col = Math.floor(canvasX / this.tileSize); const row = Math.floor(canvasY / this.tileSize);
                    const dx = col - this.playerPos.x; const dy = row - this.playerPos.y;

                    // --- Adjacent Move ---
                    if (Math.abs(dx) + Math.abs(dy) === 1) {
                        this.attemptMoveAndRecord(dx, dy); // Use helper to handle move + history
                    }
                    // --- Click-to-Move ---
                    else if (this.isInBounds(col, row)) {
                        const targetTile = this.getTile(col, row);
                        if (targetTile === TILE_FLOOR || targetTile === TILE_TARGET) {
                            // Find path only if target is walkable and not player's current pos
                            if (col !== this.playerPos.x || row !== this.playerPos.y) {
                                const path = this.findPathBFS(this.playerPos.x, this.playerPos.y, col, row);
                                if (path) {
                                    this.addHistoryState(); // Store state BEFORE starting auto-move sequence
                                    this.executePath(path);
                                } else {
                                    console.log("No path found to target.");
                                    // Optional: Provide visual feedback like flashing the tile?
                                }
                            }
                        }
                    }
                };
                this.canvas.removeEventListener('touchstart', handleInput); this.canvas.removeEventListener('mousedown', handleInput);
                this.canvas.addEventListener('touchstart', handleInput, { passive: false }); this.canvas.addEventListener('mousedown', handleInput);

                // --- Keyboard Support ---
                this.handleKeyDown = (e) => {
                    if (this.isComplete || this.isAutoMoving) return; // Block KB input too

                    if (e.key.startsWith('F') || e.ctrlKey || e.metaKey) return;

                    // Level & Undo Controls
                    if (e.key === 'r' || e.key === 'R') { this.resetLevel(); e.preventDefault(); return; }
                    if (e.key === 'n' || e.key === 'N') { this.nextLevel(); e.preventDefault(); return; }
                    if (e.key === 'p' || e.key === 'P') { this.previousLevel(); e.preventDefault(); return; }
                    if (e.key === 'u' || e.key === 'U' || e.key === 'z' || e.key === 'Z') { this.undoMove(); e.preventDefault(); return; } // *** Undo Keybind ***

                    // Movement Keys - only if not won
                    if (this.isWin) return;
                    let dx = 0, dy = 0;
                    switch(e.key) {
                        case 'ArrowUp': case 'w': case 'W': dy = -1; break;
                        case 'ArrowDown': case 's': case 'S': dy = 1; break;
                        case 'ArrowLeft': case 'a': case 'A': dx = -1; break;
                        case 'ArrowRight': case 'd': case 'D': dx = 1; break;
                        default: return;
                    }
                    e.preventDefault();
                    this.attemptMoveAndRecord(dx, dy); // Use helper
                };
                window.removeEventListener('keydown', this.handleKeyDown); window.addEventListener('keydown', this.handleKeyDown);
            }

            // --- Undo Functionality ---
            addHistoryState() {
                // Store a deep copy of the map and player position
                const state = {
                    map: this.map.map(row => [...row]),
                    playerPos: { ...this.playerPos }
                };
                this.moveHistory.push(state);
                this.updateUndoButton(); // Enable undo button
            }

            undoMove() {
                if (this.isAutoMoving) this.stopAutoMove(); // Stop auto-move if undo is triggered
                if (this.moveHistory.length > 0) {
                    const prevState = this.moveHistory.pop();
                    this.map = prevState.map; // Restore map
                    this.playerPos = prevState.playerPos; // Restore player position

                    // Reset win/complete flags as undoing might change the state
                    const wasComplete = this.isComplete;
                    this.isWin = false;
                    this.isComplete = false;

                    // Update message (unless game was fully complete and we are just undoing last step)
                    if (!wasComplete) {
                         this.messageElement.textContent = `Level ${this.currentLevelIndex + 1}`;
                    } else {
                        // If undoing from the "all levels complete" screen, go back to last level message
                        this.messageElement.textContent = `Level ${this.levelSet.length}`;
                    }


                    this.updateUndoButton(); // Update button state (might become disabled)
                    this.draw();
                    console.log("Undo move");
                } else {
                    console.log("No moves to undo");
                }
            }

            updateUndoButton() {
                if(this.undoButton) {
                    this.undoButton.disabled = (this.moveHistory.length === 0 || this.isAutoMoving);
                }
            }

            // --- Pathfinding (BFS) ---
            findPathBFS(startX, startY, endX, endY) {
                const queue = [{ x: startX, y: startY, path: [] }]; // Store path taken to reach node
                const visited = new Set();
                visited.add(`${startX},${startY}`); // Mark start as visited

                const directions = [[0, -1], [1, 0], [0, 1], [-1, 0]]; // Up, Right, Down, Left

                while (queue.length > 0) {
                    const current = queue.shift(); // Get node from front of queue

                    // Found the target
                    if (current.x === endX && current.y === endY) {
                        return current.path; // Return the list of coordinates [{x,y}, {x,y}...]
                    }

                    // Explore neighbors
                    for (const [dx, dy] of directions) {
                        const nextX = current.x + dx;
                        const nextY = current.y + dy;
                        const nextKey = `${nextX},${nextY}`;

                        // Check bounds, visited status, and walkability (Floor or Target)
                        if (this.isInBounds(nextX, nextY) && !visited.has(nextKey)) {
                            const tile = this.getTile(nextX, nextY); // Check CURRENT map state
                            if (tile === TILE_FLOOR || tile === TILE_TARGET) {
                                visited.add(nextKey);
                                const newPath = [...current.path, { x: nextX, y: nextY }]; // Append step to path
                                queue.push({ x: nextX, y: nextY, path: newPath });
                            }
                        }
                    }
                }
                return null; // No path found
            }

            // --- Path Execution ---
            executePath(path) {
                if (!path || path.length === 0 || this.isAutoMoving) return;

                console.log("Starting auto-move...");
                this.isAutoMoving = true;
                this.updateUndoButton(); // Disable undo during auto-move
                this.canvas.classList.add('automoving'); // Add waiting cursor style


                let pathIndex = 0;
                this.autoMoveInterval = setInterval(() => {
                    if (pathIndex >= path.length) {
                        this.stopAutoMove(); // Path completed
                        return;
                    }

                    const nextStep = path[pathIndex];
                    const dx = nextStep.x - this.playerPos.x;
                    const dy = nextStep.y - this.playerPos.y;

                    // Attempt the next single step - DO NOT record history here
                    const moved = this.attemptMove(dx, dy);

                    if (moved) {
                        pathIndex++; // Move to next step in path only if successful
                    } else {
                        console.warn("Auto-move interrupted or path blocked.");
                        this.stopAutoMove(); // Stop if a step fails
                    }

                }, 150); // Delay between steps in milliseconds (adjust for speed)
            }

             stopAutoMove() {
                 if (this.autoMoveInterval) {
                     clearInterval(this.autoMoveInterval);
                     this.autoMoveInterval = null;
                 }
                 if (this.isAutoMoving) {
                     this.isAutoMoving = false;
                     this.updateUndoButton(); // Re-enable undo button if history exists
                     this.canvas.classList.remove('automoving'); // Remove waiting cursor
                     console.log("Auto-move stopped.");
                     // Check win condition after the sequence finishes
                     this.checkWinCondition();
                 }
             }


            // --- Core Move Logic ---
            isInBounds(x, y) { /* ... unchanged ... */
                 return y >= 0 && y < this.map.length && x >= 0 && x < this.map[y].length;
            }
            getTile(x, y) { /* ... unchanged ... */
                if (!this.isInBounds(x, y)) return TILE_WALL;
                return this.map[y][x];
            }
            setTile(x, y, tile) { /* ... unchanged ... */
                if (this.isInBounds(x, y)) {
                    const isOriginallyTarget = this.targetLocations.some(loc => loc.x === x && loc.y === y);
                    let finalTile = tile;
                    if (tile === TILE_FLOOR && isOriginallyTarget) finalTile = TILE_TARGET;
                    else if (tile === TILE_BOX && isOriginallyTarget) finalTile = TILE_BOX_ON_TARGET;
                    this.map[y][x] = finalTile;
                }
            }

            // Helper to attempt move and record history if successful
            attemptMoveAndRecord(dx, dy) {
                 // Store state BEFORE attempting the move
                 const currentMapState = this.map.map(row => [...row]);
                 const currentPlayerPos = { ...this.playerPos };

                 if (this.attemptMove(dx, dy)) {
                     // Move was successful, push the PREVIOUS state to history
                     this.moveHistory.push({ map: currentMapState, playerPos: currentPlayerPos });
                     this.updateUndoButton(); // Update button state
                     return true;
                 }
                 return false;
            }


            // Attempts a single adjacent move, returns true if successful, false otherwise
            // DOES NOT interact with history directly anymore.
            attemptMove(dx, dy) {
                const currentX = this.playerPos.x; const currentY = this.playerPos.y;
                const targetX = currentX + dx; const targetY = currentY + dy;

                if (!this.isInBounds(targetX, targetY)) return false;
                const targetTile = this.getTile(targetX, targetY);
                let moved = false;

                // Case 1: Move to Floor/Target
                if (targetTile === TILE_FLOOR || targetTile === TILE_TARGET) {
                    this.playerPos.x = targetX; this.playerPos.y = targetY; moved = true;
                }
                // Case 2: Push Box
                else if (targetTile === TILE_BOX || targetTile === TILE_BOX_ON_TARGET) {
                    const pushToX = targetX + dx; const pushToY = targetY + dy;
                    if (this.isInBounds(pushToX, pushToY)) {
                        const pushToTile = this.getTile(pushToX, pushToY);
                        if (pushToTile === TILE_FLOOR || pushToTile === TILE_TARGET) {
                            this.setTile(pushToX, pushToY, TILE_BOX); // Move box
                            this.setTile(targetX, targetY, TILE_FLOOR); // Clear box's old spot
                            this.playerPos.x = targetX; this.playerPos.y = targetY; // Move player
                            moved = true;
                        }
                    }
                }

                if (moved) {
                    this.draw(); // Redraw game state after move
                    if (!this.isAutoMoving) { // Only check win immediately if not auto-moving
                       this.checkWinCondition();
                    }
                }
                return moved; // Return success/failure
            }


            checkWinCondition() { /* ... unchanged ... */
                 if (this.isWin || this.isComplete || this.isAutoMoving) return; // Don't check during auto-move
                 if (this.targetLocations.length === 0) { this.isWin = false; return; }
                 for (const target of this.targetLocations) {
                     if (this.getTile(target.x, target.y) !== TILE_BOX_ON_TARGET) {
                         this.isWin = false; return;
                     }
                 }
                 console.log(`Level ${this.currentLevelIndex + 1} Complete!`);
                 this.isWin = true;
                 this.messageElement.textContent = `Level ${this.currentLevelIndex + 1} Complete!`;
                 this.updateUndoButton(); // Disable undo on win screen temporarily
                 setTimeout(() => { this.nextLevel(); }, 1500);
            }

            draw() { /* ... mostly unchanged, add check for automoving cursor ... */
                if (!this.ctx) return;
                this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
                if (!this.map || this.map.length === 0) { /* ... error draw ... */ return; }

                // --- Draw map tiles ---
                for (let y = 0; y < this.map.length; y++) {
                    for (let x = 0; x < this.map[y].length; x++) {
                        let baseTile = TILE_FLOOR;
                        if (this.mapData[y]?.[x] === TILE_WALL) baseTile = TILE_WALL;
                        else if (this.targetLocations.some(loc => loc.x === x && loc.y === y)) baseTile = TILE_TARGET;
                        this.ctx.fillStyle = this.getTileColor(baseTile);
                        this.ctx.fillRect(x * this.tileSize, y * this.tileSize, this.tileSize, this.tileSize);

                        // Optional Grid lines
                        this.ctx.strokeStyle = '#eee'; this.ctx.lineWidth = 1;
                        this.ctx.strokeRect(x * this.tileSize, y * this.tileSize, this.tileSize, this.tileSize);

                        // --- Draw dynamic elements (Boxes) ---
                        const currentTile = this.map[y][x];
                        if (currentTile === TILE_BOX || currentTile === TILE_BOX_ON_TARGET) {
                            this.ctx.fillStyle = this.getTileColor(TILE_BOX);
                            const boxMargin = this.tileSize * 0.1; const boxSize = this.tileSize * 0.8;
                            this.ctx.fillRect(x * this.tileSize + boxMargin, y * this.tileSize + boxMargin, boxSize, boxSize);
                            if (currentTile === TILE_BOX_ON_TARGET) {
                                this.ctx.strokeStyle = 'lime'; this.ctx.lineWidth = Math.max(1, Math.floor(this.tileSize * 0.07));
                                this.ctx.strokeRect(x * this.tileSize + boxMargin, y * this.tileSize + boxMargin, boxSize, boxSize);
                            }
                        }
                    }
                }
                // --- Draw Player ---
                this.ctx.fillStyle = '#e60000'; this.ctx.beginPath();
                this.ctx.arc((this.playerPos.x + 0.5) * this.tileSize, (this.playerPos.y + 0.5) * this.tileSize, this.tileSize * 0.35, 0, Math.PI * 2);
                this.ctx.fill();
                this.ctx.strokeStyle = '#990000'; this.ctx.lineWidth = Math.max(1, Math.floor(this.tileSize * 0.05));
                this.ctx.stroke();
            }

            getTileColor(tile) { /* ... unchanged ... */
                switch(tile) {
                    case TILE_WALL: return '#4a4a4a'; case TILE_FLOOR: return '#ffffff';
                    case TILE_TARGET: return '#b0eab0'; case TILE_BOX: return '#d2691e';
                    default: return '#cccccc';
                }
            }
        } // --- End of Game Class ---


        // --- Game Initialization ---
        let game = null;
            const isTouchDevice = ('ontouchstart' in window) || (navigator.maxTouchPoints > 0);
            game = new Game(levelStrings); // Initialize the game

            // Setup resize listener
            window.addEventListener('resize', () => { if(game) game.resize(); });

             // Setup button listeners only if game initialized successfully
             if (game && game.ctx) {
                 document.getElementById('btnPrev').onclick = () => game.previousLevel();
                 document.getElementById('btnReset').onclick = () => game.resetLevel();
                 document.getElementById('btnUndo').onclick = () => game.undoMove(); // *** Hook up Undo button ***
                 document.getElementById('btnNext').onclick = () => game.nextLevel();

                 // Update tooltips
                 document.getElementById('btnPrev').title = `Previous Level (${isTouchDevice ? 'Button' : 'P'})`;
                 document.getElementById('btnReset').title = `Reset Level (${isTouchDevice ? 'Button' : 'R'})`;
                 document.getElementById('btnUndo').title = `Undo Move (${isTouchDevice ? 'Button' : 'U/Z'})`;
                 document.getElementById('btnNext').title = `Next Level (${isTouchDevice ? 'Button' : 'N'})`;
             } else {
                  // Disable buttons if game failed to load
                  document.querySelectorAll('#controls button').forEach(button => button.disabled = true);
             }
}