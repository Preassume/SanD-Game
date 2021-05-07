import std.stdio;
import std.conv;
import std.string;
import raylib;
import menu.button;
import grid;
import elements;

void main(){
	SetTargetFPS(60);
	InitWindow(1280, 720, "S a n d");
	
	enum width = 160;
	enum height = 75;
	
	elementGrid e = new elementGrid(Vector2(0, 120), width, height, 8);
	
	auto b = new Button(Rectangle(160, 0, 150, 50), "Next");
	auto b2 = new Button(Rectangle(320, 0, 150, 50), "Reset");
	auto b3 = new ToggleButton(Rectangle(0, 0, 150, 50), "Pause");
	
	// Generate code for initializing buttons for each element
	static foreach(i; 0 .. elements.elementNames.length){
		mixin("auto eButton" ~ to!string(i) ~ " = new Button(Rectangle(i * 160, 70, 150, 50), elementNames[i]);");
	}
	
	while (!WindowShouldClose())
	{
		SetWindowTitle(toStringz("S a n d  -  " ~ to!string(GetFPS) ~ " FPS"));
		BeginDrawing();
		
		ClearBackground(Colors.BLACK);
		
		if(!b3.Pressed){
			e.update();
		}
		else if(b.Pressed){
			e.update();
		}
		if(b2.Pressed){
			e.reset();
		}
		
		if(IsKeyPressed(KeyboardKey.KEY_SPACE)) b3.toggle();
		
		// Generate code to handle clicks and drawing for buttons
		static foreach(i; 0 .. elements.elementNames.length){
			mixin("if(eButton" ~ to!string(i) ~ ".Pressed) e.brush = elementNames[i];");
			mixin("eButton" ~ to!string(i) ~ ".draw();");
		}
		
		e.draw();
		b.draw();
		b2.draw();
		b3.draw();
		
		EndDrawing();
	}
	CloseWindow();
}
