// document.addEventListener('DOMContentLoaded', () => {
$(document).on('turbolinks:load', function() {
  // 全ての colorBox 要素を取得
  const colorBoxes = document.querySelectorAll('.colorBox');

  // 各 colorBox 要素に対して処理を行う
  colorBoxes.forEach(colorBox => {
    // data- 属性から RGB 値を取得
    const red = colorBox.getAttribute('data-red');
    const green = colorBox.getAttribute('data-green');
    const blue = colorBox.getAttribute('data-blue');

    // RGBカラーコードを生成
    const rgbColor = `rgb(${red}, ${green}, ${blue})`;

    // 色見本に背景色を設定
    colorBox.style.backgroundColor = rgbColor;
  });
// });
});
