var htmltxt = `<table>
  <tr>
    <td colspan="4"><input class="txt" type="text" disabled /></td>
  </tr>
  <tr>
    <td colspan="2"><input class="btn_click" type="button" value="AC" /></td>
    <td colspan="2"><input class="btn_click" type="button" value="DEL" /></td>
  </tr>
  <tr>
    <td><input class="btn" type="button" value="7" /></td>
    <td><input class="btn" type="button" value="8" /></td>
    <td><input class="btn" type="button" value="9" /></td>
    <td><input class="btn" type="button" value="*" /></td>

  </tr>
  <tr>
    <td><input class="btn" type="button" value="4" /></td>
    <td><input class="btn" type="button" value="5" /></td>
    <td><input class="btn" type="button" value="6" /></td>
    <td><input class="btn" type="button" value="/" /></td>
  </tr>
  <tr>
    <td><input class="btn" type="button" value="1" /></td>
    <td><input class="btn" type="button" value="2" /></td>
    <td><input class="btn" type="button" value="3" /></td>
    <td><input class="btn" type="button" value="-" /></td>
  </tr>
  <tr>
    <td><input class="btn" type="button" value="." /></td>
    <td><input class="btn" type="button" value="0" /></td>
    <td><input class="btn" type="button" value="=" /></td>
    <td><input class="btn" type="button" value="+" /></td>
  </tr>
</table>`;

function jsload(div) {
  var way_res = [];
  var btn_txt = div.getElementsByClassName("btn");
  var txt = div.getElementsByClassName("txt")[0];
  var btn_way = div.getElementsByClassName("btn_click");
  var result = ""; // 用于存储计算结果
  var expression = ""; // 存储计算表达式
  var touchTimer; // 长按计时器
  var touchStartTime; // 触摸开始时间
  var touchStartX; // 触摸开始的X坐标
  var touchStartY; // 触摸开始的Y坐标
  var lastInputIsOperator = false; // 标记上一个输入是否为运算符
  var originalExpression = ""; // 保存原始表达式

  for (var i = 0; i < btn_way.length; i++) {
    btn_way[i].onclick = function() {
      if (this.value == "AC") {
        way_res = [];
        txt.value = "";
        result = "";
        expression = "";
        originalExpression = ""; // 清空原始表达式
        lastInputIsOperator = false;
      } else {
        txt.value = txt.value.substr(0, txt.value.length - 1);
        expression = expression.substr(0, expression.length - 1);
        originalExpression = originalExpression.substr(0, originalExpression.length - 1); // 同时修改 originalExpression
      }
    };
  }

  for (var i = 0; i < btn_txt.length; i++) {
    btn_txt[i].onclick = function() {
      var inputValue = this.value;

      if (inputValue == "=") {
        try {
          result = eval(expression).toFixed(4).replace(/\.?0+$/, '');
          txt.value = result;
          way_res = [];
          expression = result;
          lastInputIsOperator = false;
        } catch (e) {
          txt.value = "Error";
          result = '';
          expression = '';
          originalExpression = ''; // 计算出错时清空原始表达式
          lastInputIsOperator = false;
        }
      } else {
        if (isNaN(inputValue) && inputValue != ".") {
          if (lastInputIsOperator) return;
          txt.value += inputValue;
          expression += inputValue;
          originalExpression += inputValue; // 同时修改 originalExpression
          lastInputIsOperator = true;
        } else {
          if (inputValue == ".") {
            const lastNumber = expression.split(/[\+\-\*\/]/).pop();
            if (lastNumber.indexOf(".") != -1) {
              return;
            } else {
              txt.value += inputValue;
              expression += inputValue;
              originalExpression += inputValue; // 同时修改 originalExpression
              lastInputIsOperator = false;
            }
          } else {
            txt.value += inputValue;
            expression += inputValue;
            originalExpression += inputValue; // 同时修改 originalExpression
            lastInputIsOperator = false;
          }
        }
      }
    };
  }

  txt.addEventListener('touchstart', function(event) {
    touchStartTime = new Date().getTime();
    touchStartX = event.touches[0].clientX;
    touchStartY = event.touches[0].clientY;

    touchTimer = setTimeout(function() {
      if (originalExpression && result) {
        // 使用 originalExpression 输出原始计算公式
        App.text(originalExpression + "=" + result);
      }
    }, 500);
  });

  txt.addEventListener('touchmove', function(event) {
    clearTimeout(touchTimer);
  });

  txt.addEventListener('touchend', function(event) {
    clearTimeout(touchTimer);
    var touchEndTime = new Date().getTime();
    var touchDuration = touchEndTime - touchStartTime;
    var touchEndX = event.changedTouches[0].clientX;
    var touchEndY = event.changedTouches[0].clientY;
    var moveThreshold = 10;

    if (touchDuration < 500 && Math.abs(touchEndX - touchStartX) < moveThreshold && Math.abs(touchEndY - touchStartY) < moveThreshold) {
      if (txt.value) {
        App.text(txt.value);
      }
    }
  });
}
