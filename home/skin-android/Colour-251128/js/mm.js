var htmltxt=`
        <div class="gameContainer">
            <div class="gameStatus">
                <div id="alert"></div>
                <div class="flagContainer">🚩<div id="flag"></div></div>
                <div class="timerContainer">⏰<div id="timer">0</div></div>
            </div>
            <div class="gameBoard"></div>
        </div>
`

	function jsload(on = true) {
		const MINE_COUNT = 20; // 雷数量
		var div=$(".jsload");
			const gameContainer = div.querySelector(".gameContainer");
			if (!gameContainer) {
					console.error("Game container not found!");
					return;
			}
			const gameBoard = gameContainer.querySelector(".gameBoard");
			const alertDiv = div.querySelector("#alert");
			const timerDiv = div.querySelector("#timer");
			const flagDiv = div.querySelector("#flag");

			// --- Reset logic ---
			gameBoard.innerHTML = "";
			alertDiv.style.display = "none";
			timerDiv.innerHTML = "0";
			flagDiv.innerHTML = MINE_COUNT;
			stopTimer();

			if (!on) {
				return;
			}

			// --- Game Setup ---
			const cols = 16;
			const rows = 9;
			let move = 0;
			let flagsLeft = MINE_COUNT;
			let clearedNumber = 0;
			let seconds = 0;
			let boardCellsArray = null;
			let gameOver = false;

			const directions = [
					[-1, -1], [-1, 0], [-1, 1],
					[0, -1],          [0, 1],
					[1, -1], [1, 0], [1, 1]
			];

			// --- Initialization Functions ---
			function fillBoardCellsArray() {
					boardCellsArray = new Array(rows);
					for (let i = 0; i < rows; i++) {
							boardCellsArray[i] = new Array(cols);
							for (let j = 0; j < cols; j++) {
									// [value, isRevealed, isFlagged]
									// value: -1 (mine), 0-8 (neighbor mines)
									boardCellsArray[i][j] = [0, false, false];
							}
					}
			}

			function setupBoard() {
					gameBoard.innerHTML = '';
					alertDiv.style.display = "none";
					gameOver = false;
					let counter = 0;

					for (let i = 0; i < rows; i++) {
							for (let j = 0; j < cols; j++) {
									counter++;
									let squareColor = ((i + j) % 2 === 0) ? "light" : "dark"; // Better checkerboard

									let cell = document.createElement("div");
									cell.classList.add("cell");
									cell.classList.add(squareColor);
									cell.dataset.row = i;
									cell.dataset.col = j;

									gameBoard.appendChild(cell);

									// --- Event Listeners ---
									cell.addEventListener("click", onCellClick);
									cell.addEventListener("contextmenu", onCellRightClick); // Right-click for flagging

									// Touch Events
									cell.addEventListener("touchstart", handleTouchStart, { passive: true }); // Passive for performance
									cell.addEventListener("touchmove", handleTouchMove, { passive: true });
									cell.addEventListener("touchend", handleTouchEnd);
							}
					}
			}

			// --- Mine Placement and Calculation ---
			function placeMines(clickedRow, clickedCol) {
					let minesPlaced = 0;
					while (minesPlaced < MINE_COUNT) {
							let row = Math.floor(Math.random() * rows);
							let col = Math.floor(Math.random() * cols);

							// Place mine if cell is not the first clicked and doesn't already have a mine
							if (!(row === clickedRow && col === clickedCol) && boardCellsArray[row][col][0] !== -1) {
									boardCellsArray[row][col][0] = -1; // Mark as mine
									minesPlaced++;
							}
					}

					// Calculate neighbor counts
					for (let i = 0; i < rows; i++) {
							for (let j = 0; j < cols; j++) {
									if (boardCellsArray[i][j][0] !== -1) { 
											boardCellsArray[i][j][0] = getNumberOfMineInVicinity(i, j);
									}
							}
					}
			}

			function getNumberOfMineInVicinity(row, col) {
					let mines = 0;
					for (let i = 0; i < directions.length; i++) {
							const [dr, dc] = directions[i];
							const nr = row + dr; // Neighbor row
							const nc = col + dc; // Neighbor col

							// Check bounds and if neighbor is a mine
							if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && boardCellsArray[nr][nc][0] === -1) {
									mines++;
							}
					}
					return mines;
			}

			// --- Timer Functions ---
			function startTimer() {
					if (my.timerId2) clearInterval(my.timerId2); // Clear previous if any
					seconds = 0; // Reset seconds count
					timerDiv.innerHTML = seconds; // Update display immediately
					my.timerId2 = setInterval(() => {
							seconds++;
							timerDiv.innerHTML = seconds;
					}, 1000);
			}

			function stopTimer() {
					clearInterval(my.timerId2);
					my.timerId2 = null;
			}

			// --- Event Handlers ---

			// Touch handling variables
			let touchStartX = null;
			let touchStartY = null;
			let touchStartTime = null;
			let touchTimeout = null;
			const LONG_PRESS_THRESHOLD = 500; // milliseconds

			function handleTouchStart(event) {
					const touch = event.touches[0];
					touchStartX = touch.clientX;
					touchStartY = touch.clientY;
					touchStartTime = Date.now();

					// Clear any previous timeout
					clearTimeout(touchTimeout);

					// Set a timeout to detect long press
					const targetCell = event.target.closest(".cell");
					touchTimeout = setTimeout(() => {
						 // Long press detected
						 touchTimeout = null; // Clear timeout flag
						 touchStartX = null; // Prevent click/swipe after long press
						 touchStartTime = null;
						 onCellRightClick({ target: targetCell, preventDefault: () => {} }); // Simulate right click
					}, LONG_PRESS_THRESHOLD);
			}

			function handleTouchMove(event) {
					if (!touchStartX || !touchStartTime) return; // Exit if touch didn't start properly or long press occurred

					const touch = event.touches[0];
					const deltaX = Math.abs(touch.clientX - touchStartX);
					const deltaY = Math.abs(touch.clientY - touchStartY);

					// If significant movement, cancel the long press timeout
					if (deltaX > 10 || deltaY > 10) {
							clearTimeout(touchTimeout);
							touchTimeout = null;
							// Optionally handle swipe here if needed
					}
			}

			function handleTouchEnd(event) {
					 clearTimeout(touchTimeout);

					 if (touchTimeout !== null && touchStartTime !== null) {
							 const tapDuration = Date.now() - touchStartTime;
							 if (tapDuration < LONG_PRESS_THRESHOLD) {
										onCellClick({ target: event.target.closest(".cell") });
							 }
					 }
					 // Reset touch tracking variables
					 touchStartX = null;
					 touchStartY = null;
					 touchStartTime = null;
					 touchTimeout = null; // Ensure it's cleared
			}


			function onCellClick(event) {
					if (gameOver) return;

					let clickedSquare = event.target.closest(".cell");
					if (!clickedSquare) return; // Click might be on the gap

					let row = parseInt(clickedSquare.dataset.row);
					let col = parseInt(clickedSquare.dataset.col);
					let cellData = boardCellsArray[row][col];

					// Ignore clicks on revealed or flagged cells
					if (cellData[1] || cellData[2]) {
							return;
					}

					// First move actions
					if (move === 0) {
							placeMines(row, col);
							startTimer();
					}
					move++;

					// Check for mine click
					if (cellData[0] === -1) {
							revealAllMines(row, col); // Pass clicked mine coords
							showAlert("失败是成功的前奏! 🙄");
							gameOver = true;
							stopTimer();
							removeEventListenersFromCells();
							return;
					}

					// Clear cells (flood fill if empty)
					clearCells(row, col);
					updateHTMLBoard(); // Update visuals

					// Check for win condition
					// Win condition: All non-mine cells are revealed
					 if (clearedNumber === rows * cols - MINE_COUNT) {
							showAlert("好样的! 👍");
							gameOver = true;
							stopTimer();
							flagAllMines(); // Optional: Automatically flag remaining mines on win
							updateHTMLBoard(); // Show flagged mines
							removeEventListenersFromCells();
					 }
			}

			function onCellRightClick(event) {
					event.preventDefault(); // Prevent context menu
					if (gameOver) return;

					let clickedSquare = event.target.closest(".cell");
					 if (!clickedSquare) return;

					let row = parseInt(clickedSquare.dataset.row);
					let col = parseInt(clickedSquare.dataset.col);
					let cellData = boardCellsArray[row][col];

					// Can't flag already revealed cells
					if (cellData[1]) {
							return;
					}

					// Toggle flag state
					if (cellData[2]) { // If currently flagged, unflag
							cellData[2] = false;
							flagsLeft++;
							clickedSquare.innerHTML = ""; // Remove flag visual
					} else { // If not flagged, flag (if flags are available)
							if (flagsLeft > 0) {
									cellData[2] = true;
									flagsLeft--;
									clickedSquare.innerHTML = '<span>🚩</span>'; // Add flag visual
							}
					}

					// Update flag counter display
					flagDiv.innerHTML = flagsLeft;
			}

			function removeEventListenersFromCells() {
					div.querySelectorAll(".cell").forEach((element) => {
							// Clone and replace to remove all listeners efficiently
							let newElement = element.cloneNode(true);
							element.parentNode.replaceChild(newElement, element);
					});
			}

			// --- Cell Clearing Logic ---
			function clearCells(startRow, startCol) {
					let queue = [[startRow, startCol]];
					let visited = new Set(); // Keep track of visited cells in this clearing operation
					visited.add(`${startRow},${startCol}`);

					while (queue.length > 0) {
							let [row, col] = queue.shift();
							let cellData = boardCellsArray[row][col];

							// Skip if already revealed or flagged
							if (cellData[1] || cellData[2]) {
									continue;
							}

							// Reveal the cell
							cellData[1] = true;
							clearedNumber++;

							// If cell has a number (not empty), stop expanding from here
							if (cellData[0] > 0) {
									continue;
							}

							// If cell is empty (value 0), explore neighbors
							for (let i = 0; i < directions.length; i++) {
									const [dr, dc] = directions[i];
									const nr = row + dr;
									const nc = col + dc;
									const neighborKey = `${nr},${nc}`;

									// Check bounds and if neighbor not visited in this batch
									if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && !visited.has(neighborKey)) {
											 let neighborData = boardCellsArray[nr][nc];
											 // Only add valid, unrevealed, unflagged neighbors to the queue
											 if (!neighborData[1] && !neighborData[2]) {
													 visited.add(neighborKey);
													 queue.push([nr, nc]);
											 }
									}
							}
					}
			}


			// --- Update Display ---
			function updateHTMLBoard() {
					for (let row = 0; row < rows; row++) {
							for (let col = 0; col < cols; col++) {
									let cell = gameBoard.querySelector(`.cell[data-row='${row}'][data-col='${col}']`);
									if (!cell) continue;

									let cellData = boardCellsArray[row][col];
									let value = cellData[0];
									let isRevealed = cellData[1];
									let isFlagged = cellData[2];

									// Clear existing content/styles first unless flagged
									if (!isFlagged) {
											 cell.innerHTML = "";
											 // Remove number classes
											 cell.className = cell.className.replace(/value\d/g, '').trim();
									} else if (isFlagged && cell.innerHTML !== '<span>🚩</span>') {
											 // Ensure flagged cells show the flag
											 cell.innerHTML = '<span>🚩</span>';
									}


									if (isRevealed) {
											// Remove flag if it was revealed (e.g., by flood fill)
											if (isFlagged) {
													cellData[2] = false; // Correct the state
													flagsLeft++; // Give flag back (shouldn't happen often with click guards)
													flagDiv.innerHTML = flagsLeft;
											}

											let baseColorClass = cell.classList.contains("light") ? "light" : "dark";
											cell.classList.add(`${baseColorClass}Cleared`); // Mark as cleared background

											if (value > 0) {
													cell.innerHTML = value;
													cell.classList.add(`value${value}`); // Add number color class
											} else if (value === 0) {
													cell.innerHTML = ""; // Ensure empty revealed cells are blank
											}
											// Note: Mines (value -1) revealed by clicking are handled by revealAllMines
									}
							}
					}
			}

			function revealAllMines(clickedRow, clickedCol) {
					 for (let row = 0; row < rows; row++) {
							for (let col = 0; col < cols; col++) {
									let cellData = boardCellsArray[row][col];
									let cell = gameBoard.querySelector(`.cell[data-row='${row}'][data-col='${col}']`);
									if (!cell) continue;

									if (cellData[0] === -1) { // If it's a mine
											cell.classList.remove("light", "dark"); // Remove base colors
											cell.classList.add(cell.classList.contains("lightCleared") || cell.classList.contains("darkCleared") ? "" : "darkCleared"); // Use a cleared bg
											if (row === clickedRow && col === clickedCol) {
													cell.style.backgroundColor = 'red'; // Highlight the clicked mine
													cell.innerHTML = '<span>💥</span>';
											} else if (cellData[2]) { // Correctly flagged mine
													cell.innerHTML = '<span>🚩</span>'; // Keep flag
													cell.style.backgroundColor = 'lightgreen'; // Indicate correct flag
											}
											 else {
													cell.innerHTML = '<span>💣</span>'; // Show bomb
											}
									} else if (cellData[2]) { // If it's flagged BUT not a mine (incorrect flag)
											 cell.innerHTML = '<span>❌</span>'; // Show incorrect flag marker
											 cell.style.backgroundColor = 'pink';
									}
							}
					}
			}

			// Optional: Flag all remaining mines automatically on win
			 function flagAllMines() {
					 let flagsPlaced = 0;
					 for (let row = 0; row < rows; row++) {
							for (let col = 0; col < cols; col++) {
									let cellData = boardCellsArray[row][col];
									if (cellData[0] === -1 && !cellData[2]) {
											cellData[2] = true;
											flagsPlaced++;
									}
							}
					}
					flagsLeft -= flagsPlaced;
					flagDiv.innerHTML = flagsLeft < 0 ? 0 : flagsLeft; // Prevent negative flags display
			 }


			function showAlert(mes) {
					alertDiv.innerHTML = `<div>${mes}</div> <button class="newGame">重玩</button>`;
					alertDiv.style.display = "flex";
					alertDiv.querySelector('.newGame').addEventListener('click', () => jsload(true)); // Pass true to restart
					stopTimer();
			}

			// --- Initial Game Start ---
			fillBoardCellsArray();
			setupBoard();

	}


