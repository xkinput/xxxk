var htmltxt=`
  <header class="gameOver">
    <span class='muted-text'>分数</span><span id="score" class='number-large accent-text'></span>
  </header>
  <div id='game-board' class="grid">
  <div id="end-game-container" class="end-game">
    <h1 id="end-game"></h1>
    <div>
      <p class='muted-text'>final score</p>
      <p id='end-score' class="number-large"></p>
    </div>
    <div>
      <p class='muted-text'>largest tile</p>
      <p class='muted-text'><small>this round</small></p>
      <p id="biggest" class="number-large"></p>
      <p class='muted-text'><small>all time</small></p>
      <p id="biggest-history" class="number-large"></p>
    </div>
    <div>
      <p class='muted-text'>high scores</p>
      <ol class="scores-list" id="scores-list">
      </ol>
    </div>
    <button class="btn" id="play-again">Play Again</button>

  </div>
`;

function jsload(){

var div=document.querySelector(".jsload div div");
const board = document.querySelector('#game-board')
const scoreContainer = document.querySelector('#score')
const endGameContainer = document.querySelector('#end-game-container')
const endGameOutcome = document.querySelector('#end-game')
const endGameScore = document.querySelector('#end-score')
const biggestSquareContainer = document.querySelector('#biggest')
const biggestSquareHistoryContainer = document.querySelector('#biggest-history')
const scoresListContainer = document.querySelector('#scores-list')
const playBtn = document.querySelector('#play-again')

const size = 4
let boardValues = []
let previousValues = []
let score = 0
let movesLeft = true
let previousDirection = 'null'

// object to pair each square with a class name based on value

const classObj = {
  0: 'zero',
  2: 'two',
  4: 'four',
  8: 'eight',
  16: 'sixteen',
  32: 'thirty-two',
  64: 'sixty-four',
  128: 'one-twenty-eight',
  256: 'two-fifty-six',
  512: 'five-twelve',
  1024: 'ten-twenty-four',
  2048: 'twenty-forty-eight',
  4096: 'forty-ninety-six',
  8192: 'eighty-one-ninety-two',
  16384: 'sixteen-three-eighty-four',
}

// grabs previous scores array and all time biggest tile from local storage

let previousScores = localStorage.getItem('previous')
  ? JSON.parse(localStorage.getItem('previous'))
  : []
let biggestSquareHistory = localStorage.getItem('bigSquare')
  ? localStorage.getItem('bigSquare')
  : '2'

startGame()
//gameOver()
// clears all previous game data and starts a new game with a fresh board

function startGame() {
  resetBoard()

  for (let i = 0; i < size ** 2; i++) {
    const square = document.createElement('div')
    square.innerText = 0
    board.appendChild(square)
    boardValues.push(square.innerText)
    previousValues.push(0)
  }
  boardValues = boardValues.map(Number)
  addNewSquare()
  addNewSquare()
  div.addEventListener('keyup', arrowListener)
  enableTouchEvents()
}

function resetBoard() {
  boardValues = []
  score = 0
  movesLeft = true
  board.innerHTML = ''
  div.removeEventListener('keyup', arrowListener)
  disableTouchEvents()
}

// adds a #2 to the board in a random empty spot

function addNewSquare() {
  if (boardValues.includes(0)) {
    const random = Math.floor(Math.random() * size ** 2)
    if (boardValues[random] === 0) {
      boardValues[random] = '2'
      updateBoard()
    } else addNewSquare()
  }
}

// updates the values of the tiles and checks for end game scenarios

function updateBoard() {
  boardValues.forEach((val, idx) => {
    if (val === '2') {
      board.children[idx].innerText = '2'
      board.children[idx].className = 'new two'
    } else {
      board.children[idx].innerText = val
      board.children[idx].className = classObj[val]
    }
    if (val !== previousValues[idx] && val !== 0) {
      board.children[idx].classList.add(previousDirection)
    }
  })

  checkForMoves()
  scoreContainer.innerText = score

  if (Math.max(...boardValues) >= 2048 && !movesLeft) {
    gameOver('恭喜通关👍!!!')
  } else if (!movesLeft) {
    gameOver('还需努力😏!')
  }
}

// finalizing the game and populating all end game container elements

function gameOver(message) {
  let biggestSquare = Math.max(...boardValues)
  biggestSquareHistory =
    biggestSquare > Number(biggestSquareHistory)
      ? biggestSquare.toString()
      : localStorage.getItem('bigSquare')
      
  localStorage.setItem('bigSquare', biggestSquareHistory)

  endGameContainer.style.display = 'flex'
  endGameOutcome.innerText = message
  endGameScore.innerText = score
  biggestSquareContainer.innerText = biggestSquare
  biggestSquareHistoryContainer.innerText = biggestSquareHistory

  populateTopScores()
}

function populateTopScores() {
  previousScores.push(score)
  previousScores.sort((a, b) => b - a)
  localStorage.setItem('previous', JSON.stringify(previousScores.slice(0, 10)))
  scoresListContainer.innerHTML = ''

  previousScores.slice(0, 10).forEach(score => {
    let item = document.createElement('li')
    item.innerText = score.toLocaleString()
    scoresListContainer.appendChild(item)
  })
}

// functions to handle directional movement on the game board

function swipeLeft() {
  let newValues = []
  for (let i = 0; i < size ** 2; i++) {
    if (i % 4 === 0) {
      let values = boardValues.slice(i, i + 4).filter(num => num > 0)
      values = addPairs(values)
      let empties = new Array(size - values.length).fill(0)
      values = [...values, ...empties]
      values.forEach(val => newValues.push(val))
    }
  }
  if (boardValues.join('') === newValues.join('')) {
    return
  } else {
    previousValues = boardValues.slice()
    boardValues = newValues.slice()
    previousDirection = 'left-swipe'
    addNewSquare()
  }
}

function swipeRight() {
  let newValues = []
  for (let i = 0; i < size ** 2; i++) {
    if (i % 4 === 0) {
      let values = boardValues.slice(i, i + 4).filter(num => num > 0)
      values = addPairs(values, 'reverse')
      let empties = new Array(size - values.length).fill(0)
      values = [...empties, ...values]
      values.forEach(val => newValues.push(val))
    }
  }

  if (boardValues.join('') === newValues.join('')) {
    return
  } else {
    previousValues = boardValues.slice()
    boardValues = newValues.slice()
    previousDirection = 'right-swipe'
    addNewSquare()
  }
}

function swipeUp() {
  let tempValues = []
  let newValues = []
  for (let i = 0; i < size; i++) {
    let values = []
    for (let j = i; j < size ** 2; j += size) {
      values.push(boardValues[j])
    }
    values = values.filter(num => num > 0)
    values = addPairs(values)
    let empties = new Array(size - values.length).fill(0)
    values = [...values, ...empties]
    values.forEach(val => tempValues.push(val))
  }

  for (let i = 0; i < size; i++) {
    newValues.push(
      tempValues[i],
      tempValues[i + size],
      tempValues[i + size * 2],
      tempValues[i + size * 3]
    )
  }

  if (boardValues.join('') === newValues.join('')) {
    return
  } else {
    previousValues = boardValues.slice()
    boardValues = newValues.slice()
    previousDirection = 'up-swipe'
    addNewSquare()
  }
}

function swipeDown() {
  let tempValues = []
  let newValues = []
  for (let i = 0; i < size; i++) {
    let values = []
    for (let j = i; j < size ** 2; j += size) {
      values.push(boardValues[j])
    }
    values = values.filter(num => num > 0)
    values = addPairs(values, 'reverse')
    let empties = new Array(size - values.length).fill(0)
    values = [...empties, ...values]
    values.forEach(val => tempValues.push(val))
  }

  for (let i = 0; i < size; i++) {
    newValues.push(
      tempValues[i],
      tempValues[i + size],
      tempValues[i + size * 2],
      tempValues[i + size * 3]
    )
  }

  if (boardValues.join('') === newValues.join('')) {
    return
  } else {
    previousValues = boardValues.slice()
    boardValues = newValues.slice()
    previousDirection = 'down-swipe'
    addNewSquare()
  }
}

// interprets swipe and calls apropriate swipe function

function handleSwipe(dx, dy) {
  if (Math.abs(dx) >= Math.abs(dy)) {
    dx > 0 ? swipeRight() : swipeLeft()
  } else {
    dy > 0 ? swipeDown() : swipeUp()
  }
}

// add pairs on the gameboard in the correct order depending on which direction is chosen

function addPairs(arr, direction = 'forward') {
  if (arr.length > 0) {
    let values = direction === 'reverse' ? arr.slice().reverse() : arr.slice()
    let res = []

    for (let i = 0; i <= values.length - 1; i++) {
      if (values[i] === values[i + 1]) {
        res.push(values[i] * 2)
        score += values[i] * 2
        i++
      } else {
        res.push(values[i])
      }
    }

    res = direction === 'forward' ? res : res.reverse()

    return res
  } else return []
}

// check to see if any valid moves are left on the board

function checkForMoves() {
  let pairs = false
  let blankSpaces = boardValues.includes(0)
  boardValues = boardValues.map(Number)

  for (let i = 0; i < boardValues.length; i += size) {
    if (
      boardValues[i] === boardValues[i + 1] ||
      boardValues[i + 1] === boardValues[i + 2] ||
      boardValues[i + 2] === boardValues[i + 3]
    ) {
      pairs = true
    }
  }

  for (let i = 0; i < size; i++) {
    if (
      boardValues[i] === boardValues[i + size] ||
      boardValues[i + size] === boardValues[i + size * 2] ||
      boardValues[i + size * 2] === boardValues[i + size * 3]
    ) {
      pairs = true
    }
  }

  movesLeft = pairs || blankSpaces ? true : false
}

// component event listeners

// keyboard listener for arrow key controls

function arrowListener(e) {
  if (e.code === 'ArrowUp') {
    if (e.repeat) return
    else swipeUp()
  } else if (e.code === 'ArrowRight') {
    if (e.repeat) return
    else swipeRight()
  } else if (e.code === 'ArrowDown') {
    if (e.repeat) return
    else swipeDown()
  } else if (e.code === 'ArrowLeft') {
    if (e.repeat) return
    else swipeLeft()
  }
}

playBtn.addEventListener('click', e => {
  e.preventDefault()
  endGameContainer.style.display = 'none'
  startGame()
})

// touch event listeners to interpret swipes on touch screens

function enableTouchEvents() {
  let startX
  let startY
  let endX
  let endY

  div.addEventListener('touchstart', touchStartListener)
  div.addEventListener('touchmove', touchMoveListener, { passive: false })
  div.addEventListener('touchend', touchEndListener)
}

function disableTouchEvents() {
  div.removeEventListener('touchstart', touchStartListener)
  div.removeEventListener('touchmove', touchMoveListener, { passive: false })
  div.removeEventListener('touchend', touchEndListener)
}

function touchStartListener(e) {
  let touchObj = e.changedTouches[0]
  startX = touchObj.pageX
  startY = touchObj.pageY
}

function touchMoveListener(e) {
  e.preventDefault()
  e.stopPropagation()
}

function touchEndListener(e) {
  let touchObj = e.changedTouches[0]
  endX = touchObj.pageX
  endY = touchObj.pageY

  let dx = endX - startX
  let dy = endY - startY

  if (Math.abs(dx) > 25 || Math.abs(dy) > 25) {
    handleSwipe(dx, dy)
  }
}

}
