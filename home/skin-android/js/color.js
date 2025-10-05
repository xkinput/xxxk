var htmltxt = '<table id="colorPalette"></table>';
function jsload(div) {
  const colors = [ // 10x6
    '#ffe5e5', '#ffb3b3', '#ff8080', '#ff4d4d', '#e60000', 
    '#800000','#f2f2f2', '#d9d9d9', '#bfbfbf', '#8c8c8c',

    '#595959', '#262626','#ffffff', '#000000', '#0000FF',
    '#ff00FF', '#FF0000', '#ffff00','#e5ffe5', '#b3ffb3',

    '#80ff80', '#4dff4d', '#00e600', '#008000','#e5e5ff',
    '#b3b3ff', '#8080ff', '#4d4dff', '#0000e6', '#000080',

    '#ffffe5', '#ffffb3', '#ffff4d', '#ffff1a', '#e5e600',
    '#b2b300','#ffe5ff', '#ffb3ff', '#ff80ff', '#ff4dff',

    '#e600e5', '#80007f','#e5f9ff', '#b3ecff', '#4dd2ff',
    '#00ace6', '#0086b3', '#00394d','#f48ead', '#f3be8c',

    '#fbcb8b', '#f08770', '#ff616a', '#f1a1c1','#5e81ac',
    '#88c0d0', '#8fbcbb', '#f07c82', '#813c85', '#a7a8bd'
  ];

  const table = div.querySelector('#colorPalette');
  const numRows = Math.ceil(colors.length / 10);

  for (let i = 0; i < numRows; i++) {
    const row = document.createElement('tr');
    for (let j = 0; j < 10; j++) {
      const index = i * 10 + j;
      if (index < colors.length) {
        const cell = document.createElement('td');
        cell.style.backgroundColor = colors[index];
        attachTouchEvents(cell, colors[index]);
        row.appendChild(cell);
      }
    }
    table.appendChild(row);
  }
}

function attachTouchEvents(cell, color) {
  let timeoutId;
  let isLongPress = false;
  let startX = 0;
  let isSwiping = false;

  cell.addEventListener('touchstart', (event) => {
    event.preventDefault();
    isLongPress = false;
    isSwiping = false;
    startX = event.touches[0].clientX;

    timeoutId = setTimeout(() => {
      if (!isSwiping) {
        isLongPress = true;
        const rgba = hexToRgb(color);
        console.log("yong:text "+rgba)
      }
    }, 1000);
  });

  cell.addEventListener('touchmove', (event) => {
    const currentX = event.touches[0].clientX;
    const deltaX = Math.abs(currentX - startX);
    if (deltaX > 10) {
      isSwiping = true;
      clearTimeout(timeoutId);
    }
  });

  cell.addEventListener('touchend', () => {
    clearTimeout(timeoutId);
    if (!isLongPress && !isSwiping) {
      console.log("yong:text "+ color.replace(/^#/,''))
    }
    isSwiping = false;
  });

  cell.addEventListener('touchcancel', () => {
    clearTimeout(timeoutId);
    isLongPress = false;
    isSwiping = false;
  });
}

function hexToRgb(hex) {
  hex = hex.slice(1);
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return `rgba(${r}, ${g}, ${b}, 1)`;
}
