var htmltxt=`
    <div class="controls">
        <select id="gridSize">
            <option value="5">5x5</option>
            <option value="10">10x10</option>
        </select>
        <button id="restartBtn">开始游戏</button>
        <span>时间: <span id="time">0</span>秒</span>
    </div>
    <div id="grid"></div>
    <div id="result"></div>
`

function jsload(on){
	var div=document.querySelector(".jsload div div");

	let currentNumber = 1;
	let startTime = null;
	let isGameActive = false;
	let selectedSize = 5;
	let check = false;

	const grid = div.querySelector('#grid');
	const restartBtn = div.querySelector('#restartBtn');
	const timeDisplay = div.querySelector('#time');
	const result = div.querySelector('#result');
	const sizeSelect = div.querySelector('#gridSize');

	function generateGrid(size) {
			grid.innerHTML = '';
			const total = size * size;
			const numbers = Array.from({length: total}, (_, i) => i + 1);
			
			// Fisher-Yates洗牌算法
			for (let i = numbers.length - 1; i > 0; i--) {
					const j = Math.floor(Math.random() * (i + 1));
					[numbers[i], numbers[j]] = [numbers[j], numbers[i]];
			}

			numbers.forEach(num => {
					const cell = document.createElement('div');
					cell.className = 'cell';
					cell.textContent = num;
					cell.addEventListener('click', () => handleCellClick(num));
					grid.appendChild(cell);
			});

			grid.style.gridTemplateColumns = `repeat(${size}, 1fr)`;
	}

	function handleCellClick(clickedNum) {
			if (check) return;
			if (!isGameActive) {
					if (clickedNum === 1) {
							startGame();
							markCellCorrect(1);
							currentNumber++;
							checkCompletion();
					} else {
							endGame(false);
					}
			} else {
					if (clickedNum === currentNumber) {
							markCellCorrect(currentNumber);
							currentNumber++;
							checkCompletion();
					} else {
							endGame(false);
					}
			}
	}

	function markCellCorrect(num) {
			const cells = div.getElementsByClassName('cell');
			for (let cell of cells) {
					if (parseInt(cell.textContent) === num) {
							cell.classList.add('correct');
							break;
					}
			}
	}

	function startGame() {
			isGameActive = true;
			startTime = Date.now();
			my.timerId2 = setInterval(updateTime, 1000);
			result.style.display = 'none';
			check = false;
	}

	function updateTime() {
			const elapsed = Math.floor((Date.now() - startTime) / 1000);
			timeDisplay.textContent = elapsed;
	}

	function checkCompletion() {
			if (currentNumber > selectedSize * selectedSize) {
					endGame(true);
			}
	}

	function endGame(success) {
			clearInterval(my.timerId2);
			isGameActive = false;
			result.textContent = success ? '🎉 成功！' : '❌ 失败！';
			result.style.color = success ? '#0000e6' : '#f44336';
			result.style.display = 'block';
			check = true;
	}

	restartBtn.addEventListener('click', () => {
			selectedSize = parseInt(sizeSelect.value);
			currentNumber = 1;
			clearInterval(my.timerId2);
			timeDisplay.textContent = '0';
			result.style.display = 'none';
			generateGrid(selectedSize);
			isGameActive = false;
			check = false;
	});

	sizeSelect.addEventListener('change', () => {
			selectedSize = parseInt(sizeSelect.value);
			generateGrid(selectedSize);
			currentNumber = 1;
			clearInterval(my.timerId2);
			timeDisplay.textContent = '0';
			result.style.display = 'none';
			isGameActive = false;
	});

	// 初始化5x5网格
	generateGrid(5);
}

