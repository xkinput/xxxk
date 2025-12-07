var htmltxt=`
	<div class="test"></div>
  <dialog id="myDialog">
<fieldset>
		<legend>标题测试</legend>
    <div class="dialog-content">
      <p>这是一个 HTML 元素示例。</p>
      <p>点击关闭按钮关闭。</p>
    </div>
</fieldset>
    <button class="close-btn" onclick="games.closeDialog()">关闭</button>
  </dialog>
<div popover id="mydiv">
  <h2>Popover</h2>
  <hr>
  <p>弹出框是放置在其他所有元素之上的元素。</p>
  <p>当您想告诉一些重要的事情时可以使用它。</p>
你好
测试一下换行<br><mark>看看效果</mark><br>
  <button popovertarget="mydiv" popovertargetaction="hide">关闭</button>
</div>

`;

function jsload(jsl){
	let L=["yong_ini", "信息", "弹窗1", "弹窗2", "皮肤"];
	let ele=$(".jsload .test")
	games.create(ele, L);
}

var games = (function(){
	function create(div2, L){
		for (var i = 0; i < L.length; i++) {
			var one = document.createElement("button");
			one.textContent = L[i];
			one.dataset.index=i;
			div2.appendChild(one);
		}
		Handler.click(div2, function(e){
			// 点击结束时的处理
			var btn = e.target;
			if(btn.tagName === 'BUTTON'){
//				overlay();
//				overlay('msgbox',2, btn.textContent);
				let index=btn.dataset.index;
				//alert(index);
				if(index==2){
					btn.setAttribute("popovertarget", "mydiv");
				}else if(index==3) {
					games.openDialog();
				}else if(index==4){
					getskin();
					overlay();
				}else if(index==1){
					let isPortrait = screen.orientation.type;
					let orientation = /portrait/i.test(isPortrait) ? "portrait竖屏" : "landscape横屏";
					localStorage.message="inner宽度: " + window.innerWidth + "\ninner高度: " + window.innerHeight + "\n屏幕宽度: " + screen.width + "\n屏幕高度: " + screen.height  + "\n标识: " + navigator.userAgent + "\n屏幕方向: " + orientation;
					overlay();overlay('msgbox',0);
				}
			}
		}, function(e){
			// 点击开始时的处理（可选）
//			console.log('开始点击');
		});
	}
	
	async function getskin(){
		var skin;
		try{
			skin=await (await fetch("https://yong.dgod.net/config/skin.json")).json();
		}catch(e){
			skin="你好";
		}
		console.log("yong:text "+skin);
	}
	
	function restart(){
		alert("再开始");
	}
	
	function quit(){
		alert("退出");
	}

    function openDialog() {
      const dialog = document.getElementById("myDialog");
      dialog.showModal(); // 显示模态对话框
    }

    function closeDialog() {
      const dialog = document.getElementById("myDialog");
      dialog.close(); // 关闭对话框
    }

	return {
		create,
		restart,
		closeDialog,
		openDialog,
		quit
	};
})();

