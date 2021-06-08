module elements.plant;

import std.stdio;
import std.random;
import raylib;
import elements;

// Almost identical to wood and glass
class plant : element{
	
	@property override enum Color color() { return Colors.GREEN; }
	
	this(int x, int y){
		super(x, y);
		
		density = 1000;
	}
	
	override element update(){
		hasUpdated = true;
		return this;
	}
}
