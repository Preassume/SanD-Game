module elements.wood;

import std.stdio;
import std.random;
import raylib;
import elements;

class wood : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		color = Colors.GOLD;
		
		density = 10;
	}
	
	this(float x, float y, float size, element*[3][3] neighbors){
		this(x, y, size);
		this.neighbors = neighbors;
	}
	
	// Does basically nothing
	override element update(){
		hasUpdated = true;
		return this;
	}
}
