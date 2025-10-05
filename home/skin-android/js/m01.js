var htmltxt=`
   <div class="container">
        <div class="game"></div>
        <button class="reset" onclick="off()">RESET GAME</button>
    </div>
`;
function jsload(on) {
var div=document.querySelector(".jsload div div");
const emojis = [
    "🐱","🐱",
    "🦝","🦝",
    "🦊","🦊",
    "🐶","🐶",
    "🐵","🐵",
    "🦁","🦁",
    "🐯","🐯",
    "🐮","🐮",
    "🦀","🦀",
    "🦞","🦞",
    "🐠","🐠",
    "🦈","🦈",
    
    
  ];
let openCards = [];

let shuffleEmojis = emojis.sort(() => (Math.random() > 0.5 ? 2 : -1));

for (let i = 0; i < emojis.length; i++) {
  let box = document.createElement("div");
  box.className = "item";
  box.innerHTML = shuffleEmojis[i];
  box.onclick = handleClick;
  div.querySelector(".game").appendChild(box);
}

function handleClick() {
  if (openCards.length < 2) {
    this.classList.add("boxOpen");
    openCards.push(this);
  }

  if (openCards.length == 2) {
    setTimeout(checkMatch, 500);
  }

//  console.log(openCards);
}

function checkMatch() {
  if (openCards[0].innerHTML === openCards[1].innerHTML) {
    openCards[0].classList.add("boxMatch");
    openCards[1].classList.add("boxMatch");
  } else {
    openCards[0].classList.remove("boxOpen");
    openCards[1].classList.remove("boxOpen");
  }

  openCards = [];

  if (div.querySelectorAll(".boxMatch").length === emojis.length) {
    msgbox("你赢了👍");
  }
}
}

function off(){
  console.log("test");
  var temp=document.querySelector(".jsload div div");
  temp.innerHTML=htmltxt;
  jsload();
}