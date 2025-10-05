var htmltxt=`
    <img src="../js/pic/4.gif" alt="gif" width="200" height="200" onclick="imgout(4)">
    <img src="../js/pic/0.webp" alt="webp" width="200" height="200" onclick="imgout(0)">
    <img src="../js/pic/1.png" alt="png" width="200" height="200" onclick="imgout(1)">
    <img src="../js/pic/2.svg" alt="svg" width="200" height="200" onclick="imgout(2)">
    <img src="../js/pic/3.jpg" alt="jpg" width="200" height="200" onclick="imgout(3)">
`;

function jsload(on){
var div=document.querySelector(".jsload div div");
}

function imgout(num){
  var file=["0.webp","1.png","2.svg","3.jpg","4.gif"];
	msgbox(file[num]);
  App.commit(`$FILE(android/js/pic/${file[num]})`);
}
