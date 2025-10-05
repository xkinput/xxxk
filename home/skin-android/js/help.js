var htmltxt=`
<div class="test"></div>
`;
// [格式] "关键字": "内容", (最后面有个逗号, \n = 换行)
//     "xxx": "xxxx",
var text={
"同步webdav": "#同步的数据支持通过webdav访问，地址是 'https://yong.dgod.net/sync/webdav/同步密钥/' ，用户名是你在论坛的用户名，密码为空。里面存放的是原始数据，不支持加解密。",
"同步账号密钥": "[sync]\n#同步帐户（小小输入法官网注册帐户 'http://yong.dgod.net'）\nuser=\n#同步密钥申请 'http://yong.dgod.net/sync/reg.html'\nsid=",
"单字模式": "[key]\n#(拼音类无效)单字模式快捷键\nzi_switch=-",
"以词定字": "[key]\n#以词定字快捷键\nw2c=[ ]",
"大写上屏": "[IM]\n#SHIFT键时,大写字母直接上屏\nABCD=1",
"自动调频": "[IM]\nauto_move=1",
"悬浮窗popup": "[input]\n#悬浮栏模式 留空:关闭 1:开启 2:调试\npopup=",
"高级编码desc": "#全部方案共用\n[IM]\nkey_desc=mb/desc_py.txt\n\n#单独方案(优先于共用)\n[wubi]\nkey_desc=mb/desc_py.txt",
"重定向redirect": "[IM]\nredirect=mb/redirect.txt",
"预编辑": "[IM]\n#预编辑模式 0:禁用 1:启用\nonspot=0\n#预编辑类型 0:候选 1:编码\npreedit=0",
"小小网盘": "http://yongim.ys168.com/",
"小小论坛": "https://yong.dgod.net/index.php?c=thread&fid=2",
"小小目录": "˜˜词库˜˜:\nyong/mb/\n˜˜皮肤˜˜:\nyong/.yong/android/\n˜˜脚本˜˜:\nyong/.yong/scripts/\n",
"小小输入法": "https://github.com/dgod/yong",
"同文trime": "https://github.com/osfans/trime/releases",
"万象拼音": "https://github.com/amzxyz/rime_wanxiang",
"语燕拼音": "https://github.com/gurecn/YuyanIme",
"小企鹅fcitx": "https://github.com/fcitx5-android/fcitx5-android",
"英文月份": "1.jan 2.feb 3.mar 4.apr 5.may 6.jun \n7.jul 8.aug 9.sep 10.oct 11.nov 12.dec",
};

function jsload(test){
var div=document.querySelector(".jsload >div >div >.test");
  console.log('yong:key '+SHIFT_HOME);
  setTimeout(function(){
  	console.log('yong:action copy');
  	setTimeout(function(){
  	var char=localStorage.firstclip;
		var tt;
		if(char.length>=2 && char.length<=16) tt=true;
		if(!char || !tt){
			msgbox("⚠字数限制 2至16⚠");
			toolbar();
			return;
			}
		let output = [];
		var temp;
		var count = 0;
		for (var key of Object.keys(text)) {
		  if (new RegExp(char).test(key)) {
		    output.push('###' + key + '\n```\n' + text[key] + '```');
		    count++;
		    temp = true;
		  }
		}
		if(temp){
			overlay();
			localStorage.message=output.join("\n")+"\n˜˜--END--˜˜";
			overlay('msgbox',1);
		}else {
			msgbox("●没有找到相关出处!");
			toolbar();
			}
  	},100);
  },50);
}

