var htmltxt=`
		<div id="status">连接水管！</div>
    <div class="game-container">
        <div class="game-info">
            <div id="timer">时间: 00:00</div>
            <!-- Level Navigation -->
            <div class="level-controls">
                <button id="prev-level-button" class="level-nav-btn">上一关</button>
                <span id="current-level-display">关卡: 1</span>
                <button id="next-level-button" class="level-nav-btn">下一关</button>
            </div>
        </div>
        <div id="game-board"></div>
        <div class="controls">
             <!-- Restart Button -->
            <button id="reset-button">重玩本关</button>
        </div>
    </div>
`;

function jsload(){
    //document.addEventListener('DOMContentLoaded', () => {
        const gameBoardElement = document.getElementById('game-board');
        const statusElement = document.getElementById('status');
        const timerElement = document.getElementById('timer');
        // New UI Elements
        const resetButton = document.getElementById('reset-button');
        const prevLevelButton = document.getElementById('prev-level-button');
        const nextLevelButton = document.getElementById('next-level-button');
        const currentLevelDisplay = document.getElementById('current-level-display');


        // --- Level Data (Array of levels) ---
        const allLevels = [
            // Level 1 (Easy)
            {
                size: 5,
                data: [
					['L', 'I', 'L', 'I', 'L'],
					['I', 'S', 'L', 'L', 'L'],
					['L', 'I', 'L', 'I', 'L'],
					['I', 'L', 'I', 'I', 'E'],
					['L', 'L', 'I', 'L', ' ']
                ]
            },
            // Level 2 (Medium)
            {
                size: 6,
                 data: [
					[' ', ' ', 'S', 'L', ' ', ' '],
					[' ', 'L', 'L', 'L', 'L', ' '],
					[' ', 'I', 'L', 'I', 'L', ' '],
					[' ', 'L', 'L', 'L', 'I', 'E'],
					[' ', ' ', 'L', 'L', ' ', ' '],
					[' ', ' ', ' ', ' ', ' ', ' ']
                ]
            },
            // Level 3 (Hard)
            {
                size: 7,
                data: [
      [' ', ' ', ' ', 'S', 'L', ' ', ' '],
      [' ', 'L', 'I', 'L', 'L', 'L', ' '],
      [' ', 'L', 'L', 'I', ' ', 'L', 'L'],
      [' ', ' ', 'I', 'L', 'I', 'I', 'L'],
      [' ', 'L', 'L', ' ', 'L', 'I', 'E'],
      [' ', 'L', 'I', 'I', 'L', ' ', ' '],
      [' ', ' ', ' ', ' ', ' ', ' ', ' ']
                ]
            },
            // Level 4 (Example - Add more levels here!)
            {
                size: 5,
                data: [
      ['S', 'I', 'L', 'L', 'L'],
      ['L', 'I', 'L', 'L', 'I'],
      ['I', 'L', 'I', 'L', 'I'],
      ['I', 'I', 'L', 'L', 'L'],
      ['L', 'L', 'L', 'L', 'E']
                ]
            }
            // Add more level objects as needed
        ];

        // --- Pipe Type Definitions ---
        const Directions = { TOP: 0, RIGHT: 1, BOTTOM: 2, LEFT: 3 };
        const pipeTypes = {
            'S': { connections: [false, true, false, false], rotatable: false, class: 'pipe-start' },
            'E': { connections: [false, false, false, true], rotatable: false, class: 'pipe-end' },
            'I': { connections: [true, false, true, false], rotatable: true, class: 'pipe-straight' },
            'L': { connections: [true, true, false, false], rotatable: true, class: 'pipe-corner' }
        };
        const neighborChecks = [
            { dr: -1, dc: 0, currentIdx: Directions.TOP, neighborIdx: Directions.BOTTOM },
            { dr: 0, dc: 1, currentIdx: Directions.RIGHT, neighborIdx: Directions.LEFT },
            { dr: 1, dc: 0, currentIdx: Directions.BOTTOM, neighborIdx: Directions.TOP },
            { dr: 0, dc: -1, currentIdx: Directions.LEFT, neighborIdx: Directions.RIGHT }
        ];

        // --- Game State Variables ---
        let boardData = [];
        let gameWon = false;
        let gameTime = 0;
        let timerInterval = null;
        let currentLevelIndex = 0; // Start at the first level
        let ROWS = 0;
        let COLS = 0;

        // --- Core Functions ---

        /**
         * Initializes or resets the game for a specific level index.
         * @param {number} levelIndex - The index of the level in the allLevels array.
         */
        function initGame(levelIndex) {
            if (levelIndex < 0 || levelIndex >= allLevels.length) {
                console.error("Invalid level index:", levelIndex);
                statusElement.textContent = "错误：无效的关卡！";
                return;
            }

            currentLevelIndex = levelIndex; // Update current level index
            const levelConfig = allLevels[currentLevelIndex]; // Get config for the current level

            clearInterval(timerInterval);
            timerInterval = null; // Ensure timer is reset
            gameTime = 0;
            updateTimerDisplay();
            gameWon = false;
            statusElement.textContent = '连接水管！';
            statusElement.style.color = '#555';

            ROWS = levelConfig.size;
            COLS = levelConfig.size;
            const levelLayout = levelConfig.data;

            renderBoard(levelLayout); // Render the board
            checkConnections(); // Perform initial connection check

            // Update UI elements
            updateLevelDisplay();
            updateNavigationButtons();

            // Start timer only if game is not already won and board exists
             if (!gameWon && ROWS > 0) {
                 timerInterval = setInterval(updateTimer, 1000);
             }
        }

        /** Updates the level display element */
        function updateLevelDisplay() {
            currentLevelDisplay.textContent = `关卡: ${currentLevelIndex + 1} / ${allLevels.length}`;
        }

        /** Updates the enabled/disabled state of navigation buttons */
        function updateNavigationButtons() {
            prevLevelButton.disabled = currentLevelIndex <= 0;
            nextLevelButton.disabled = currentLevelIndex >= allLevels.length - 1;
        }


        /** Updates the timer display */
        function updateTimerDisplay() {
            const minutes = Math.floor(gameTime / 60).toString().padStart(2, '0');
            const seconds = (gameTime % 60).toString().padStart(2, '0');
            timerElement.textContent = `时间: ${minutes}:${seconds}`;
        }

        /** Game timer logic */
        function updateTimer() {
            if (!gameWon) {
                gameTime++;
                updateTimerDisplay();
            } else {
                clearInterval(timerInterval);
                timerInterval = null;
            }
        }

        /** Gets pipe connections based on type and rotation */
        function getConnections(pipeType, rotation) {
            // ... (Function remains the same as before) ...
            const typeInfo = pipeTypes[pipeType];
            if (!typeInfo) return [false, false, false, false];
            const baseConnections = typeInfo.connections;
            if (!typeInfo.rotatable || rotation === 0) return baseConnections;
            const rotated = [...baseConnections];
            for (let r = 0; r < rotation; r++) { rotated.unshift(rotated.pop()); }
            return rotated;
        }

        /** Renders the game board */
        function renderBoard(levelLayout) {
            // ... (Function remains the same - creates outer/inner divs) ...
            gameBoardElement.innerHTML = '';
            gameBoardElement.style.gridTemplateColumns = `repeat(${COLS}, 1fr)`;
            boardData = [];
            const fragment = document.createDocumentFragment();

            for (let r = 0; r < ROWS; r++) {
                boardData[r] = [];
                for (let c = 0; c < COLS; c++) {
                    const pipeTypeCode = levelLayout[r]?.[c] ?? ' ';
                    const pipeInfo = pipeTypes[pipeTypeCode];

                    const cellElement = document.createElement('div');
                    cellElement.classList.add('pipe-cell');
                    cellElement.dataset.row = r;
                    cellElement.dataset.col = c;

                    const contentElement = document.createElement('div');
                    contentElement.classList.add('pipe-content');
                    cellElement.appendChild(contentElement);

                    let initialRotation = 0;
                    let isRotatable = false;

                    if (pipeInfo) {
                        cellElement.classList.add(pipeInfo.class);
                        isRotatable = pipeInfo.rotatable;
                        if (isRotatable) {
                            initialRotation = Math.floor(Math.random() * 4);
                        } else {
                            cellElement.classList.add('no-rotate');
                        }
                        cellElement.classList.add(`rotate-${initialRotation * 90}`);
                        cellElement.style.setProperty('--current-rotation', `${initialRotation * 90}deg`);
                    } else {
                        cellElement.classList.add('no-rotate');
                        cellElement.style.cursor = 'default';
                    }

                    boardData[r][c] = {
                        type: pipeTypeCode, rotation: initialRotation, element: cellElement,
                        contentElement: contentElement, connected: false, winPath: false, rotatable: isRotatable
                    };
                    fragment.appendChild(cellElement);
                }
            }
            gameBoardElement.appendChild(fragment);
        }

        /** Handles clicks/touches on the game board */
        function handleBoardInteraction(event) {
            // ... (Function remains the same - rotates pipe, calls checkConnections) ...
            if (gameWon) return;
            const cellElement = event.target.closest('.pipe-cell');
            if (!cellElement) return;
            const r = parseInt(cellElement.dataset.row);
            const c = parseInt(cellElement.dataset.col);
            const pipe = boardData[r]?.[c];

            if (pipe && pipe.rotatable) {
                const oldRotationDegrees = pipe.rotation * 90;
                pipe.rotation = (pipe.rotation + 1) % 4;
                const newRotationDegrees = pipe.rotation * 90;
                cellElement.classList.remove(`rotate-${oldRotationDegrees}`);
                cellElement.classList.add(`rotate-${newRotationDegrees}`);
                cellElement.style.setProperty('--current-rotation', `${newRotationDegrees}deg`);
                checkConnections(); // Check connections after rotation
            }
        }

        /** Checks connections and win state */
        function checkConnections() {
            // ... (Function remains mostly the same - uses BFS, updates classes on outer element) ...
            let startPipeCoords = null;
            let endPipeCoords = null;

            boardData.flat().forEach(pipe => {
                if (pipe && pipe.element) {
                    pipe.connected = false;
                    pipe.winPath = false;
                    pipe.element.classList.remove('connected', 'win-path');
                    const r = parseInt(pipe.element.dataset.row);
                    const c = parseInt(pipe.element.dataset.col);
                    if (pipe.type === 'S') startPipeCoords = { r, c };
                    if (pipe.type === 'E') endPipeCoords = { r, c };
                }
            });

            if (!startPipeCoords || !endPipeCoords) return;

            const queue = [startPipeCoords];
            const visited = new Set([`${startPipeCoords.r}-${startPipeCoords.c}`]);
            const path = {};

             if (boardData[startPipeCoords.r]?.[startPipeCoords.c]) {
                 const startPipeData = boardData[startPipeCoords.r][startPipeCoords.c];
                 startPipeData.connected = true;
                 startPipeData.element.classList.add('connected');
             } else { return; }

            while (queue.length > 0) {
                const current = queue.shift();
                const { r, c } = current;
                const currentPipe = boardData[r]?.[c];
                if (!currentPipe || !currentPipe.type) continue;
                const currentConnections = getConnections(currentPipe.type, currentPipe.rotation);

                for (const check of neighborChecks) {
                    const nr = r + check.dr;
                    const nc = c + check.dc;
                    const neighborKey = `${nr}-${nc}`;
                    if (nr >= 0 && nr < ROWS && nc >= 0 && nc < COLS && !visited.has(neighborKey)) {
                        const neighborPipe = boardData[nr]?.[nc];
                        if (neighborPipe && neighborPipe.type) {
                            const neighborConnections = getConnections(neighborPipe.type, neighborPipe.rotation);
                            if (currentConnections[check.currentIdx] && neighborConnections[check.neighborIdx]) {
                                visited.add(neighborKey);
                                neighborPipe.connected = true;
                                neighborPipe.element.classList.add('connected');
                                path[neighborKey] = current;
                                queue.push({ r: nr, c: nc });
                            }
                        }
                    }
                }
            }

            const endPipe = boardData[endPipeCoords.r]?.[endPipeCoords.c];
            if (endPipe && endPipe.connected) {
                if (!gameWon) {
                    gameWon = true;
                    statusElement.textContent = `关卡 ${currentLevelIndex + 1} 完成！`; // Update win message
                    statusElement.style.color = '#2ecc71';
                    clearInterval(timerInterval);
                    timerInterval = null;

                    // Highlighting path remains the same
                    let current = endPipeCoords;
                    while (current) {
                        const key = `${current.r}-${current.c}`;
                        const pipe = boardData[current.r]?.[current.c];
                        if (pipe) { pipe.winPath = true; pipe.element.classList.add('win-path'); }
                        current = path[key];
                         if (current && path[`${current.r}-${current.c}`] === current) break;
                    }
                    // Optionally enable next button immediately on win if not last level
                    // updateNavigationButtons(); // Or just let user click manually
                }
            } else {
                if (gameWon) { // Handle state if connection breaks after winning (unlikely in normal play)
                    gameWon = false;
                    statusElement.textContent = '连接水管，让水流通过！';
                    statusElement.style.color = '#555';
                    if (timerInterval === null && ROWS > 0) {
                         timerInterval = setInterval(updateTimer, 1000);
                    }
                }
                 if (!gameWon && timerInterval === null && ROWS > 0) {
                     timerInterval = setInterval(updateTimer, 1000);
                 }
            }
        }


        // --- Event Listeners ---

        // Board Interaction
        gameBoardElement.addEventListener('click', handleBoardInteraction);
        let touchStartPos = null; // Touch handling remains the same
        gameBoardElement.addEventListener('touchstart', (e) => {
            if (e.touches.length === 1) { touchStartPos = { x: e.touches[0].clientX, y: e.touches[0].clientY }; }
            else { touchStartPos = null; }
        }, { passive: true });
        gameBoardElement.addEventListener('touchend', (e) => {
            if (touchStartPos && e.changedTouches.length === 1) {
                const touchEndPos = { x: e.changedTouches[0].clientX, y: e.changedTouches[0].clientY };
                const deltaX = Math.abs(touchEndPos.x - touchStartPos.x);
                const deltaY = Math.abs(touchEndPos.y - touchStartPos.y);
                if (deltaX < 10 && deltaY < 10) { e.preventDefault(); handleBoardInteraction(e); }
            }
            touchStartPos = null;
        });

        // Level Navigation Buttons
        prevLevelButton.addEventListener('click', () => {
            if (currentLevelIndex > 0) {
                initGame(currentLevelIndex - 1); // Load previous level
            }
        });

        nextLevelButton.addEventListener('click', () => {
            if (currentLevelIndex < allLevels.length - 1) {
                initGame(currentLevelIndex + 1); // Load next level
            }
        });

        // Reset Button (Restarts current level)
        resetButton.addEventListener('click', () => {
            initGame(currentLevelIndex); // Reload current level
        });

        // --- Initial Load ---
        if (allLevels && allLevels.length > 0) {
            initGame(0); // Start with the first level (index 0)
        } else {
            console.error("No levels defined in allLevels array.");
            statusElement.textContent = "错误：未定义关卡数据";
            // Disable navigation if no levels
            prevLevelButton.disabled = true;
            nextLevelButton.disabled = true;
            resetButton.disabled = true;
        }

    //});
}