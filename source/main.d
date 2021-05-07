import std.stdio;
import std.conv;
import std.string;
import raylib;
import menu.button;
import grid;

void main(){
	SetTargetFPS(60);
	InitWindow(1280, 720, "L i f e");
	
	auto width = 160;
	auto height = 75;
	
	elementGrid e = new elementGrid(Vector2(0, 120), width, height, 8);
	
	auto b = new Button(Rectangle(160, 0, 150, 50), "Next");
	auto b2 = new Button(Rectangle(320, 0, 150, 50), "Reset");
	auto b3 = new ToggleButton(Rectangle(0, 0, 150, 50), "Pause");
	auto b4 = new Button(Rectangle(0, 70, 150, 50), "Air");
	auto b5 = new Button(Rectangle(160, 70, 150, 50), "Sand");
	auto b6 = new Button(Rectangle(320, 70, 150, 50), "Water");
	auto b7 = new Button(Rectangle(480, 70, 150, 50), "Wacky");
	auto b8 = new Button(Rectangle(640, 70, 150, 50), "Wood");
	auto b9 = new Button(Rectangle(800, 70, 150, 50), "Fire");
	
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
		
		if(b4.Pressed) e.brush = "air";
		if(b5.Pressed) e.brush = "sand";
		if(b6.Pressed) e.brush = "water";
		if(b7.Pressed) e.brush = "wacky";
		if(b8.Pressed) e.brush = "wood";
		if(b9.Pressed) e.brush = "fire";
		
		e.draw();
		b.draw();
		b2.draw();
		b3.draw();
		b4.draw();
		b5.draw();
		b6.draw();
		b7.draw();
		b8.draw();
		b9.draw();
		
		EndDrawing();
	}
	CloseWindow();
}
