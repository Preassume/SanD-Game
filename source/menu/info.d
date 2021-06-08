module menu.info;

import std.string;
import std.conv;
import raylib;

class Info{
	string coords, dots, type;
	int x, y, size;
	
	// An integer can be provided for our dots variable
	@property string Dots(int d){ return dots = to!string(d); }
	
	this(int x, int y, int size){
		this.x = x;
		this.y = y;
		this.size = size;
		
		coords = dots = type = "empty";
	}
	
	void resize(int x, int y, int size){
		this.x = x;
		this.y = y;
		this.size = size;
	}
	
	// Provided coordinates are converted to a string
	void setCoords(int x, int y){
		coords = to!string(x) ~ ", " ~ to!string(y);
	}
	
	// Draw the text. Text will be centered
	void draw(){
		DrawText(toStringz(coords), x - MeasureText(toStringz(coords), size) / 2, y, size, Colors.WHITE);
		
		DrawText(toStringz(type), x - MeasureText(toStringz(type), size) / 2, y + size, size, Colors.WHITE);
		DrawText(toStringz(dots), x - MeasureText(toStringz(dots), size) / 2, y + size * 2, size, Colors.WHITE);
	}
}

