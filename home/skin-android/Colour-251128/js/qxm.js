var htmltxt=`
    <svg id="board"></svg>
`;

function jsload(on){
const boundary = { adjacent: [], distance: 0 };

const SVG_NS = "http://www.w3.org/2000/svg";

const DEBUG = true; 

class Spot {
  constructor(board, x, y) {
    var circle = document.createElementNS(SVG_NS, "circle");
    circle.setAttribute("class", "spot");
    circle.setAttribute("cx", 20 + 33 * x + (y % 2 ? 20 : 0));
    circle.setAttribute("cy", 20 + 30 * y);
    circle.setAttribute("r", 13);
    circle.addEventListener("click", this.handleClick.bind(this));
    document.getElementById("board").appendChild(circle);
    this.svgCircle = circle;

    if (DEBUG) {
      const text = document.createElementNS(SVG_NS, "text");
      text.setAttribute("class", "debug");
      text.setAttribute("x", 20 + 33 * x + (y % 2 ? 20 : 0));
      text.setAttribute("y", 23 + 30 * y);
      document.getElementById("board").appendChild(text);
      this.svgText = text;
    }

    this.board = board;
    this.x = x;
    this.y = y;
    this.blocked = false;
    this.adjacent = [];
    this.distance = Infinity;
  }

  draw(drawCat = true) {
    let classes = "spot";
    if (this.blocked) classes += " blocked";
    if (drawCat && this.board.cat === this) classes += " cat";
    this.svgCircle.setAttribute("class", classes);
  }

  handleClick(e) {
    if (this.board.cat === this || this.blocked) return;
    this.blocked = true;
    this.draw();
    this.board.moveCat();
  }
}

class Board {
  constructor(height, width, numBlocks) {
    console.assert(height % 2 && width % 2, "Height & width must be odd");

    this.height = height;
    this.width = width;
    const htmlBoard = document.getElementById("board");
    htmlBoard.setAttribute("width", width * 33 + 30);
    htmlBoard.setAttribute("height", height * 30 + 12);

    this.grid = {};

    for (let y = 0; y < height; y++)
      for (let x = 0; x < width; x++)
        if (!(x === 0 && (y === 0 || y === this.height - 1)))
          this.grid[`${x}-${y}`] = new Spot(this, x, y);

    this.createGraph();
    this.setInitialCat();
    this.setInitialBlocks(numBlocks);
    this.drawInitialBoard();
    if (DEBUG) {
      this.updateDistances();
      this.showDistances();
    }
  }

  setInitialCat() {
    const x = Math.floor(this.width / 2.5 + Math.random() * (this.width / 5));
    const y = Math.floor(this.height / 2.5 + Math.random() * (this.height / 5));
    this.cat = this.grid[`${x}-${y}`];
  }

  setInitialBlocks(numBlocks) {
    let i = 0;
    while (i < numBlocks) {
      const dx = Math.floor((Math.random() * this.width) / 4);
      const dy = Math.floor((Math.random() * this.height) / 4);
      const x = Math.random() < 0.5 ? dx : this.width - dx - 1;
      const y = Math.random() < 0.5 ? dy : this.height - dy - 1;
      const spot = this.grid[`${x}-${y}`];
      if (spot && !spot.blocked && this.cat !== spot) {
        spot.blocked = true;
        i += 1;
      }
    }
  }

  drawInitialBoard() {
    for (let spot of Object.values(this.grid)) spot.draw();
  }

  createGraph() {
    for (let spot of Object.values(this.grid)) {
      const { x, y } = spot;
      let cands;

      if (y % 2 == 0)
        cands = [
          this.grid[`${x - 1}-${y - 1}`],
          this.grid[`${x}-${y - 1}`],
          this.grid[`${x - 1}-${y}`],
          this.grid[`${x + 1}-${y}`],
          this.grid[`${x - 1}-${y + 1}`],
          this.grid[`${x}-${y + 1}`]
        ];
      else
        cands = [
          this.grid[`${x}-${y - 1}`],
          this.grid[`${x + 1}-${y - 1}`],
          this.grid[`${x - 1}-${y}`],
          this.grid[`${x + 1}-${y}`],
          this.grid[`${x}-${y + 1}`],
          this.grid[`${x + 1}-${y + 1}`]
        ];

      spot.adjacent = cands.filter(neigh => neigh !== undefined);

      if (x === 0 || y === 0 || x === this.width - 1 || y === this.height - 1) {
        boundary.adjacent.push(spot);
      }
    }
  }

  updateDistances() {
    for (let key in this.grid) this.grid[key].distance = Infinity;

    const toVisit = [boundary];
    const seen = new Set();

    while (toVisit.length > 0) {
      const spot = toVisit.shift();

      for (let n of spot.adjacent) {
        if (seen.has(n) || n.blocked) continue;
        seen.add(n);
        n.distance = spot.distance + 1;
        toVisit.push(n);
      }
    }
  }

  /** Show distances  */
  showDistances() {
    for (let n of Object.values(this.grid))
//      n.svgText.innerHTML = n.distance === Infinity ? "∞" : n.distance;
      n.svgText.innerHTML = n.distance === Infinity ? "x" : "";

  }

  nextStepForCat() {
    this.updateDistances();
    if (DEBUG) this.showDistances();
    const adjToCat = this.cat.adjacent;
    const distancesNextToCat = adjToCat.map(n => n.distance);
    const minSteps = Math.min(...distancesNextToCat);
    const paths = adjToCat.filter(n => n.distance === minSteps);
    return paths[Math.floor(Math.random() * paths.length)];
  }

  moveCat() {
    const move = this.nextStepForCat();

    if (move.distance === Infinity) return this.gameEnd("👏围堵成功👍");

    this.cat.draw(false);
    this.cat = move;
    this.cat.draw();

    if (this.cat.distance === 1) return this.gameEnd("围堵失败🙄");
  }

  gameEnd(outcome) {
		alert(outcome);
    window.setTimeout(() => {
			board = new Board(11, 11, 6);
			}, 3000);

  }
}

/* 格子11x11 障碍物6 */
const board = new Board(11, 11, 6);
}
