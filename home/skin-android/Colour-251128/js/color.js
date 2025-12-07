var htmltxt = `
    <div class="color-container">
        <table id="colorPalette"></table>
    </div>
`;

function jsload(div) {
    let ele = $(".jsload .color-container");
    _JS.create(ele);
}

var _JS = (function(){
    function create(div2){
        const colors = [
            '#D6F0E5', '#F3F3A6', '#C2F3B9', '#E0F3B9', '#A8F3E1',
            '#F0F0D6', '#F0D7DD', '#E6F0F0', '#bfbfbf', '#8c8c8c',
            '#ffe5e5', '#ffb3b3', '#ff8080', '#ff4d4d', '#ff1a1a',
            '#e60000', '#b30000', '#800000', '#4d0000', '#1a0000',
            '#ffffe5', '#ffffb3', '#ffff80', '#ffff4d', '#ffff1a',
            '#e5e600', '#b2b300', '#7f8000', '#4c4d00', '#191a00',
            '#e5ffe5', '#b3ffb3', '#80ff80', '#4dff4d', '#1aff1a',
            '#00e600', '#00b300', '#008000', '#004d00', '#001a00',
            '#e5ffff', '#b3ffff', '#80ffff', '#4dffff', '#1affff',
            '#00e5e6', '#00b2b3', '#007f80', '#004c4d', '#00191a',
            '#ffe5ff', '#ffb3ff', '#ff80ff', '#ff4dff', '#ff1aff',
            '#e600e5', '#b300b2', '#80007f', '#4d004c', '#1a0019',
            '#e5eeff', '#b3ccff', '#80aaff', '#4d88ff', '#1a66ff',
            '#004de6', '#003cb3', '#002b80', '#001a4d', '#00091a',
            "#09001a","#1a004d","#2b0080","#3c00b3","#4d00e6",
            "#661aff","#884dff","#aa80ff","#ccb3ff","#eee5ff",
            "#1a0900","#4d1900","#802b00","#b33b00","#e64d00",
            "#ff661a","#ff884d","#ffaa80","#ffccb3","#ffeee5",
        ];

        const table = div2.querySelector('#colorPalette');
        const numRows = Math.ceil(colors.length / 10);

        for (let i = 0; i < numRows; i++) {
            const row = document.createElement('tr');
            for (let j = 0; j < 10; j++) {
                const index = i * 10 + j;
                if (index < colors.length) {
                    const cell = document.createElement('td');
                    const color = colors[index];
                    cell.style.backgroundColor = color;
                    cell.dataset.color = color;
                    _JS.click(cell, 
                        (e) => { // 点击处理
                            console.log("yong:text "+color);
                        },
                        (e) => { // 长按处理
                            console.log("yong:text "+this.hexToRgb(color));
                        }
                    );
                    row.appendChild(cell);
                }
            }
            table.appendChild(row);
        }
    }

				function click(ele, clickHandler, longPressHandler) {
				    let pressTimer;
				    let isScrolling = false;
				    let isLongPress = false;
				    const threshold = 500;
				
				    ele.addEventListener('touchstart', (e) => {
				        isScrolling = false;
				        isLongPress = false;
				        pressTimer = setTimeout(() => {
				            isLongPress = true;
				            longPressHandler(e);
				        }, threshold);
				    });
				
				    ele.addEventListener('touchmove', (e) => {
				        if (!isScrolling) {
				            isScrolling = true;
				            clearTimeout(pressTimer);
				        }
				    });
				
				    ele.addEventListener('touchend', (e) => {
				        clearTimeout(pressTimer);
				        if (!isScrolling && !isLongPress) {
				            clickHandler(e);
				        }
				        isScrolling = false;
				        isLongPress = false;
				    });
				
				    ele.addEventListener('touchcancel', () => {
				        clearTimeout(pressTimer);
				        isScrolling = false;
				        isLongPress = false;
				    });
				}


    function hexToRgb(hex) {
        hex = hex.replace(/^#/, '');
        const r = parseInt(hex.substring(0, 2), 16);
        const g = parseInt(hex.substring(2, 4), 16);
        const b = parseInt(hex.substring(4, 6), 16);
        return `rgba(${r}, ${g}, ${b}, 1)`;
    }

    return {
        create,
        click,
        hexToRgb
    };
})();
