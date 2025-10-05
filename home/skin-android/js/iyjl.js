var htmltxt=`
    <div id="gameInfo">
        <div id="score">得分：0</div>
        <div id="timer">时间：10</div>
        <div id="attempts">机会：❤️❤️</div>
    </div>
    <div id="selected"></div>
    <div id="buttons"></div>
    <div id="message"></div>

    <div class="overlay" id="overlay">
        <div class="dialog">
            <h2>游戏结束</h2>
            <p>最终得分：<span id="finalScore">0</span></p>
            <button class="restartBtn">重新开始</button>
        </div>
    </div>
`;
function jsload(){
				const resetButton = document.querySelector('.restartBtn');
        const arr = [
	"三心两意", "不明不白", "风吹雨打", "议论纷纷", "死无对证",
	"马马虎虎", "狼心狗肺", "流言蜚语", "色彩缤纷", "龙马精神",
	"乘其不备", "用兵一时", "五彩缤纷", "独领风骚", "奇形怪状", 
	"用兵如神", "狼吞虎咽", "龙腾虎跃", "狼子野心", "流水无情", 
	"马到功成", "好色之徒", "万无一失", "大路朝天", "君子好逑",
	"掩耳盗铃", "风度翩翩", "翩翩起舞", "滚滚红尘", "万中无一",
	"万马奔腾", "无牵无挂", "五颜六色", "红尘滚滚", "自相矛盾",
	"万中无一", "五马分尸", "手到擒来", "举目无亲", "呕心沥血",
	"百年之好", "事过境迁", "大言不惭", "牛刀小试", "蛊惑人心",
	"左顾右盼", "高瞻远瞩", "调兵遣将", "千军万马", "千辛万苦",
	"见多识广", "旁敲侧击", "粉身碎骨", "狂风暴雨", "亡羊补牢",
	"塞翁失马", "九九归一", "顶天立地", "一言难尽", "一手遮天",
	"一步登天", "一毛不拔", "五彩缤纷", "用心良苦", "百战百胜",
	"一鼓作气", "万紫千红", "流芳百世", "白头偕老", "鸿运当头",
	"一鸣惊人", "七上八落", "一本万利", "一无是处", "意味深长",
	"一网打尽", "一苇渡江", "百战百胜", "箭无虚发", "同心同力",
	"卧虎藏龙", "金碧辉煌", "一鼓作气", "千奇百怪", "百毒不侵"
        ];

        let currentIdioms = [];
        let allCharacters = [];
        let selectedChars = [];
        let score = 0;
        let timeLeft;
        let attemptsLeft;

        function initGame() {
            // 重置游戏状态
            clearInterval(my.timerId2);
            timeLeft = 20; //倒计时
            attemptsLeft = 2; //2次机会
            
            currentIdioms = [...new Set(arr)]
                .sort(() => Math.random() - 0.5)
                .slice(0, 5);
            
            allCharacters = currentIdioms.join('').split('')
                .map((char, index) => ({ id: index, char }))
                .sort(() => Math.random() - 0.5);

            // 生成按钮
            const buttonsDiv = document.getElementById('buttons');
            buttonsDiv.innerHTML = '';
            allCharacters.forEach(item => {
                const btn = document.createElement('button');
                btn.textContent = item.char;
                btn.dataset.id = item.id;
                btn.addEventListener('click', () => handleCharClick(item));
                buttonsDiv.appendChild(btn);
            });

            selectedChars = [];
            updateDisplay();
            startTimer();
        }

        function startTimer() {
            document.getElementById('timer').textContent = `时间：${timeLeft}`;
            my.timerId2 = setInterval(() => {
                timeLeft--;
                document.getElementById('timer').textContent = `时间：${timeLeft}`;
                if(timeLeft <= 3) {
                    document.getElementById('timer').style.color = '#f44336';
                }
                
                if(timeLeft <= 0) {
                    gameOver();
                }
            }, 1000);
        }

        function handleCharClick(item) {
            const existingIndex = selectedChars.findIndex(c => c.id === item.id);
            const btn = document.querySelector(`button[data-id="${item.id}"]`);

            if (existingIndex === -1) {
                if (selectedChars.length < 4) {
                    selectedChars.push(item);
                    btn.style.background = '#e0e0e0';
                }
            } else {
                selectedChars.splice(existingIndex, 1);
                btn.style.background = '';
            }
            
            updateDisplay();
            if (selectedChars.length === 4) checkAnswer();
        }

function updateDisplay() {
    // 新增分数更新
    document.getElementById('score').textContent = `得分：${score}`;
    document.getElementById('selected').textContent = 
        `当前选择：${selectedChars.map(c => c.char).join(' ')}`;
    document.getElementById('attempts').textContent = 
        `机会：${'❤️'.repeat(attemptsLeft)}${'❌'.repeat(2 - attemptsLeft)}`;
}

function checkAnswer() {
    const sortedAnswer = selectedChars.map(c => c.char).sort().join('');
    const isCorrect = currentIdioms.some(idiom => 
        idiom.split('').sort().join('') === sortedAnswer
    );

    if (isCorrect) {
        score++;
        // 立即更新显示
        updateDisplay();
        showMessage('✅ 正确！进入下一轮...', '#4CAF50');
        setTimeout(initGame, 1000);
    } else {
        attemptsLeft--;
        if(attemptsLeft <= 0) {
            gameOver();
        } else {
            showMessage('❌ 错误，请重试！', '#f44336');
            resetSelection();
        }
        updateDisplay();
    }
}


        function resetSelection() {
            selectedChars.forEach(c => {
                document.querySelector(`button[data-id="${c.id}"]`).style.background = '';
            });
            selectedChars = [];
            updateDisplay();
        }

        function gameOver() {
            clearInterval(my.timerId2);
            document.getElementById('overlay').style.display = 'flex';
            document.getElementById('finalScore').textContent = score;
        }

        function resetGame() {
            document.getElementById('overlay').style.display = 'none';
            document.getElementById('timer').style.color = '#2196F3';
            score = 0;
            initGame();
        }

        function showMessage(text, color) {
            const msgDiv = document.getElementById('message');
            msgDiv.textContent = text;
            msgDiv.style.color = color;
            setTimeout(() => msgDiv.textContent = '', 1000);
        }

        // 初始化游戏
        initGame();
				resetButton.addEventListener('click', () => {
					resetGame();
				});

}
