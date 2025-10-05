var htmltxt=`
<table id="board"></table>

<section class="score-area">
  Hover: <b id="hover"></b> | 
  Score = <b id="score"></b> + <b id="score-left"></b> = <b id="score-total"></b>
</section>
`;

function jsload(on){
class SameGame {

  /** Create & start game. */

  constructor(
      ncolors = 4, 
      width = 16,
      height = 12,
      color_vocab = ["green", "blue", "red", "orange", "brown", "pink"],
    ) {
    this.ncolors = ncolors;
    this.width = width;
    this.height = height;
    this.color_vocab = color_vocab;
    this.hoverCluster = [];           // cluster currently hovering over
    this.score = 0;
    this.numCells = height * width;   // cells remaining [used to score]

    this.board = this.randomBoard();  // array [x][y], top-left is [0][0]
    
    this.createHTMLTable();
    this.updateGame();
    this.updateHoverScore(0);         // curr not hovering
  }

  /** Update game state: called at start & after every move. */

  updateGame() {
    this.handleOut();
    this.updateScore(this.hoverCluster.length);
    this.hoverCluster = [];
    this.updateClusters();
    this.draw();
    if (this.checkWin()) {
      alert("game over")
    }
  }

  /** Make random board of randomly-colored cells.
   * 
   * Board is array [x][y]
   */

  randomBoard() {
    return Array.from(
      { length: this.width }, () => Array.from(
        { length: this.height }, () => ({
          color: this.color_vocab[Math.floor(Math.random() * this.ncolors)],
          cluster: []
        })
      ));
  }

  /** Create HTML table board:
   * 
   * - each cell gets id "#c-{x}-{y}" & handlers for hover/de-hover/click
   */

  createHTMLTable() {
    for (let y = 0; y < this.height; y += 1) {
      let tr = document.createElement("tr");
      for (let x = 0; x < this.width; x += 1) {
        let td = document.createElement("td");
        td.id = `c-${x}-${y}`;
        td.addEventListener("mouseover", this.handleHover.bind(this, x, y));
        td.addEventListener("mouseout", this.handleOut.bind(this, x, y));
        td.addEventListener("click", this.handleClick.bind(this, x, y));
        tr.appendChild(td)
      }
      document.querySelector("#board").appendChild(tr)
    }
  }

  /** draw updated game board. */

  draw() {
    for (let y = 0; y < this.height; y += 1) {
      for (let x = 0; x < this.width; x += 1) {
        const cell = document.querySelector(`#c-${x}-${y}`);
        cell.style.backgroundColor = this.board[x][y].color;      
      }
    }
  }

  /** update clusters on board. */

  updateClusters() {
    this.draw();
    // mark cell clusters as undefined, since we haven't explored yet
    for (let y = 0; y < this.height; y += 1)
      for (let x = 0; x < this.width; x += 1)
        this.board[x][y].cluster = undefined;

    // scan each cell of board, finding the cluster that it is part
    // of and saving to the .cluster attr
    
    for (let y = 0; y < this.height; y += 1) {
      for (let x = 0; x < this.width; x += 1) {
        const cell = this.board[x][y];

        // don't search from a cell if we've already explored it
        if (cell.cluster !== undefined) continue;

        cell.cluster = [];

        // skip over empty cells
        if (cell.color === null) continue;

        // DFS: recursively explore neighbors to add to cluster
        const toVisit = [[x, y]];
        while (toVisit.length > 0) {
          let [ox, oy] = toVisit.pop();

          // skip neighbor if outside board or already part of a cluster
          if (oy < 0 || oy === this.height || ox < 0 || ox === this.width) continue;
          let neighbor = this.board[ox][oy];
          if (neighbor.cluster && neighbor.cluster.length) continue;
          
          // if color matches, make part of this cluster and explore its neighbors
          if (cell.color === neighbor.color) {
            neighbor.cluster = cell.cluster;
            cell.cluster.push([ox, oy]);
            // explore the LRTB neighbors of curr neighbor
            toVisit.push([ox - 1, oy], [ox + 1, oy], [ox, oy - 1], [ox, oy + 1])
          }
        }
      }
    }
  }

  /** start hovering over a cell:
   * 
   * - if empty spot/single-cell cluster: update hover-score to 0
   * - else: show hover-score for cluster & add .hovering in CSS
   */

  handleHover(ox, oy) {
    this.hoverCluster = this.board[ox][oy].cluster;
    
    if (this.hoverCluster.length > 1) {
      for (let [x, y] of this.hoverCluster) {
        document.querySelector(`#c-${x}-${y}`).classList.add("hovering");
      }
    } else {
      this.hoverCluster = [];
    }

    this.updateHoverScore(this.hoverCluster.length)
  }

  /** stop hovering on a cell: remove .hovering and set hover-score to 0 */

  handleOut() {
    for (let [x, y] of this.hoverCluster) {
      document.querySelector(`#c-${x}-${y}`).classList.remove("hovering");
      this.updateHoverScore(0)
    }
  }

  /** update hover-score for hovering over ntiles = ntiles ^ 2 */

  updateHoverScore(ntiles) {
    document.querySelector("#hover").innerHTML = String(ntiles * ntiles);
  }

  /** update score for removing cluster of ntiles:
   * 
   * - main score += ntiles ^ 2
   * - tiles left score = for <50 tiles, 100/tile removed  
   * - total score = sum of those two
   */

  updateScore(ntiles) {
    this.score += (ntiles * ntiles);
    this.scoreLeft = Math.max((50 - this.numCells) * 100, 0);
    this.scoreTotal = this.score + this.scoreLeft;

    document.querySelector("#score").innerHTML = String(this.score)
    document.querySelector("#score-left").innerHTML = String(this.scoreLeft)
    document.querySelector("#score-total").innerHTML = String(this.scoreTotal)
  }

  /** game is "won" when all cells aren't part of 2+ cluster */

  checkWin() {
    for (let y = 0; y < this.height; y += 1) {
      for (let x = 0; x < this.width; x += 1) {
        if (this.board[x][y].cluster.length) return false;
      }
    }
    return true;
  }

  /** Click on a cell:
   * 
   * - ignore entirely if a 1-cell-cluster or blank spot
   * - moving from R->L, T->B, remove cells in cluster
   * - if that empties row, close up gap
   * - update game state & hover over curr cell where clicked
   */

  handleClick(ox, oy) {
    // don't do anything for empty cells/one-cell clusters
    if (this.hoverCluster.length < 2) return;

    // work on each col, from R -> L
    for (let x = this.width - 1; x >= 0; x--) {

      // get Y coords for cluster cells in this col, T->B order
      let ys = this.hoverCluster
        .filter(([ix, iy]) => ix === x)
        .map(([ix, iy]) => iy)
        .sort((ax, bx) => bx - ax);

      // remove those cells
      for (let y of ys) {
        this.board[x].splice(y, 1);
        this.numCells--;
      }

      // add cells at top for missing cells
      while (this.board[x].length < this.height) {
        this.board[x].unshift({ color: null, cluster: [] })
      }

      // if that empties entire col, move col left
      if (this.board[x].every(c => c.cluster.length === 0)) {
        for (let mx = x; mx < this.width; mx++) {
          for (let my = 0; my < this.height; my++) {
            // replace this cell w/cell on right or empty if none
            this.board[mx][my] = mx < this.width - 1
              ? this.board[mx + 1][my]
              : { color: null, cluster: [] };
          }
        }
      }
    }

    this.updateGame();

    // We want to hover over same x/y in case now is new cluster
    this.handleHover(ox, oy);
  }
}


game = new SameGame(4, 20, 16);
}
