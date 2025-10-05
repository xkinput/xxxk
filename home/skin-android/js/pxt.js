var htmltxt=`
    <div id="gameContainer">
        <div id="crab">🦀</div>
    </div>
    <div id="score">分数: 0</div>
    <button id="restartBtn">重新开始</button>
    <span id="alert"></span>
`;

function jsload(on){
	var div=$(".jsload div");
        const obstacles = [];
        const crab = document.getElementById('crab');
        const gameContainer = document.getElementById('gameContainer');
        const scoreElement = document.getElementById('score');
        const restartBtn = document.getElementById('restartBtn');

        let isJumping = false;
        let score = 0;
        let gameActive = true;
        let jumpHeight = 110; //跳高度
        let horizontalShift = 30; //跳距离
        let jumpDuration = 740; //停滞时间
        let gameSpeed = 5;
        let cactusInterval;
        let gameLoopInterval;

        function jump() {
            if (!isJumping && gameActive) {
                isJumping = true;
                crab.style.transition = 'transform 0.35s ease-out';
                crab.style.transform = `translate(${horizontalShift}px, -${jumpHeight}px)`;

                const handleLanding = (event) => {
                    if (event.propertyName === 'transform') {
                        isJumping = false;
                        crab.style.transition = 'transform 0.35s ease-out';
                        crab.removeEventListener('transitionend', handleLanding);
                    }
                };

                setTimeout(() => {
                    if (!gameActive) return;
                    crab.style.transition = 'transform 0.35s ease-in';
                    crab.style.transform = 'translate(0, 0)';
                    crab.addEventListener('transitionend', handleLanding);
                }, jumpDuration / 2);
            }
        }

        function createCactus() {
            if (!gameActive) return;

            const createSingleCactus = (offset = 0) => {
                const cactus = document.createElement('div');
                cactus.classList.add('cactus');
                cactus.innerHTML = '🌵';
                cactus.style.left = `${gameContainer.offsetWidth + offset}px`;
                gameContainer.appendChild(cactus);
                obstacles.push(cactus);
            };

/*            if (Math.random() < 0.3) {
                createSingleCactus(0);
                createSingleCactus(80);
            } else {
                createSingleCactus();
            }*/
            const rand = Math.random();
            if (rand < 0.2) {
                // 原有双仙人掌（间隔80px）
                createSingleCactus(0);
                createSingleCactus(70);
            } else if (rand < 0.3) {
                // 新增第三种障碍物（间隔150px）
                createSingleCactus(0);
                createSingleCactus(200);
            } else {
                // 单个仙人掌
                createSingleCactus();
            }
        }

        function moveObstacles() {
            if (!gameActive) return;

            for (let i = obstacles.length - 1; i >= 0; i--) {
                const cactus = obstacles[i];
                let currentLeft = parseFloat(cactus.style.left);
                currentLeft -= gameSpeed;
                cactus.style.left = `${currentLeft}px`;

                if (checkCollision(crab, cactus)) {
                    gameOver();
                    return;
                }

                if (currentLeft < -cactus.offsetWidth) {
                    cactus.remove();
                    obstacles.splice(i, 1);
                    score += 10;
                    scoreElement.textContent = `分数: ${score}`;

                    if (score > 0 && score % 50 === 0 && gameSpeed < 15) {
                        gameSpeed += 0.5;
                    }
                }
            }
        }

        function checkCollision(crabEl, cactusEl) {
            const crabRect = crabEl.getBoundingClientRect();
            const cactusRect = cactusEl.getBoundingClientRect();

            // 优化后的碰撞检测参数
            const horizontalMargin = 10;  // 水平方向留白
            const verticalMargin = 15;    // 垂直方向留白
            const bottomMargin = 5;       // 底部额外留白

            return (
                crabRect.left + horizontalMargin < cactusRect.right - horizontalMargin &&
                crabRect.right - horizontalMargin > cactusRect.left + horizontalMargin &&
                crabRect.bottom - bottomMargin > cactusRect.top + verticalMargin &&
                crabRect.top + verticalMargin < cactusRect.bottom - verticalMargin
            );
        }

        function gameLoop() {
            moveObstacles();
            if (gameActive) {
                gameLoopInterval = requestAnimationFrame(gameLoop);
            }
        }

        function startGame() {
            gameActive = true;
            score = 0;
            gameSpeed = 5;
            scoreElement.textContent = '分数: 0';
            crab.style.transform = 'translate(0, 0)';
            crab.style.transition = 'transform 0.35s ease-out';
            isJumping = false;

            while(obstacles.length > 0) {
                const cactus = obstacles.pop();
                cactus.remove();
            }

            clearTimeout(cactusInterval);
            cancelAnimationFrame(gameLoopInterval);

            function scheduleCactus() {
                if (!gameActive) return;
                createCactus();
                const nextSpawnTime = Math.random() * 1500 + 1000;
                cactusInterval = setTimeout(scheduleCactus, nextSpawnTime);
            }
            scheduleCactus();

            gameLoop();
        }

        function gameOver() {
            gameActive = false;
            cancelAnimationFrame(gameLoopInterval);
            clearTimeout(cactusInterval);
						$('#alert').textContent=`游戏结束！最终分数: ${score}`;
						setTimeout(function() {
							$('#alert').textContent=""
						}, 3000);
            //alert(`游戏结束！最终分数: ${score}`);
        }

        function restartGame() {
            startGame();
        }

        // 事件监听
        document.addEventListener('keydown', (e) => {
            if (e.code === 'Space' || e.code === 'ArrowUp') {
                e.preventDefault();
                jump();
            }
        });

        gameContainer.addEventListener('click', jump);
        gameContainer.addEventListener('touchstart', (e) => {
            e.preventDefault();
            jump();
        });

        restartBtn.addEventListener('click', restartGame);

        startGame();
}
