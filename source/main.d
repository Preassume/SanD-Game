import std.stdio;
import std.conv;
import std.string;
import raylib;
import menu;
import grid;
import elements;

void main(){
	SetTargetFPS(60);
	
	enum width = 320;
	enum height = 150;
	int size = 3;
	
	elementGrid e = new elementGrid(Vector2(0, 120), width, height, size);
	
	auto b = new Button(Rectangle(160, 0, 150, 50), "Next");
	auto b2 = new Button(Rectangle(320, 0, 150, 50), "Reset");
	auto b3 = new ToggleButton(Rectangle(0, 0, 150, 50), "Pause");
	auto n1 = new NumSelect(size, 10, Vector2(620, 0), 50);
	InitWindow(width * n1.Value, height * n1.Value + 120, "S a n d");
	
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
		
		DrawText(toStringz("Scrn:"), 480, 0, 50, Colors.WHITE);
		n1.draw();
		if(n1.Pressed){
			SetWindowSize(width * n1.Value, height * n1.Value + 120);
			size = n1.Value;
			e.resize(size);
		}
		
		if(IsKeyPressed(KeyboardKey.KEY_SPACE)) b3.toggle();
		
		// Generate code to handle clicks and drawing for buttons
		static foreach(i; 0 .. elements.elementNames.length){
			mixin("if(eButton" ~ to!string(i) ~ ".Pressed) e.Brush = elementNames[i];");
			mixin("eButton" ~ to!string(i) ~ ".draw();");
		}
		
		e.draw();
		b.draw();
		b2.draw();
		b3.draw();
		
		DrawText(toStringz(e.GetType), 760, 0, 25, Colors.WHITE);
		DrawText(toStringz(to!string(e.DotCount)), 760, 30, 25, Colors.WHITE);
		
		EndDrawing();
	}
	CloseWindow();
}
