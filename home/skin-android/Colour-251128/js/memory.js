var htmltxt=`
<div class="container">
        <h2>Memory Game</h2>
        <div class="game"></div>
        <div id="alert"></div>
</div>`;

function jsload(on){
  var alert=document.querySelector(".jsload #alert");
  var div=document.querySelector(".jsload div.game");
const emojis = ["🐶","🐶", "🐱", "🐱", "🐭","🐭", 
 "🐹","🐹",  "🐰","🐰", "🦊", "🦊","🐻", "🐻","🐼", "🐼"]

if(!on){
  alert.style.display = "none";
  div.innerHTML="";
}
 var shuf_emojis = emojis.sort(() => (Math.random() > .5 ) ? 2 : -1 );
 
    for(let i = 0; i < emojis.length; i++){
        let box = document.createElement('div');
        box.className= 'item';
        box.innerHTML = shuf_emojis[i];

        box.onclick = function(){
            box.classList.add('boxopen')
            setTimeout(() => {
               if(document.querySelectorAll('.boxopen').length > 1){
                   if(document.querySelectorAll('.boxopen')[0].innerHTML
                    ==document.querySelectorAll('.boxopen')[1].innerHTML){
                       document.querySelectorAll('.boxopen')[0].classList.add
                        ('boxmatch');
                          document.querySelectorAll('.boxopen')[1].classList.add
                            ('boxmatch');

                            document.querySelectorAll('.boxopen')[0].classList.remove
                            ('boxopen');
                            document.querySelectorAll('.boxopen')[0].classList.remove
                            ('boxopen');

                            if(document.querySelectorAll('.boxmatch').length == emojis.length){
                            showAlert('你赢了👍.');
                            }
                    }
                   else{
                       document.querySelectorAll('.boxopen')[1].classList.remove(
                            'boxopen'
                       )
                        document.querySelectorAll('.boxopen')[0].classList.remove(
                             'boxopen'
                          )
                   }
               }
            }, 1000);
        }

        div.appendChild(box);
    }
function showAlert(mes) {
  alert.innerHTML = `<div>${mes}</div> <button class="newGame" onclick="jsload()">重新开始😊.</button>`;
  alert.style.display = "flex";
  alert.style.flexDirection = "column";
}

}