var htmltxt=`
    <div id="gameContainer">
        <div id="status">点击交叉点放置棋子，围住小猫！</div>
        <div id="gameBoard"></div>
        <button id="resetButton">重新开始</button>
    </div>
`;

function jsload(on){
	var div=$(".jsload div");
        const GRID_SIZE = 10;
        const BOARD_DIMENSION = GRID_SIZE + 1;
        const totalNodes = BOARD_DIMENSION * BOARD_DIMENSION;

        const NODE_STATE = {
            EMPTY: 0,
            CAT: 1,
            PLAYER_STONE: 2
        };

        let catPosition;
        let gameBoard = [];
        let gameOver = false;

        const directions = [
            { dx: -1, dy:  0 }, { dx:  1, dy:  0 }, { dx:  0, dy: -1 }, { dx:  0, dy:  1 },
            { dx: -1, dy: -1 }, { dx: -1, dy:  1 }, { dx:  1, dy: -1 }, { dx:  1, dy:  1 }
        ];

        const boardElement = document.getElementById('gameBoard');
        const statusElement = document.getElementById('status');

        // 修改后的初始化函数
        function initGame() {
            boardElement.innerHTML = '';
            boardElement.style.setProperty('--grid-size', GRID_SIZE);
            boardElement.style.setProperty('--board-dim', BOARD_DIMENSION);

            gameBoard = new Array(totalNodes).fill(NODE_STATE.EMPTY);
            gameOver = false;

            // 放置初始障碍物
            const initialObstacles = 35; // 初始障碍物数量
            for (let i = 0; i < initialObstacles; i++) {
                let x, y, index;
                do {
                    x = Math.floor(Math.random() * BOARD_DIMENSION);
                    y = Math.floor(Math.random() * BOARD_DIMENSION);
                    index = getNodeIndex(x, y);
                } while (index === -1 || gameBoard[index] !== NODE_STATE.EMPTY);
                gameBoard[index] = NODE_STATE.PLAYER_STONE;
            }

            // 放置猫（确保不在障碍物位置）
            let centerX = Math.floor(GRID_SIZE / 2);
            let centerY = Math.floor(GRID_SIZE / 2);
            let centerIndex = getNodeIndex(centerX, centerY);
            
            // 如果中心点被障碍物占用，找到最近的空位
            if (gameBoard[centerIndex] !== NODE_STATE.EMPTY) {
                const emptyNodes = gameBoard
                    .map((state, index) => ({state, index}))
                    .filter(node => node.state === NODE_STATE.EMPTY);
                centerIndex = emptyNodes[Math.floor(Math.random() * emptyNodes.length)].index;
            }
            
            catPosition = centerIndex;
            gameBoard[catPosition] = NODE_STATE.CAT;

            // 创建棋盘节点
            for (let y = 0; y < BOARD_DIMENSION; y++) {
                for (let x = 0; x < BOARD_DIMENSION; x++) {
                    const node = document.createElement('div');
                    const index = getNodeIndex(x, y);
                    node.classList.add('node');
                    node.dataset.index = index;
                    node.dataset.x = x;
                    node.dataset.y = y;
                    node.onclick = () => handleNodeClick(index);
                    boardElement.appendChild(node);
                }
            }

            if (findShortestPathBFS(catPosition, gameBoard) === null) {
                statusElement.textContent = '猫被困住了！点击重置';
                gameOver = true;
            } else {
                statusElement.textContent = '点击交叉点放置棋子，围住小猫！';
            }

            updateDisplay();
        }

        // 其余原有函数保持不变
        function getNodeIndex(x, y) {
            if (x < 0 || x >= BOARD_DIMENSION || y < 0 || y >= BOARD_DIMENSION) return -1;
            return y * BOARD_DIMENSION + x;
        }

        function getNodeCoords(index) {
            if (index < 0 || index >= totalNodes) return null;
            const y = Math.floor(index / BOARD_DIMENSION);
            const x = index % BOARD_DIMENSION;
            return { x, y };
        }

        function findShortestPathBFS(startNodeIndex, currentBoard) {
            const queue = [[startNodeIndex]];
            const visited = new Set([startNodeIndex]);

            while (queue.length > 0) {
                const path = queue.shift();
                const current = path[path.length - 1];

                if (isAtEdge(current)) return path;

                for (const { dx, dy } of directions) {
                    const currentCoords = getNodeCoords(current);
                    const nextX = currentCoords.x + dx;
                    const nextY = currentCoords.y + dy;
                    const neighborIndex = getNodeIndex(nextX, nextY);

                    if (neighborIndex !== -1 &&
                        !visited.has(neighborIndex) &&
                        currentBoard[neighborIndex] === NODE_STATE.EMPTY)
                    {
                        visited.add(neighborIndex);
                        queue.push([...path, neighborIndex]);
                    }
                }
            }
            return null;
        }

        function isAtEdge(index) {
            const coords = getNodeCoords(index);
            if (!coords) return false;
            return coords.x === 0 || coords.x === GRID_SIZE || coords.y === 0 || coords.y === GRID_SIZE;
        }

        function handleNodeClick(index) {
            if (gameOver || gameBoard[index] !== NODE_STATE.EMPTY) return;

            gameBoard[index] = NODE_STATE.PLAYER_STONE;
            updateDisplay();

            const escapePath = findShortestPathBFS(catPosition, gameBoard);
            if (escapePath === null) {
                gameOver = true;
                statusElement.textContent = '🎉 恭喜！你围住了小猫！ 🎉';
                updateDisplay();
            } else {
                setTimeout(catTurn, 150);
            }
        }

        function catTurn() {
            if (gameOver) return;

            const escapePath = findShortestPathBFS(catPosition, gameBoard);

            if (escapePath === null) {
                gameOver = true;
                statusElement.textContent = '🎉 奇怪？猫好像被困住了！ 🎉';
            } else if (escapePath.length > 1) {
                const nextNodeIndex = escapePath[1];
                gameBoard[catPosition] = NODE_STATE.EMPTY;
                catPosition = nextNodeIndex;
                gameBoard[catPosition] = NODE_STATE.CAT;

                if (isAtEdge(catPosition)) {
                    gameOver = true;
                    statusElement.textContent = '😿 失败！小猫跑到边界了！ 😿';
                }
            } else {
                 if (isAtEdge(catPosition)) {
                       gameOver = true;
                       statusElement.textContent = '😿 失败！小猫已经在边界了！ 😿';
                  } else {
                       gameOver = true;
                       statusElement.textContent = '🎉 怎么回事？猫好像被困住了！ 🎉';
                  }
            }

            updateDisplay();
        }

        function updateDisplay() {
            const nodes = boardElement.children;
            for (let i = 0; i < totalNodes; i++) {
                const node = nodes[i];
                node.className = 'node';
                const existingStone = node.querySelector('.stone');
                 if(existingStone) existingStone.remove();
                 node.style.filter = '';

                const state = gameBoard[i];
                let stone = null;

                if (state === NODE_STATE.CAT) {
                    node.classList.add('cat');
                    stone = document.createElement('div');
                    stone.classList.add('stone');
                    stone.textContent = '🐱';
                } else if (state === NODE_STATE.PLAYER_STONE) {
                    node.classList.add('player-stone');
                    stone = document.createElement('div');
                    stone.classList.add('stone');
                }

                if (stone) node.appendChild(stone);
            }

             if (gameOver) {
                const catNode = nodes[catPosition];
                 if (catNode) {
                     const catStone = catNode.querySelector('.stone');
                     if(catStone) {
                         catStone.style.transform = 'scale(1.1)';
                         catStone.style.zIndex = '3';
                         if (statusElement.textContent.includes('失败')) {
                             catStone.style.filter = 'hue-rotate(120deg)';
                         } else {
                             catStone.style.filter = 'grayscale(70%) brightness(0.9)';
                         }
                     }
                 }
            }
        }

        initGame();
        const resetButton = document.getElementById('resetButton');
        resetButton.addEventListener('click', () => {
            initGame();
        });
}
