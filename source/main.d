import std.stdio;
import std.conv;
import std.string;
import raylib;
import menu;
import grid;
import elements;

auto scale = 1; // If scale is set to 1, the window will be auto-scaled

enum width = 263; // Number of dots wide the sand grid will be

enum height = 180; // Number of dots tall the sand grid will be

enum menuWidth = 57; // Width of the menu pre-scaling

// Get the grid coordinates of the mouse position
int mouseX(){
	return (GetMouseX / scale);
}
int mouseY(){
	return (GetMouseY / scale);
}

// Determine what scale should be used based on the monitor resolution
int getScale(){
	auto maxH = GetMonitorHeight(0) / height;
	auto maxW = GetMonitorWidth(0) / width;
	int newSize;
	if(maxW < maxH) newSize = maxW;
	else newSize = maxH;
	
	if(newSize <= 2) return 2;
	
	return newSize - 1;
}

void main(){
	InitWindow(width + menuWidth, height, "S a n d");
	SetTargetFPS(60);
	
	// Get scale and set window size
	if(scale < 2) scale = getScale();
	SetWindowSize(width * scale + menuWidth * scale, height * scale);
	
	// s will be our sand grid
	auto s = new elementGrid(width, height);
	
	// Texture to draw the grid on
	auto gridTex = LoadRenderTexture(width, height);
	
	// generate elementButton objects for each element in the file "elements/package.d"
	static foreach(i; 0 .. elements.elementNames.length){
		mixin("auto tmp" ~ to!string(i) ~ " = new " ~ elementNames[i] ~ "(0, 0);");
		mixin("auto eButton" ~ to!string(i) ~ " = new elementButton(Rectangle(width * scale + (19 * scale * (i % 3)) + 2, (i / 3) * 8 * scale, 18 * scale, 7 * scale), elementNames[i], tmp" ~ to!string(i) ~ ".color);");
		mixin("tmp" ~ to!string(i) ~ ".destroy();");
	}
	
	// selRec and selRecAlt are used to indicate which elements are currently selected
	Rectangle selRec = eButton1.rec;
	Rectangle selRecAlt = eButton0.rec;
	
	// Texture to draw the menu on
	auto menuTex = LoadRenderTexture(width * scale + menuWidth * scale, height * scale);
	
	// imgButtons for pause/next frame/reset/fast forward. Their images are draw with functions which are passed into the constructor
	auto btnPause = new imgToggleButton(Rectangle(width * scale + (14.3 * scale * 0) + 2, 122 * scale + 2, 13 * scale, 13 * scale), &drawPause);
	auto btnNext = new imgButton(Rectangle(width * scale + (14.3 * scale * 1) + 2, 122 * scale + 2, 13 * scale, 13 * scale), &drawNextFrame);
	auto btnReset = new imgButton(Rectangle(width * scale + (14.3 * scale * 2) + 2, 122 * scale + 2, 13 * scale, 13 * scale), &drawReset);
	auto btnFastForward = new imgToggleButton(Rectangle(width * scale + (14.3 * scale * 3) + 2, 122 * scale + 2, 13 * scale, 13 * scale), &drawFastForward);
	
	// The information in the bottom right of the screen
	auto info = new Info(width * scale + (menuWidth * scale) / 2, 148 * scale, 8 * scale);
	
	bool fastForward = false;
	
	// These colors will be used to draw the background gradient of the element selection menu
	Color primaryColor = eButton1.backColor;
	Color secondaryColor = eButton0.backColor;
	
	ubyte c = 0;
	while (!WindowShouldClose())
	{
		// Every 10 frames update the window title
		if(c % 10 == 0) SetWindowTitle(toStringz("S a n d  -  " ~ to!string(GetFPS) ~ " FPS - (" ~ to!string(GetScreenWidth()) ~ " x " ~ to!string(GetScreenHeight()) ~ ')' ~ "   scale: " ~ to!string(scale)));
		c++;
		
		BeginDrawing();
			
			// The grid is drawn onto a texture which can be scaled later
			BeginTextureMode(gridTex);
				
				// Handle mouse clicks
				if(IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON)){
					s.doBrush(mouseX(), mouseY());
				}
				else if(IsMouseButtonDown(MouseButton.MOUSE_RIGHT_BUTTON)){
					s.doBrushAlt(mouseX(), mouseY());
				}
				
				// Draw the grid onto our texture
				s.drawGrid();
				
				// Handle mouse scrolling to change brush size
				if(GetMouseWheelMove() > 0) s.brushSize = s.brushSize + 1;
				else if(GetMouseWheelMove() < 0) s.brushSize = s.brushSize - 1;
				if(s.brushSize < 1) s.brushSize = 1;
				if(s.brushSize > height) s.brushSize = height;
				
				// Draw brush size preview
				DrawRectangle(
					mouseX - (s.brushSize / 2),
					mouseY - (s.brushSize / 2),
					s.brushSize,
					s.brushSize,
					Color(255, 255, 255, 100)
				);
				
				// Toggle on/off fast forward
				if(!btnFastForward.Pressed) fastForward = false;
				else fastForward = true;
				
				// Update the grid if we're not paused
				if(!btnPause.Pressed){
					if(fastForward) s.updateGridFast();
					else s.updateGrid();
				} // Otherwise, if we are paused, update once if 'F' or the next button are pressed
				else if(IsKeyPressed(KeyboardKey.KEY_F) || btnNext.Pressed) s.updateGrid();
				
				// Pressing spacebar will toggle the pause button
				if(IsKeyPressed(KeyboardKey.KEY_SPACE)) btnPause.toggle();
				
				// Pressing 'G' will toggle the fast forward button
				if(IsKeyPressed(KeyboardKey.KEY_G)) btnFastForward.toggle();
				
				// If 'R' or the reset button is pressed, reset the grid
				if(IsKeyPressed(KeyboardKey.KEY_R) || btnReset.Pressed) s.reset();
				
			EndTextureMode();
			
			// Another texture is used for the menu. The scaled grid texture is drawn here too.
			BeginTextureMode(menuTex);
				
				ClearBackground(Colors.BLACK);
				
				// Draw the color gradient based on the selected elements
				DrawRectangleGradientV(width * scale + 1, 0, menuWidth * scale, 122 * scale, secondaryColor, primaryColor);
				DrawRectangle(width * scale + 1, 0, menuWidth * scale, 122 * scale, Color(0, 0, 0, 140));
				
				// Draw some lines to indicate menu borders
				DrawLine(width * scale + 1, 0, width * scale + 1, height * scale, Colors.WHITE);
				DrawLine(width * scale + menuWidth * scale, 0, width * scale + menuWidth * scale, height * scale, Colors.WHITE);
				
				// Generate click events for all menu buttons for left and right clicks
				static foreach(i; 0 .. elements.elementNames.length){
					mixin("eButton" ~ to!string(i)).draw();
					if(mixin("eButton" ~ to!string(i)).Pressed){
						selRec = mixin("eButton" ~ to!string(i)).rec;
						s.Brush = elementNames[i];
						primaryColor = mixin("eButton" ~ to!string(i)).backColor;
					}
					else if(mixin("eButton" ~ to!string(i)).AltPressed){
						selRecAlt = mixin("eButton" ~ to!string(i)).rec;
						s.BrushAlt = elementNames[i];
						secondaryColor = mixin("eButton" ~ to!string(i)).backColor;
					}
				}
				
				// Draw the rectangles that indicate which elements are selected. If both are selecting the same element, the color will be purple.
				if(selRec.x == selRecAlt.x && selRec.y == selRecAlt.y) DrawRectangleLinesEx(selRec, cast(int)(eButton0.h / 16), Color(255, 0, 255, 255));
				else{
					DrawRectangleLinesEx(selRec, cast(int)(eButton0.h / 16), Color(255, 0, 0, 255));
					DrawRectangleLinesEx(selRecAlt, cast(int)(eButton0.h / 16), Color(0, 0, 255, 255));
				}
				
				// Separates element selection from the rest of the menu
				DrawLine(width * scale + 1, 122 * scale, width * scale + menuWidth * scale, 122 * scale, Colors.WHITE);
				
				// Draw the menu buttons
				btnPause.draw();
				btnNext.draw();
				btnReset.draw();
				btnFastForward.draw();
				
				// Update and draw the info in the bottom right of the screen
				info.setCoords(mouseX(), mouseY());
				info.Dots = s.dotCount;
				info.type = s.getType(mouseX(), mouseY());
				info.draw();
				
				// Draw the grid texture scaled up
				DrawTexturePro(gridTex.texture, Rectangle(0, height, width, -height), Rectangle(0, 0, width * scale, height * scale), Vector2(0,0), 0, Colors.WHITE);
				
			EndTextureMode();
			
		// Finally, draw the menu texture onto the screen
		DrawTexturePro(menuTex.texture, Rectangle(0, height * scale, width * scale + menuWidth * scale, -(height * scale)), Rectangle(0, 0, width * scale + menuWidth * scale, height * scale), Vector2(0,0), 0, Colors.WHITE);
							
		EndDrawing();
	}
	CloseWindow();
}

// Two rectangles for the pause button;
void drawPause(Rectangle r, Color back, Color primary){
	DrawRectangleRec(r, back);
	DrawRectangleLinesEx(r, cast(int)(r.w * 0.07), primary);
	
	DrawRectangleRec(Rectangle(r.x + r.w * 0.2, r.y + r.h * 0.15, r.w * 0.2, r.h * 0.7), primary);
	DrawRectangleRec(Rectangle(r.x + r.w * 0.6, r.y + r.h * 0.15, r.w * 0.2, r.h * 0.7), primary);
}

// A triangle and a rectangle for the next frame button
void drawNextFrame(Rectangle r, Color back, Color primary){
	DrawRectangleRec(r, back);
	DrawRectangleLinesEx(r, cast(int)(r.w * 0.07), primary);
	
	DrawTriangle(Vector2(r.x + r.w * 0.2, r.y + r.h * 0.15), Vector2(r.x + r.w * 0.2, r.y + r.h * 0.85), Vector2(r.x + r.w * 0.7, r.y + r.h * 0.5), primary);
	DrawRectangleRec(Rectangle(r.x + r.w * 0.65, r.y + r.h * 0.15, r.w * 0.2, r.h * 0.7), primary);
}

// Two ring segments and two triangles for the reset button
void drawReset(Rectangle r, Color back, Color primary){
	DrawRectangleRec(r, back);
	DrawRectangleLinesEx(r, cast(int)(r.w * 0.07), primary);
	
	DrawRing(Vector2(r.x + r.w / 2, r.y + r.h / 2), r.w * 0.2, r.w * 0.3, 330, 460, scale * 3, primary);
	DrawRing(Vector2(r.x + r.w / 2, r.y + r.h / 2), r.w * 0.2, r.w * 0.3, 150, 280, scale * 3, primary);
	
	DrawTriangle(Vector2(r.x + r.w * 0.15, r.y + r.h * 0.5), Vector2(r.x + r.w * 0.25, r.y + r.h * 0.7), Vector2(r.x + r.w * 0.35, r.y + r.h * 0.5), primary);
	DrawTriangle(Vector2(r.x + r.w * 0.85, r.y + r.h * 0.5), Vector2(r.x + r.w * 0.75, r.y + r.h * 0.3), Vector2(r.x + r.w * 0.65, r.y + r.h * 0.5), primary);
}

// Two triangles drawn for the fast forward button
void drawFastForward(Rectangle r, Color back, Color primary){
	DrawRectangleRec(r, back);
	DrawRectangleLinesEx(r, cast(int)(r.w * 0.07), primary);
	
	DrawTriangle(Vector2(r.x + r.w * 0.2, r.y + r.h * 0.15), Vector2(r.x + r.w * 0.2, r.y + r.h * 0.85), Vector2(r.x + r.w * 0.6, r.y + r.h * 0.5), primary);
	
	DrawTriangle(Vector2(r.x + r.w * 0.5, r.y + r.h * 0.15), Vector2(r.x + r.w * 0.5, r.y + r.h * 0.85), Vector2(r.x + r.w * 0.9, r.y + r.h * 0.5), primary);
}
