var htmltxt=`
        <p id="status"></p>
    <h1><span class="red-text">★</span> 
 <span class="red-text">★</span></h1>

    <div id="game-container">
        <div id="game-board"></div>
        <button id="restart-button">重新开始游戏
</button>
    </div>

    <footer>
    </footer>
`;

function jsload(param) {
var div=document.querySelector(".jsload div div");
const boardSize = 15;
let board = [];
let currentPlayer = 'black';
let gameActive = true;

const gameBoard = div.querySelector('#game-board');
const statusDisplay = div.querySelector('#status');
const restartButton = div.querySelector('#restart-button');

div.addEventListener('DOMContentLoaded', () => {
  const popupContainer = div.querySelector('#popup-container');
  const closePopupButton = div.querySelector('#close-popup');

  closePopupButton.addEventListener('click', () => {
    popupContainer.classList.add('hidden');
  });
});

function initializeBoard() {
  board = Array(boardSize).fill(null).map(() => Array(boardSize).fill(null));
  gameBoard.innerHTML = '';
  for (let i = 0; i < boardSize; i++) {
    for (let j = 0; j < boardSize; j++) {
      const cell = document.createElement('div');
      cell.classList.add('cell');
      cell.dataset.row = i;
      cell.dataset.col = j;
      cell.addEventListener('click', handleCellClick);
      gameBoard.appendChild(cell);
    }
  }
  updateStatus();
}

function handleCellClick(event) {
  const row = event.target.dataset.row;
  const col = event.target.dataset.col;

  if (board[row][col] || !gameActive || currentPlayer === 'white') return;

  board[row][col] = currentPlayer;
  event.target.classList.add(currentPlayer);

  if (checkWin(row, col)) {
    statusDisplay.textContent = `${currentPlayer === 'black' ? '黑石' : '白石'} 你赢了。
`;
    statusDisplay.style.color = '#28a745';
    statusDisplay.classList.add('winner');
    gameActive = false;
  } else {
    currentPlayer = currentPlayer === 'black' ? 'white' : 'black';
    updateStatus();
    if (gameActive && currentPlayer === 'white') {
      setTimeout(aiMove, 500);
    }
  }
}

function aiMove() {
  if (!gameActive) return;

  const move = findBestMove();

  if (move) {
    placeStone(move.row, move.col);
  } else {
    const center = Math.floor(boardSize / 2);
    for (let i = 0; i < boardSize; i++) {
      for (let j = 0; j < boardSize; j++) {
        if (!board[i][j]) {
          placeStone(i, j);
          return;
        }
      }
    }
  }
}

function findBestMove() {
  const directions = [
    { rowDir: 1, colDir: 0 }, // 가로
    { rowDir: 0, colDir: 1 }, // 세로
    { rowDir: 1, colDir: 1 }, // 대각선 왼쪽으로
    { rowDir: 1, colDir: -1 } // 대각선 오른쪽으로
    ];

  let bestMove = null;
  let maxScore = -1;

  for (let i = 0; i < boardSize; i++) {
    for (let j = 0; j < boardSize; j++) {
      if (!board[i][j]) {
        for (const { rowDir, colDir } of directions) {
          const score = evaluateMove(i, j, rowDir, colDir);
          if (score > maxScore) {
            maxScore = score;
            bestMove = { row: i, col: j };
          }
        }
      }
    }
  }
  return bestMove;
}

function evaluateMove(row, col, rowDir, colDir) {
  let score = 0;

  score += countStones(row, col, rowDir, colDir, 'black') + countStones(row, col, -rowDir, -colDir, 'black');

  score += countStones(row, col, rowDir, colDir, 'white') + countStones(row, col, -rowDir, -colDir, 'white');

  return score;
}

function countStones(row, col, rowDir, colDir, player) {
  let r = parseInt(row) + rowDir;
  let c = parseInt(col) + colDir;
  let count = 0;

  while (r >= 0 && r < boardSize && c >= 0 && c < boardSize && board[r][c] === player) {
    count++;
    r += rowDir;
    c += colDir;
  }
  return count;
}

function placeStone(row, col) {
  board[row][col] = currentPlayer;
  const cell = div.querySelector(`[data-row="${row}"][data-col="${col}"]`);
  cell.classList.add(currentPlayer);

  if (checkWin(row, col)) {
		msgbox("你赢了",3000);
    statusDisplay.textContent = `${currentPlayer === 'black' ? '黑石' : '白石'} 你赢了。
`;
    statusDisplay.style.color = '#28a745';
    statusDisplay.classList.add('winner');
    gameActive = false;
  } else {
    currentPlayer = currentPlayer === 'black' ? 'white' : 'black';
    updateStatus();
  }
}

function checkWin(row, col) {
  return checkDirection(row, col, 1, 0) || // 가로
    checkDirection(row, col, 0, 1) || // 세로
    checkDirection(row, col, 1, 1) || // 대각선 \
    checkDirection(row, col, 1, -1); // 대각선 /
}

function checkDirection(row, col, rowDir, colDir) {
  let count = 1;
  count += countStones(row, col, rowDir, colDir, currentPlayer);
  count += countStones(row, col, -rowDir, -colDir, currentPlayer);
  return count >= 5;
}

function updateStatus() {
  statusDisplay.textContent = `${currentPlayer === 'black' ? '黑石' : '白石'} 轮到你了。`;
  statusDisplay.style.color = '#FFFFFF';
  statusDisplay.style.fontWeight = 'bold';
}

restartButton.addEventListener('click', () => {
  currentPlayer = 'black';
  gameActive = true;
  statusDisplay.classList.remove('winner');
  initializeBoard();
});

initializeBoard();
}