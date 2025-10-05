var htmltxt=`
        <div class="form-group">
            <label>名字：</label>
            <input type="text" id="name" placeholder="请输入名字">
        </div>
`;

function jsload(jsl){
	//alert(games.quit());
}

var games = (function(){
	let t1 = "test";
	
	function restart(){
		alert("再开始");
	}
	
	function quit(){
		return t1;
	}
	
	return {
		restart : restart,
		quit: quit
	};
})();