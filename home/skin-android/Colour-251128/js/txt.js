var htmltxt=`
	<div class="test"></div>
`;

function jsload(){
	let L=[
		"yong_ini", "格式", "帮助", "记事本", "直通车", "布局",
		"教程", "方案", "keycode", "测试",
	];
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
				overlay();
				overlay('msgbox',2, btn.textContent);
				//let index=btn.dataset.index;
				//alert(index);
			}
		}, function(e){
			// 点击开始时的处理（可选）
		});
	}
	return {
		create
	};
})();

