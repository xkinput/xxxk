var htmltxt=`
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.2/dist/confetti.browser.min.js"></script>
    <h4>21步内填充所有格子为同一种色</h4>

    <div class="game-container">
        <div class="game-info">
            <div>步数: <span id="moves">0</span>/<span id="max-moves">21</span> <span id="infinite-indicator" class="infinite-moves" style="display: none;">(∞)</span></div>
            <div>尺寸: <span id="grid-size-display">10x10</span></div>
        </div>

        <div class="game-board" id="game-board"></div>

        <div class="controls">
            <div class="control-group">
                <label for="colors">颜色种类:</label>
                <select id="colors">
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6" selected>6</option>
                    <option value="8">8</option>
                </select>
            </div>

            <div class="control-group">
                <label for="grid-size">尺寸:</label>
                <select id="grid-size">
                    <option value="6">6x6</option>
                    <option value="8">8x8</option>
                    <option value="10" selected>10x10</option>
                    <option value="14">14x14</option>
                    <option value="20">20x20</option>
                </select>
            </div>

            <div class="control-group">
                <label for="grid-shape">Board Shape:</label>
                <select id="grid-shape">
                    <option value="square" selected>Square</option>
                    <option value="hexagon">Hexagon</option>
                    <option value="triangle">Triangle</option>
                </select>
            </div>

            <div class="control-group">
                <label for="obstacles">Obstacles:</label>
                <input type="checkbox" id="obstacles">

                <label for="special-cells">Special Cells:</label>
                <input type="checkbox" id="special-cells">

                <label for="infinite-moves">Infinite Moves:</label>
                <input type="checkbox" id="infinite-moves">
            </div>

            <div class="button-group">
                <button id="new-game-btn">新游戏</button>
            </div>
        </div>
    </div>

    <div class="help-button" id="help-button">?</div>

    <div class="modal" id="help-modal">
        <div class="modal-content">
            <h2>How to Play Flood-It</h2>

            <div class="rules-section">
                <h3>Game Objective</h3>
                <p>Fill the entire board with a single color in as few moves as possible.</p>
            </div>

            <div class="rules-section">
                <h3>How to Play</h3>
                <ul>
                    <li>You start from the top-left cell of the board.</li>
                    <li>Click on any cell to change the color of your flooded area to that color.</li>
                    <li>When you change color, all adjacent cells of the same color will join your flooded area.</li>
                    <li>Continue making moves until the entire board is a single color.</li>
                    <li>Try to complete the game within the move limit shown at the top.</li>
                    <li>Invalid moves (selecting the current flood color) don't count against your move limit.</li>
                </ul>
            </div>

            <div class="rules-section">
                <h3>Game Options</h3>
                <ul>
                    <li><strong>Number of Colors:</strong> Choose how many different colors appear on the board.</li>
                    <li><strong>Grid Size:</strong> Select the dimensions of the game board.</li>
                    <li><strong>Board Shape:</strong> Change the overall shape of the board and its cells:
                        <ul>
                            <li>Square: Traditional square grid</li>
                            <li>Hexagon: Hexagonal cells arranged in a honeycomb pattern</li>
                            <li>Triangle: Triangular cells arranged in a grid</li>
                        </ul>
                    </li>
                    <li><strong>Obstacles:</strong> Add black cells that cannot be flooded and must be worked around.</li>
                    <li><strong>Special Cells:</strong> Add star-marked cells with special properties.</li>
                    <li><strong>Infinite Moves:</strong> Toggle to play without a move limit for a more relaxed game.</li>
                </ul>
            </div>

            <div class="rules-section">
                <h3>Strategy Tips</h3>
                <ul>
                    <li>Look for colors that will connect large sections of the board.</li>
                    <li>Try to plan several moves ahead.</li>
                    <li>Sometimes it's better to make a move that doesn't immediately capture many cells but sets up a better position later.</li>
                    <li>With obstacles, you may need to flood around them to reach isolated areas.</li>
                </ul>
            </div>

            <div class="modal-buttons">
                <button id="close-help-btn">Close</button>
            </div>

        </div>
    </div>

    <div class="modal" id="win-modal">
        <div class="modal-content">
            <h2>好样的!</h2>
            <p>你完成游戏用了 <span id="final-moves">0</span> 步!</p>
            <div class="modal-buttons">
                <button id="new-game-modal-btn">新游戏</button>
            </div>
        </div>
    </div>

    <div class="modal" id="lose-modal">
        <div class="modal-content">
            <h4>游戏失败</h4>
            <p>步数用完了!</p>
            <div class="modal-buttons">
                <button id="try-again-btn">重玩</button>
            </div>
        </div>
    </div>
`;

function jsload(){
        // --- Game State ---
        let gameState = {
            board: [],
            size: 10,
            colors: 6,
            shape: 'square',
            hasObstacles: false,
            hasSpecialCells: false,
            infiniteMoves: false,
            moves: 0,
            maxMoves: 25,
            floodedCells: new Set(),
            colorPalette: [
                '#FF5252', // Red
                '#4CAF50', // Green
                '#2196F3', // Blue
                '#FFEB3B', // Yellow
                '#9C27B0', // Purple
                '#FF9800', // Orange
                '#00BCD4', // Cyan
                '#795548'  // Brown
            ]
        };

        // --- DOM Elements ---
        const gameBoard = document.getElementById('game-board');
        const movesDisplay = document.getElementById('moves');
        const maxMovesDisplay = document.getElementById('max-moves');
        const infiniteIndicator = document.getElementById('infinite-indicator');
        const gridSizeDisplay = document.getElementById('grid-size-display');
        const colorsSelect = document.getElementById('colors');
        const gridSizeSelect = document.getElementById('grid-size');
        const gridShapeSelect = document.getElementById('grid-shape');
        const obstaclesCheckbox = document.getElementById('obstacles');
        const specialCellsCheckbox = document.getElementById('special-cells');
        const infiniteMovesCheckbox = document.getElementById('infinite-moves');
        const newGameBtn = document.getElementById('new-game-btn');
        const helpButton = document.getElementById('help-button');
        const helpModal = document.getElementById('help-modal');
        const closeHelpBtn = document.getElementById('close-help-btn');
        const winModal = document.getElementById('win-modal');
        const loseModal = document.getElementById('lose-modal');
        const finalMovesDisplay = document.getElementById('final-moves');
        const newGameModalBtn = document.getElementById('new-game-modal-btn');
        const tryAgainBtn = document.getElementById('try-again-btn');

        // --- Game Functions ---

        // Initialize the game
        function initGame() {
            gameState.moves = 0;
            gameState.floodedCells = new Set();
            movesDisplay.textContent = gameState.moves;
            maxMovesDisplay.textContent = gameState.maxMoves;
            infiniteIndicator.style.display = gameState.infiniteMoves ? 'inline' : 'none';
            gridSizeDisplay.textContent = `${gameState.size}x${gameState.size}`;
            createBoard();
            const startCell = gameState.board[0][0];
            if (!startCell.isObstacle) {
                gameState.floodedCells.add('0,0');
                floodFill(0, 0, startCell.color, startCell.color);
                updateBoardDisplay();
            }
        }

        // Create the game board
        function createBoard() {
          gameState.board = [];
          gameBoard.innerHTML = '';
          gameBoard.style.gridTemplateColumns = `repeat(${gameState.size}, 30px)`;
          gameState.maxMoves = Math.floor(gameState.size * 1.5 + gameState.colors);
          maxMovesDisplay.textContent = gameState.maxMoves;

          for (let row = 0; row < gameState.size; row++) {
              gameState.board[row] = [];
              for (let col = 0; col < gameState.size; col++) {
                  const cell = document.createElement('div');
                  cell.className = 'cell';
                  cell.dataset.row = row;
                  cell.dataset.col = col;
                  let isObstacle = false;
                  let isSpecial = false;

                  if (gameState.hasObstacles && Math.random() < 0.05 && !(row === 0 && col === 0)) {
                      isObstacle = true;
                      cell.classList.add('obstacle');
                  } else if (gameState.hasSpecialCells && Math.random() < 0.05 && !(row === 0 && col === 0)) {
                      isSpecial = true;
                      cell.classList.add('special');
                  }
                  const colorIndex = Math.floor(Math.random() * gameState.colors);
                  const color = isObstacle ? '#000000' : gameState.colorPalette[colorIndex];
                  cell.style.backgroundColor = color;
                  gameBoard.appendChild(cell);
                  gameState.board[row][col] = { color, isObstacle, isSpecial };
                  cell.addEventListener('click', handleCellClick);
              }
          }
          if (gameState.shape !== 'square') {
              applyGridShape();
          }
        }
        // Handle cell click
        function handleCellClick(event) {
            const cell = event.target;
            const row = parseInt(cell.dataset.row);
            const col = parseInt(cell.dataset.col);
            const clickedColor = gameState.board[row][col].color;
            const currentColor = getCurrentFloodColor();

            if (clickedColor !== currentColor && !gameState.board[row][col].isObstacle) {
                makeMove(clickedColor);
            } else if (clickedColor === currentColor) {
                gameBoard.classList.add('invalid-move');
                setTimeout(() => gameBoard.classList.remove('invalid-move'), 500);
            }
        }

        // Get the current flood color
        function getCurrentFloodColor() {
            for (const coords of gameState.floodedCells) {
                const [row, col] = coords.split(',').map(Number);
                return gameState.board[row][col].color;
            }
            return null;
        }

        // Make a move
        function makeMove(newColor) {
            gameState.moves++;
            movesDisplay.textContent = gameState.moves;
            const currentColor = getCurrentFloodColor();
            const floodedCellsArray = Array.from(gameState.floodedCells);
            for (const coords of floodedCellsArray) {
                const [row, col] = coords.split(',').map(Number);
                floodFill(row, col, currentColor, newColor);
            }
            updateBoardDisplay();
            checkGameStatus();
        }

        // Flood fill
        function floodFill(row, col, oldColor, newColor) {
            if (!gameState.board[row][col].isObstacle) {
                gameState.board[row][col].color = newColor;
                gameState.floodedCells.add(`${row},${col}`);
            }
            const directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];
            for (const [dx, dy] of directions) {
                const newRow = row + dx;
                const newCol = col + dy;
                if (
                    newRow >= 0 && newRow < gameState.size &&
                    newCol >= 0 && newCol < gameState.size &&
                    gameState.board[newRow][newCol].color === oldColor &&
                    !gameState.board[newRow][newCol].isObstacle &&
                    !gameState.floodedCells.has(`${newRow},${newCol}`)
                ) {
                    floodFill(newRow, newCol, oldColor, newColor);
                }
            }
        }

        // Update board display
        function updateBoardDisplay() {
            const cells = document.querySelectorAll('.cell');
            cells.forEach(cell => {
                const row = parseInt(cell.dataset.row);
                const col = parseInt(cell.dataset.col);
                setTimeout(() => { cell.style.backgroundColor = gameState.board[row][col].color; }, 50 * (row + col) / 2);
            });
        }

      // Check game status (Win/Lose)
        function checkGameStatus() {
            const firstCell = gameState.board[0][0];
            let targetColor = firstCell.isObstacle ? null : firstCell.color;

            if (targetColor === null) {
                //If first cell is obstacle
                outerLoop:
                for (let r = 0; r < gameState.size; r++) {
                    for (let c = 0; c < gameState.size; c++) {
                        if (!gameState.board[r][c].isObstacle) {
                            targetColor = gameState.board[r][c].color;
                            break outerLoop;
                        }
                    }
                }
            }
            if (targetColor === null) return;

            for (let row = 0; row < gameState.size; row++) {
                for (let col = 0; col < gameState.size; col++) {
                    const cell = gameState.board[row][col];
                    if (!cell.isObstacle && cell.color !== targetColor) {
                        if (!gameState.infiniteMoves && gameState.moves >= gameState.maxMoves) {
                            setTimeout(() => { loseModal.style.display = 'flex'; }, 500);
                        }
                        return;
                    }
                }
            }

            finalMovesDisplay.textContent = gameState.moves;

            setTimeout(() => {
                winModal.style.display = 'flex';

                // --- Spectacular Confetti Effect (Improved) ---

                // Temporarily hide overflow to prevent scrollbars during confetti
                document.body.style.overflow = 'hidden';

                // Function to create a confetti burst (No Changes here)
                function confettiBurst(originX, angle) {
                    confetti({
                        particleCount: 200,
                        spread: 50,
                        angle: angle,
                        origin: { x: originX, y: 1 },
                        startVelocity: 60,
                        gravity: 0.8,
                        ticks: 300,
                        scalar: 1.2
                    });
                }

                // Left-to-right burst
                confettiBurst(0, 45);

                // Right-to-left burst
                confettiBurst(1, 135);

                // Additional smaller bursts (optional)
                confettiBurst(0, 60);
                confettiBurst(1, 120);

                // Restore overflow after confetti is done (adjust timeout as needed)
                setTimeout(() => {
                  document.body.style.overflow = ''; // Or 'auto' if you prefer
                }, 1000);  // 1 second delay (should be enough)

            }, 500);
        }


        // Apply grid shapes
        function applyGridShape() {
            const cells = document.querySelectorAll('.cell');
            if (gameState.shape === 'hexagon') {
                gameBoard.style.gridTemplateColumns = `repeat(${gameState.size}, 26px)`;
                cells.forEach((cell, index) => {
                    const row = Math.floor(index / gameState.size);
                    cell.style.clipPath = 'polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%)';
                    cell.style.margin = '0 -3px';
                    if (row % 2 === 1) { cell.style.transform = 'translateX(13px)'; }
                });
            } else if (gameState.shape === 'triangle') {
                gameBoard.style.gridTemplateColumns = `repeat(${gameState.size}, 30px)`;
                cells.forEach((cell, index) => {
                    const row = Math.floor(index / gameState.size);
                    const col = index % gameState.size;
                    if ((row + col) % 2 === 0) {
                        cell.style.clipPath = 'polygon(50% 0%, 100% 100%, 0% 100%)';
                    } else {
                        cell.style.clipPath = 'polygon(0% 0%, 100% 0%, 50% 100%)';
                    }
                });
            }
        }


        // --- Event Listeners ---
        newGameBtn.addEventListener('click', () => {
            gameState.size = parseInt(gridSizeSelect.value);
            gameState.colors = parseInt(colorsSelect.value);
            gameState.shape = gridShapeSelect.value;
            gameState.hasObstacles = obstaclesCheckbox.checked;
            gameState.hasSpecialCells = specialCellsCheckbox.checked;
            gameState.infiniteMoves = infiniteMovesCheckbox.checked;
            initGame();
        });

        newGameModalBtn.addEventListener('click', () => {
            winModal.style.display = 'none';
            gameState.size = parseInt(gridSizeSelect.value);
            gameState.colors = parseInt(colorsSelect.value);
            gameState.shape = gridShapeSelect.value;
            gameState.hasObstacles = obstaclesCheckbox.checked;
            gameState.hasSpecialCells = specialCellsCheckbox.checked;
            gameState.infiniteMoves = infiniteMovesCheckbox.checked;
            initGame();
        });

        tryAgainBtn.addEventListener('click', () => {
            loseModal.style.display = 'none';
            initGame();
        });

/*        helpButton.addEventListener('click', () => { helpModal.style.display = 'flex'; });
        closeHelpBtn.addEventListener('click', () => { helpModal.style.display = 'none'; });*/

        window.addEventListener('click', (event) => {
            if (event.target === helpModal) { helpModal.style.display = 'none'; }
            if (event.target === winModal) { winModal.style.display = 'none'; }
            if (event.target === loseModal) { loseModal.style.display = 'none'; }
        });

        window.addEventListener('load', initGame);
}
