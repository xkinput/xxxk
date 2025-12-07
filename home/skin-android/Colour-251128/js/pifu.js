var htmltxt=`
	<div class="skin"></div>
`;

function jsload(div){
	let ele=$(".jsload .skin");
	_JS.create(ele);
}

var _JS = (function(){
	
	function create(div2){
		_JS.getSkin().then( L => {
			for (var i = 0; i < L.length; i++) {
				var one = document.createElement("button");
				one.textContent = L[i];
				one.dataset.index=i;
				div2.appendChild(one);
			}
			_JS.click(div2, function(e){
				// 点击处理
				var btn = e.target;
				if(btn.tagName === 'BUTTON'){
					let index=btn.dataset.index;
					var G="android";
					var K="android_skin";
					alert("切换皮肤"+ L[index]);
					iniSet(G,K,L[index]);
				}
			}, function(e){
				// 长按处理
				alert("长按");
			}, function(e){
				// 左右处理
				if(e=="right") {overlay();toolbar();}
				else alert("右滑退出界面");
			});
		});
	}
	
	function click(ele, func1, func2, func3) {
		let startX, startY, endX, endY, startTime, timer;
		const PRESS_THRESHOLD = 500; // 长按阈值，单位毫秒
		const MOVE_THRESHOLD = 10; // 移动阈值，像素
		if (!ele) {
			console.error("元素ele不能为空！");
			return;
		}
		ele.addEventListener('touchstart', function(e) {
			e.stopPropagation(); // 阻止事件冒泡，防止与父元素的滚动冲突
			if(e.target.tagName === 'BUTTON')
				e.target.classList.add('active'); // 添加active类
			startX = e.touches[0].clientX;
			startY = e.touches[0].clientY;
			startTime = new Date().getTime();
			// 设置长按定时器
			timer = setTimeout(() => {
					if (func2 && !isMoving(startX, startY, e.touches[0].clientX, e.touches[0].clientY)) {
						func2(); // 调用长按函数
						clearTimeout(timer); // 清除定时器，防止长按后立即触发点击
					}
			}, PRESS_THRESHOLD);
		});
		ele.addEventListener('touchmove', function(e) {
			// 阻止默认的滚动行为，但要区分是左右滑动还是上下滑动
			if (Math.abs(e.touches[0].clientX - startX) > Math.abs(e.touches[0].clientY - startY)) {
				// 左右滑动，阻止默认行为，避免页面滚动
				e.preventDefault();
			}
			endX = e.touches[0].clientX;
			endY = e.touches[0].clientY;
			// 如果发生移动，清除长按定时器
			if (Math.abs(endX - startX) > MOVE_THRESHOLD || Math.abs(endY - startY) > MOVE_THRESHOLD) {
				clearTimeout(timer);
			}
		});
		ele.addEventListener('touchend', function(e) {
			e.target.classList.remove('active'); // 移除active类
			clearTimeout(timer); // 触摸结束时清除长按定时器
			endX = e.changedTouches[0].clientX;
			endY = e.changedTouches[0].clientY;
			const endTime = new Date().getTime();
			// 判断是否是点击（没有明显移动且触摸时间短）
			if (!isMoving(startX, startY, endX, endY) && (endTime - startTime < PRESS_THRESHOLD)) {
				if (func1)
					func1(e); // 调用点击函数
			}
			// 判断左右滑动
			const deltaX = endX - startX;
			const deltaY = endY - startY;
			if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 300) {
				if (func3)
					func3(deltaX > 0 ? 'right' : 'left');
			}
		});
		ele.addEventListener('touchcancel', function(e) {
			e.target.classList.remove('active'); // 移除active类
			clearTimeout(timer); // 触摸取消时清除长按定时器
		});
		// 辅助函数：判断是否发生明显移动
		function isMoving(sX, sY, eX, eY) {
			return Math.abs(eX - sX) > MOVE_THRESHOLD || Math.abs(eY - sY) > MOVE_THRESHOLD;
		}
	}
	
	async function getSkin(){
		var skin;
		try{
			skin=await (await fetch("https://yong.dgod.net/config/skin.json")).json();
		}catch(e){
			skin=[];
		}
		return skin;
	}

	return {
		getSkin,
		create,
		click
	};
})();