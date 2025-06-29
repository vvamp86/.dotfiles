let bg = Color(40, 40, 40);          // #282828
let fg = Color(235, 219, 178);       // #ebdbb2
let logVisible = false;

// Setup background
Window.SetBackgroundTopColor(bg);
Window.SetBackgroundBottomColor(bg);

// Progress bar
var progressBar = ProgressBar.New();
progressBar.SetPosition(0.5, 0.7);
progressBar.SetSize(0.5, 0.03);
progressBar.Show();

// Loading label
var label = new Label("Loading EndeavourOS…", 0.5, 0.5);
label.SetColor(fg);
label.SetFont("FiraCodeNerd.pf2");
label.Show();

// Handle key press to toggle log
function onKey(key) {
    if (key == "F2" || key == "ESC" || key == "Down") {
        logVisible = !logVisible;
        if (logVisible) {
            Plymouth.SetMode("details");  // Show logs
        } else {
            Plymouth.SetMode("splash");   // Back to splash
        }
    }
}
Plymouth.SetUpdateHandler(function () {});
Plymouth.SetKeyboardInputHandler(onKey);
