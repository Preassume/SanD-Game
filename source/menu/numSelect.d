module menu.numSelect;

import menu;
import std.string;
import std.conv;
import raylib;

class NumSelect{
	Button plus, minus;
	private int num, min, max;
	float size;
	Vector2 pos;
	Rectangle rec;
	
	@property int Value(){ return num; }
	@property bool Pressed() { return (IsMouseButtonPressed(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	
	this(int min, int max, Vector2 pos, float size){
		plus = new Button(Rectangle(pos.x, pos.y, size / 3, size / 2), "+");
		minus = new Button(Rectangle(pos.x, pos.y + size / 2, size / 3, size / 2), "-");
		rec = Rectangle(pos.x, pos.y, plus.w, plus.h + minus.h);
		
		num = min;
		this.min = min;
		this.max = max;
		this.size = size;
		this.pos = pos;
	}
	
	void increment(){
		if(num >= max) num = max;
		else num++;
	}
	
	void decrement(){
		if(num <= min) num = min;
		else num--;
	}
	
	void draw(){
		if(plus.Pressed) increment();
		if(minus.Pressed) decrement();
		
		plus.draw();
		minus.draw();
		DrawText(toStringz(to!string(num)), cast(int)(pos.x + size / 1.8), cast(int)(pos.y + size / 12), cast(int)(size * 0.8), Colors.WHITE);
	}
}
