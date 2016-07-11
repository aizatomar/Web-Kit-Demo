// Inject this script to modify CSS
var styleTag = document.createElement("style");
styleTag.textContent = ' .gb_Rb {display:none;}';   // Hide menu button
document.documentElement.appendChild(styleTag);