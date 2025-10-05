var htmltxt=`
    <div id="score">Score: 0</div>
    <div id="game-container">
        <div id="bird">🦇</div>
        <div id="message">点击这里开始<br>(或者空格键)</div>
    </div>
`;

function jsload(){
	const gameContainer = document.getElementById('game-container');
	const bird = document.getElementById('bird');
	const scoreDisplay = document.getElementById('score');
	const message = document.getElementById('message');
	const gameWidth = gameContainer.offsetWidth;
	const gameHeight = gameContainer.offsetHeight;
	const birdSize = 30;
	const birdX = 20;
	const birdCenterX = birdX + birdSize / 2; 
	const gravity = 0.25;
	const jumpStrength = 5;
	const pipeWidth = 10;
	const pipeCharHeight = 10;
	const pipeGap = 95;
	const pipeSpeed = 1.5;
	const pipeSpawnInterval = 1800;
	const obstacleChar = ' ';
	let birdY, birdVelocity;
	let pipes = [];
	let score = 0;
	let animationFrameId = null;
	let pipeSpawnTimer = null;
	let isGameOver;
	let gameStarted = false;
	let lastTime = 0;
	function fillPipeElement(pipeElement, height) {
			 const numChars = Math.max(1, Math.floor(height / pipeCharHeight));
			 let content = '';
			 for (let i = 0; i < numChars; i++) {
					 content += obstacleChar + '<br>';
			 }
			 pipeElement.innerHTML = content.trim();
	}

	function resetGame() {
			console.log("Resetting game...");
			birdY = gameHeight / 2 - birdSize / 2;
			birdVelocity = 0;
			bird.style.bottom = birdY + 'px';
			bird.style.transform = 'rotate(0deg)';
			score = 0;
			scoreDisplay.textContent = `Score: ${score}`;
			isGameOver = false;
			gameStarted = false;
			pipes.forEach(pipe => {
					if (pipe.topElement && pipe.topElement.parentNode) {
							pipe.topElement.remove();
					}
					 if (pipe.bottomElement && pipe.bottomElement.parentNode) {
							pipe.bottomElement.remove();
					 }
			});
			pipes = [];
			if (animationFrameId) {
					cancelAnimationFrame(animationFrameId);
					animationFrameId = null;
			}
			if (pipeSpawnTimer) {
					clearInterval(pipeSpawnTimer);
					pipeSpawnTimer = null;
			}
			message.classList.remove('hidden');
			message.innerHTML = 'Click to Start<br>(or Press Space)';
			lastTime = 0;
	}

	function jump() {
			if (!gameStarted && !isGameOver) {
					startGame();
			}
			if (gameStarted && !isGameOver) {
					birdVelocity = -jumpStrength;
					bird.style.transform = 'rotate(-25deg)';
					if (bird.jumpTimeout) clearTimeout(bird.jumpTimeout);
					bird.jumpTimeout = setTimeout(() => {
							 if (!isGameOver) bird.style.transform = 'rotate(0deg)';
					}, 150);
			} else if (isGameOver) {
			}
	}

	function createPipe() {
			if (isGameOver) return;
			const minGapTop = 40;
			const maxGapTop = gameHeight - pipeGap - 40;
			if (minGapTop >= maxGapTop) {
					 console.error("Error: Pipe gap calculation results in invalid range.");
					 return;
			}
			const gapTop = Math.random() * (maxGapTop - minGapTop) + minGapTop;

			const topPipeHeight = gapTop;
			const bottomPipeHeight = gameHeight - (gapTop + pipeGap);
			const topPipe = document.createElement('div');
			topPipe.classList.add('pipe', 'pipe-top');
			topPipe.style.height = topPipeHeight + 'px';
			topPipe.style.left = gameWidth + 'px';
			fillPipeElement(topPipe, topPipeHeight);
			gameContainer.appendChild(topPipe);
			const bottomPipe = document.createElement('div');
			bottomPipe.classList.add('pipe', 'pipe-bottom');
			bottomPipe.style.height = bottomPipeHeight + 'px';
			bottomPipe.style.left = gameWidth + 'px';
			fillPipeElement(bottomPipe, bottomPipeHeight);
			gameContainer.appendChild(bottomPipe);
			pipes.push({
					topElement: topPipe,
					bottomElement: bottomPipe,
					x: gameWidth,
					topPipeHeight: topPipeHeight,
					bottomPipeY: gapTop + pipeGap,
					passed: false
			});
	}

	function gameOver() {
			if(isGameOver) return;

			console.log("GAME OVER triggered!");
			isGameOver = true;
			gameStarted = false;
			if (pipeSpawnTimer) {
					clearInterval(pipeSpawnTimer);
					pipeSpawnTimer = null;
					console.log("Pipe timer stopped.");
			}
			 if (animationFrameId) {
					cancelAnimationFrame(animationFrameId);
					animationFrameId = null;
					console.log("Animation frame cancelled.");
			}
			message.innerHTML = `游戏结束!<br>关数: ${score}<br>点击这里重新开始`;
			message.classList.remove('hidden');
			bird.style.transform = 'rotate(90deg)';
			if (bird.jumpTimeout) clearTimeout(bird.jumpTimeout);
	}
	function checkCollision(birdRect, pipeRect) {
			const dx = Math.abs(birdRect.x - pipeRect.x);
			const dy = Math.abs(birdRect.y - pipeRect.y);
			const combinedHalfWidths = birdRect.width / 2 + pipeRect.width / 2;
			const combinedHalfHeights = birdRect.height / 2 + pipeRect.height / 2;
			return dx < combinedHalfWidths && dy < combinedHalfHeights;
	}


	function updateGame() {
			if (isGameOver) return;
			birdVelocity += gravity;
			birdY -= birdVelocity;
			if (birdY <= 0) {
					console.log("Collision: Ground");
					birdY = 0;
					bird.style.bottom = birdY + 'px';
					gameOver();
					return;
			}
			if (birdY + birdSize >= gameHeight) {
					 console.log("Collision: Ceiling");
					 birdY = gameHeight - birdSize;
					 bird.style.bottom = birdY + 'px';
					 gameOver();
					 return;
			}

			bird.style.bottom = birdY + 'px';
			for (let i = pipes.length - 1; i >= 0; i--) {
					const pipe = pipes[i];
					pipe.x -= pipeSpeed;
					pipe.topElement.style.left = pipe.x + 'px';
					pipe.bottomElement.style.left = pipe.x + 'px';
					const birdRect = {
							x: birdCenterX,
							y: gameHeight - birdY - birdSize / 2,
							width: birdSize,
							height: birdSize
					};
					 const topPipeRect = {
							 x: pipe.x + pipeWidth / 2,
							 y: pipe.topPipeHeight / 2,
							 width: pipeWidth,
							 height: pipe.topPipeHeight
					 };
					const bottomPipeHeight = gameHeight - pipe.bottomPipeY;
					const bottomPipeRect = {
							x: pipe.x + pipeWidth / 2,
							y: pipe.bottomPipeY + bottomPipeHeight / 2,
							width: pipeWidth,
							height: bottomPipeHeight
					};
					if (checkCollision(birdRect, topPipeRect)) {
							console.log("Collision: Top Pipe!");
							gameOver();
							return;
					}
					if (checkCollision(birdRect, bottomPipeRect)) {
							console.log("Collision: Bottom Pipe!");
							gameOver();
							return;
					}
					 const pipeCenterX = pipe.x + pipeWidth / 2;
					 if (!pipe.passed && pipeCenterX < birdCenterX) {
							 pipe.passed = true;
							 score++;
							 scoreDisplay.textContent = `Score: ${score}`;
							 console.log("Score updated:", score);
					 }
					if (pipe.x + pipeWidth < 0) {
							 if (pipe.topElement && pipe.topElement.parentNode) {
									 pipe.topElement.remove();
							 }
							 if (pipe.bottomElement && pipe.bottomElement.parentNode) {
									pipe.bottomElement.remove();
							 }
							 pipes.splice(i, 1);
					}
			}
	}
	function gameLoop(timestamp) {
			if (isGameOver) {
					console.log("Game loop stopped due to game over.");
					return;
			}

			updateGame();
			if (!isGameOver) {
					animationFrameId = requestAnimationFrame(gameLoop);
			} else {
					 if (animationFrameId) {
							cancelAnimationFrame(animationFrameId);
							animationFrameId = null;
					 }
			}
	}

	function startGame() {
			console.log("Attempting to start game...");
			if (!gameStarted || isGameOver) {

					if (isGameOver) {
							console.log("Restarting game...");
							resetGame();
					} else {
							console.log("Starting game for the first time...");
					}

					gameStarted = true;
					isGameOver = false;
					message.classList.add('hidden');
					birdVelocity = 0;
					birdY = gameHeight / 2 - birdSize / 2;
					bird.style.bottom = birdY + 'px';
					bird.style.transform = 'rotate(0deg)';
					if (bird.jumpTimeout) clearTimeout(bird.jumpTimeout);
					if (pipeSpawnTimer) clearInterval(pipeSpawnTimer);
					 setTimeout(createPipe, 100);
					 pipeSpawnTimer = setInterval(createPipe, pipeSpawnInterval);
					 console.log("Pipe timer started.");
					if (animationFrameId) cancelAnimationFrame(animationFrameId);
					lastTime = performance.now();
					console.log("Starting game loop...");
					animationFrameId = requestAnimationFrame(gameLoop);
			} else {
					console.log("Game already running, start ignored.");
			}
	}
	gameContainer.addEventListener('mousedown', (e) => {
			 if (e.target !== message) {
					 jump();
			 }
	});

	message.addEventListener('mousedown', (e) => {
			 e.stopPropagation();
			 console.log("Message clicked, starting game...");
			 startGame();
	});

	document.addEventListener('keydown', (e) => {
			if (e.code === 'Space' && !e.repeat) {
					e.preventDefault();
					jump();
					if (isGameOver) {
						 console.log("Space pressed on game over, starting game...");
						 startGame();
					}
			}
	});
	window.addEventListener('load', () => {
			 console.log("Window loaded, resetting game for initial setup.");
			resetGame();
	});

}