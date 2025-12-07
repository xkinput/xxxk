var htmltxt=`
<div id="table" data-debug="">
  <div id="stock-waste-foundations">
    <div id="stock"></div>
    <div id="waste"></div>

    <div></div>

    <div id="foundation0" class="foundation"></div>
    <div id="foundation1" class="foundation"></div>
    <div id="foundation2" class="foundation"></div>
    <div id="foundation3" class="foundation"></div>
  </div>

  <div id="piles">
    <div id="pile0" class="pile"></div>
    <div id="pile1" class="pile"></div>
    <div id="pile2" class="pile"></div>
    <div id="pile3" class="pile"></div>
    <div id="pile4" class="pile"></div>
    <div id="pile5" class="pile"></div>
    <div id="pile6" class="pile"></div>
  </div>
</div>

<div id="templates">
  <div class="card">
    <div class="card-top"></div>
    <div class="card-mid"></div>
    <div class="card-bot"></div>
  </div>
</div>

<div id="test"></div>
`;

function jsload(on){
let debug; // Ctrl+Alt+D
var div=document.querySelector(".jsload div div")

function toggleDebug(forceDebug = null){
  debug = forceDebug === null ? !debug : forceDebug;
  div.querySelector('#table').dataset.debug = debug || '';
}

function updateCardsDebugInfo(){
  if (deck.find(c => !c.node)) {
  	return;
  }

  deck.forEach(card => {
    const {node, ...debugData} = card;
    card.node.dataset.debug = JSON.stringify(debugData, null, ' ');
  });
}

const suits = {
  spades  : '♠',
  clubs   : '♣',
  diamonds: '♦',
  hearts  : '♥',
};
const ranks = ['A'].concat([...Array(9).keys()].map(r => (r + 2).toString()), ['J', 'Q', 'K']);

function buildDeck(){
  let deck = [];

  function shuffle(array){
    for (let i = array.length - 1, downTo = 1; i >= downTo; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }

    return array;
  }

  Object.entries(suits).forEach(([suit, icon]) => {
    ranks.forEach(rank => {
      const newCard = {
        index     : null,
        node      : null,
        slotName  : null,
        upturned  : false,
        blocksCard: false,
        suitColor : ['spades', 'clubs'].includes(suit) ? 'black' : 'red',
        suit,
        icon,
        rank,
      };
      deck.push(newCard);
    });
  });

  deck = shuffle(deck);

  return deck.map((card, index) => {
    card.index = index;
    return card;
  });
}

const deck = buildDeck();

function buildCardNode(card){
  card.node = div.querySelector('#templates > .card').cloneNode(true);

  card.node.dataset.suit = card.suit;
  card.node.dataset.index = card.index;

  card.node.querySelector('.card-top').innerHTML = `<div>${card.rank}</div><div>${card.rank}</div>`;
  card.node.querySelector('.card-mid').innerHTML = `<div>${card.icon}</div>`;
  card.node.querySelector('.card-bot').innerHTML = `<div>${card.rank}</div><div>${card.rank}</div>`;
}

function moveCard(card, newSlotName, upturned = true){
  if (card.slotName) {
    const slotCards = slots[card.slotName].cards;
    slotCards.splice(slotCards.indexOf(card), 1);
  }

  slots[newSlotName].cards.push(card);
  slots[newSlotName].node.insertBefore(card.node, null);

  card.slotName = newSlotName;
  card.upturned = upturned;
  card.node.dataset.upturned = upturned || '';

  if (card.slotName.startsWith('pile')) {
    let hasMultipleUpturned = false;

    slots[card.slotName].cards.forEach(cardInPile => {
      const blocksCard = hasMultipleUpturned;
      cardInPile.blocksCard = blocksCard;
      cardInPile.node.dataset.blocksCard = blocksCard || '';

      if (cardInPile.upturned) {
        hasMultipleUpturned = true;
      }
    });
  }

  toggleActiveCard();
  updateCardsDebugInfo();
}

function moveCardsPile(card, newSlotName){
  const slotCards = slots[card.slotName].cards,
    cardIndexInSlot = slotCards.indexOf(card),
    cardIndexesToMove = slotCards.slice(cardIndexInSlot).map(card => card.index);

  cardIndexesToMove.forEach(cardIndex => {
    moveCard(slotCards.find(card => card.index === cardIndex), newSlotName);
  });
}

function placeCardOnTable(card, slotName, upturned){
  buildCardNode(card);
  moveCard(card, slotName, upturned);
}

const slots = {
  stock       : {cards: [], node: div.querySelector('#stock')},
  waste       : {cards: [], node: div.querySelector('#waste')},
  foundation0 : {cards: [], node: div.querySelector('#foundation0')},
  foundation1 : {cards: [], node: div.querySelector('#foundation1')},
  foundation2 : {cards: [], node: div.querySelector('#foundation2')},
  foundation3 : {cards: [], node: div.querySelector('#foundation3')},
  pile0       : {cards: [], node: div.querySelector('#pile0')},
  pile1       : {cards: [], node: div.querySelector('#pile1')},
  pile2       : {cards: [], node: div.querySelector('#pile2')},
  pile3       : {cards: [], node: div.querySelector('#pile3')},
  pile4       : {cards: [], node: div.querySelector('#pile4')},
  pile5       : {cards: [], node: div.querySelector('#pile5')},
  pile6       : {cards: [], node: div.querySelector('#pile6')},
};

const styleElem = document.createElement('style');
div.appendChild(styleElem);

let activeCard = null;

function toggleActiveCard(card = null){
  styleElem.sheet.cssRules.length > 0 && styleElem.sheet.deleteRule(0);

  if (card) {
    activeCard = card;
    styleElem.sheet.insertRule(`[data-index='${activeCard.index}'] {box-shadow: 4px 4px purple inset, -4px -4px purple inset;}`);
  } else {
    activeCard = null;
  }
}

function flipCard(card){
  card.upturned = true;
  card.node.dataset.upturned = card.upturned;
  updateCardsDebugInfo();
}

function isLast(card){
  return slots[card.slotName].cards.at(-1).index === card.index;
}

function canBeMoved(card){
  if (card.slotName.startsWith('pile')) {
    return card.upturned || isLast(card);
  } else {
    return isLast(card);
  }
}

function canBePlacedHere(clickedCard){
  if (clickedCard.slotName.startsWith('foundation')) {
    return (
      clickedCard.suit === activeCard.suit &&
      ranks.indexOf(clickedCard.rank) === ranks.indexOf(activeCard.rank) - 1
    )
  }
  if (clickedCard.slotName.startsWith('pile')) {
    return (
      clickedCard.suitColor !== activeCard.suitColor &&
      ranks.indexOf(clickedCard.rank) === ranks.indexOf(activeCard.rank) + 1
    );
  }
  return false;
}

function cardClickHandler(e){
  e.stopPropagation();

  const card = deck[e.currentTarget.dataset.index];

  if (card.slotName === 'stock' && canBeMoved(card)) {
  	moveCard(card, 'waste');
    return;
  }

  if (card.slotName.startsWith('pile') && !card.upturned && isLast(card)) {
    flipCard(card);
    return;
  }

  if (activeCard) {
    if (activeCard.index !== card.index && canBePlacedHere(card)) {
      moveCardsPile(activeCard, card.slotName);
    }
    toggleActiveCard();

  } else {
    if (canBeMoved(card)) {
      toggleActiveCard(card);
    }
  }
}

function stockClickHandler(){
  if (slots.stock.cards.length > 0) {
  	return;
  }

  const wasteCardIndexes = slots.waste.cards.map(card => card.index);
  wasteCardIndexes.reverse().forEach(cardIndex => {
    moveCard(deck[cardIndex], 'stock', false);
  });
}

function foundationClickHandler(e){
  const slotName = e.currentTarget.id;
  if (slots[slotName].cards.length > 0) {
  	return;
  }

  if (activeCard.rank === 'A') {
  	moveCard(activeCard, slotName);
  } else {
    toggleActiveCard();
  }
}

function pileClickHandler(e){
  const slotName = e.currentTarget.id;
  if (slots[slotName].cards.length > 0) {
    return;
  }

  if (activeCard.rank === 'K') {
    moveCardsPile(activeCard, slotName);
  } else {
    toggleActiveCard();
  }
}

function placeCardsOnTable(){
  let cardIndex = 0;
  for (let pileIndex = 0, pilesTotal = 7; pileIndex < pilesTotal; pileIndex++) {
    for (let indexInPile = 0, cardsInPileTotal = pileIndex; indexInPile <= cardsInPileTotal; indexInPile++) {
      placeCardOnTable(
        deck[cardIndex++],
        `pile${pileIndex}`,
        indexInPile === cardsInPileTotal
      );
    }
  }

  const cardsInPiles = cardIndex;
  deck.slice(cardsInPiles).forEach(card => {
    placeCardOnTable(card, 'stock', false);
  });
}

function initListeners(){
  deck.forEach(card => {
    card.node.addEventListener('click', cardClickHandler);
  });

  div.querySelector('#stock').addEventListener('click', stockClickHandler);

  for (let i = 0, len = 4; i < len; i++) {
    div.querySelector('#foundation' + i).addEventListener('click', foundationClickHandler);
  }
  for (let i = 0, len = 7; i < len; i++) {
    div.querySelector('#pile' + i).addEventListener('click', pileClickHandler);
  }

  div.addEventListener('chick', e => {
    if (e.code === 'KeyD' && e.ctrlKey && e.altKey) {
      toggleDebug();
    }
  });
}

placeCardsOnTable();
initListeners();
toggleDebug(false);

}
