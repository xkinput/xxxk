var htmltxt=`
    <div id="info">
        <span><button onclick="newg()">新游戏</button>时间: <span id="timer">0</span></span>
    </div>
    <div id="game-wrapper">
        <div id="game-container">
        </div>
        <svg id="path-overlay"></svg>
    </div>
`;

function jsload(on){
	var div=$(".jsload div");
				const ROWS = 8;
        const COLS = 8;
        const TYPES = 16; 
        const ANIMALS = ['🐶','🐱','🐭','🐹','🐰','🦊','🐻','🐼','🐨','🐯','🦁','🐮','🐷','🐸','🐵','🐔']; // Added more just in case
        let selectedTiles = [];
        let timer = 0;
        let boardState = []; // To hold tile elements or null

        // Cache DOM elements
        const gameContainer = div.querySelector('#game-container');
        const pathOverlay = div.querySelector('#path-overlay');
        const timerDisplay = div.querySelector('#timer');
        const gameWrapper = div.querySelector('#game-wrapper'); 

        function createGame() {
            gameContainer.innerHTML = ''; 
            pathOverlay.innerHTML = '';
            boardState = Array(ROWS).fill(null).map(() => Array(COLS).fill(null)); // Reset board state

            // Ensure we have enough pairs
            if (ROWS * COLS % 2 !== 0) {
                console.error("Grid size must be even!");
                return;
            }
            const pairCount = ROWS * COLS / 2;
            const availableTypes = ANIMALS.slice(0, TYPES);
            const tilesData = [];
            for (let i = 0; i < pairCount; i++) {
                const typeIndex = i % availableTypes.length;
                tilesData.push(typeIndex, typeIndex);
            }

            // Shuffle using Fisher-Yates
            for (let i = tilesData.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [tilesData[i], tilesData[j]] = [tilesData[j], tilesData[i]];
            }

            const grid = document.createElement('div');
            grid.className = 'grid';
            // Set CSS variables for grid dimensions if needed (already set in CSS :root)
            // grid.style.setProperty('--grid-rows', ROWS);
            // grid.style.setProperty('--grid-cols', COLS);

            tilesData.forEach((typeIndex, index) => {
                const tile = document.createElement('div');
                const row = Math.floor(index / COLS);
                const col = index % COLS;

                tile.className = 'tile';
                tile.dataset.type = typeIndex;
                tile.dataset.row = row;
                tile.dataset.col = col;
                tile.textContent = availableTypes[typeIndex];
                tile.id = `tile-${row}-${col}`; // Unique ID for easy access

                // Use mousedown/touchstart for potentially faster response
                tile.addEventListener('mousedown', handleInteraction);
                tile.addEventListener('touchstart', handleInteraction, { passive: false }); // passive: false to allow preventDefault

                grid.appendChild(tile);
                boardState[row][col] = tile; // Store reference
            });

            gameContainer.appendChild(grid);
        }

        function handleInteraction(e) {
            // Prevent default actions like text selection or page scroll on touch drag
            e.preventDefault();
            const tile = e.target.closest('.tile');

            // Ignore clicks on already removed or non-tile elements
            if (!tile || tile.classList.contains('removed') || tile.classList.contains('removing')) return;

            // Prevent selecting the same tile twice or a third tile
             if (selectedTiles.length >= 2 || selectedTiles.includes(tile)) {
                 // If clicking the already selected tile, deselect it
                 if (selectedTiles.length === 1 && selectedTiles[0] === tile) {
                    tile.classList.remove('selected');
                    selectedTiles = [];
                 }
                 return; // Ignore if trying to select a third or re-select second
             }

            tile.classList.add('selected');
            selectedTiles.push(tile);

            if (selectedTiles.length === 2) {
                checkMatch();
            }
        }

        function checkMatch() {
            const [tile1, tile2] = selectedTiles;

            if (tile1.dataset.type === tile2.dataset.type) {
                const pathInfo = findPathBFS(tile1, tile2); // Get path info

                if (pathInfo) {
                    // Match found!
                    drawPath(pathInfo.path, tile1, tile2); // Draw the path

                    // Mark tiles for removal animation
                    tile1.classList.add('removing');
                    tile2.classList.add('removing');
                    tile1.classList.remove('selected');
                    tile2.classList.remove('selected');

                    // Update board state
                    const r1 = parseInt(tile1.dataset.row);
                    const c1 = parseInt(tile1.dataset.col);
                    const r2 = parseInt(tile2.dataset.row);
                    const c2 = parseInt(tile2.dataset.col);
                    boardState[r1][c1] = null;
                    boardState[r2][c2] = null;

                    // After animation, set to 'removed'
                    setTimeout(() => {
                        tile1.classList.add('removed');
                        tile2.classList.add('removed');
                        tile1.classList.remove('removing'); // Clean up animation class
                        tile2.classList.remove('removing');
                        checkGameOver(); // Check win condition after tiles are visually gone
                    }, 300); // Match animation duration

                    selectedTiles = []; // Clear selection immediately
                    return; // Exit early as match was found
                }
            }

            // No match or no path, deselect after a short delay
            setTimeout(() => {
                tile1.classList.remove('selected');
                tile2.classList.remove('selected');
                selectedTiles = [];
            }, 300);
        }

        // --- Pathfinding using Breadth-First Search (BFS) ---

        function findPathBFS(tile1, tile2) {
            const startR = parseInt(tile1.dataset.row);
            const startC = parseInt(tile1.dataset.col);
            const endR = parseInt(tile2.dataset.row);
            const endC = parseInt(tile2.dataset.col);

            // Create a padded grid for BFS to allow paths around the edges
            const gridH = ROWS + 2;
            const gridW = COLS + 2;
            const bfsGrid = Array(gridH).fill(0).map(() => Array(gridW).fill(0)); // 0 = empty, 1 = blocked

            // Populate grid, mapping board coords to BFS coords (r+1, c+1)
            for (let r = 0; r < ROWS; r++) {
                for (let c = 0; c < COLS; c++) {
                    if (boardState[r][c] && !(r === startR && c === startC) && !(r === endR && c === endC)) {
                        bfsGrid[r + 1][c + 1] = 1; // Mark occupied cells as blocked
                    }
                }
            }

            const startNode = { r: startR + 1, c: startC + 1, turns: -1, path: [] }; // Start with -1 turns
            const queue = [startNode];
            const visited = {}; // Store min turns to reach a cell: visited[`${r}-${c}`] = turns

            const directions = [
                { dr: -1, dc: 0 }, // Up
                { dr: 1, dc: 0 },  // Down
                { dr: 0, dc: -1 }, // Left
                { dr: 0, dc: 1 }   // Right
            ];

            while (queue.length > 0) {
                const current = queue.shift();
                const { r, c, turns, path } = current;
                const posKey = `${r}-${c}`;

                // Check if already visited with fewer or equal turns
                if (visited[posKey] !== undefined && visited[posKey] <= turns) {
                    continue;
                }
                 // Pruning: If we exceed 2 turns, don't explore further from here
                 if (turns > 2) {
                    continue;
                 }

                visited[posKey] = turns;

                // Check if we reached the destination
                 if (r === endR + 1 && c === endC + 1) {
                     // Ensure the path to the end doesn't exceed 2 turns
                     if (turns <= 2) {
                         return { path: path, turns: turns }; // Found a valid path
                     } else {
                        continue; // Found the target but with too many turns via this route
                     }
                 }


                // Explore neighbors
                for (const dir of directions) {
                    let nr = r + dir.dr;
                    let nc = c + dir.dc;
                    let currentDir = path.length > 0 ? { dr: r - path[path.length - 1].r, dc: c - path[path.length - 1].c } : null; // Direction entering current cell

                    // Move along the current direction until hitting boundary or block
                    while (nr >= 0 && nr < gridH && nc >= 0 && nc < gridW && bfsGrid[nr][nc] === 0) {
                        const nextPosKey = `${nr}-${nc}`;
                        let newTurns = turns;

                        // Check if turning
                         // A turn happens when the direction changes from the previous segment
                        if(currentDir && (dir.dr !== currentDir.dr || dir.dc !== currentDir.dc)){
                             newTurns = turns + 1;
                         } else if (!currentDir && path.length === 0) {
                             // First move from start always counts as 0 turns relative to start
                             newTurns = 0; // Corrected: first segment starts turn count
                         }


                        // If this path is valid (<= 2 turns and better than previous visits)
                        if (newTurns <= 2 && (visited[nextPosKey] === undefined || visited[nextPosKey] > newTurns)) {
                            const newPath = [...path, { r: r, c: c }]; // Add the *previous* cell as a corner/segment point
                             const nextNode = { r: nr, c: nc, turns: newTurns, path: newPath };
                             queue.push(nextNode);
                        }

                         // If we reached the target cell while moving straight, check turns immediately
                         if (nr === endR + 1 && nc === endC + 1) {
                            if (newTurns <= 2) {
                                 // Need to construct the final path including the start and end points correctly
                                 const finalPath = [...path, { r: r, c: c }]; // Add the point before the target
                                 return { path: finalPath, turns: newTurns };
                             } else {
                                 break; // Stop extending in this direction if target found but too many turns
                             }
                         }

                        // Move to the next cell in the same direction
                        nr += dir.dr;
                        nc += dir.dc;
                    }
                }
            }

            return null; // No path found within 2 turns
        }


        // --- Path Drawing ---

        function getTileCenter(tile) {
            // Calculate center relative to the gameWrapper (which contains the SVG overlay)
            const tileRect = tile.getBoundingClientRect();
            const wrapperRect = gameWrapper.getBoundingClientRect(); // Use wrapper

            const tileWidth = tileRect.width;
            const tileHeight = tileRect.height;

            // Center position relative to top-left of the wrapper
            const x = tileRect.left - wrapperRect.left + tileWidth / 2;
            const y = tileRect.top - wrapperRect.top + tileHeight / 2;

            return { x, y };
        }

        function drawPath(pathPointsBFS, tile1, tile2) {
            pathOverlay.innerHTML = ''; // Clear previous path

            const startPoint = getTileCenter(tile1);
            const endPoint = getTileCenter(tile2);

            // Convert BFS path points (which are grid indices of empty cells/corners) to pixel coordinates
            // The BFS path points are relative to the padded grid (r+1, c+1)
            // We need the center of the corresponding *visual* grid cell or gap.

            const points = [startPoint]; // Start at the center of the first tile

             // Get grid geometry for calculating cell centers from indices
            const gridRect = gameContainer.querySelector('.grid').getBoundingClientRect();
            const wrapperRect = gameWrapper.getBoundingClientRect();
            const gridLeft = gridRect.left - wrapperRect.left;
            const gridTop = gridRect.top - wrapperRect.top;

            const cellWidth = gridRect.width / COLS; // Includes gap conceptually here, adjust if needed
            const cellHeight = gridRect.height / ROWS;
            // More precise calculation considering gaps:
            const firstTile = div.querySelector('.tile:not(.removed)'); // Get any tile for size
             if (!firstTile) return; // Should not happen if called correctly
            const tileStyle = window.getComputedStyle(firstTile);
            const tileWidth = firstTile.offsetWidth;
            const tileHeight = firstTile.offsetHeight;
            const gap = parseFloat(window.getComputedStyle(gameContainer.querySelector('.grid')).gap) || 0; // Get computed gap

            pathPointsBFS.slice(1).forEach(p => { // Skip the first point (start node position)
                 // Convert BFS padded coords (r, c) back to original grid coords (r-1, c-1)
                 const gridR = p.r - 1;
                 const gridC = p.c - 1;

                 // Calculate center of this grid cell (which was empty in BFS)
                 const x = gridLeft + gridC * (tileWidth + gap) + tileWidth / 2;
                 const y = gridTop + gridR * (tileHeight + gap) + tileHeight / 2;
                 points.push({ x, y });
            });


            points.push(endPoint); // End at the center of the second tile

            // Create SVG polyline
            const polyline = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
            const pointsAttr = points.map(p => `${p.x},${p.y}`).join(' ');
            polyline.setAttribute('points', pointsAttr);

            pathOverlay.appendChild(polyline);

            // Remove the path after a short delay
            setTimeout(() => {
                if (pathOverlay.contains(polyline)) {
                     pathOverlay.removeChild(polyline);
                }
            }, 500); // Display duration for the path
        }

        // --- Game State ---

        function checkGameOver() {
            // Check if any tiles remain that are not marked as removed
            const remaining = gameContainer.querySelectorAll('.tile:not(.removed)');
            if (remaining.length === 0) {
                clearInterval(my.timerId2);
                // Use setTimeout to allow final removal animation to potentially finish
                setTimeout(() => alert(`游戏胜利！用时: ${timer} 秒`), 100);
            }
             // Optional: Add logic here to check if any possible moves remain if needed (reshuffle/game over)
        }

        function startGame() {
            // Reset score removed
            timer = 0;
            clearInterval(my.timerId2);
            selectedTiles = [];
            timerDisplay.textContent = '0';
            createGame();

            my.timerId2 = setInterval(() => {
                timer++;
                timerDisplay.textContent = timer;
            }, 1000);
        }

        // --- Initial Load ---
				startGame(); // Start game

}

function newg(){
	overlay();
	overlay('jsload',1,my.js);
}