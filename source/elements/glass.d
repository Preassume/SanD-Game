module elements.glass;

import std.stdio;
import std.random;
import raylib;
import elements;

// Almost identical to wood
class glass : element{
	
	@property override enum Color color() { return Colors.DARKGRAY; }
	
	this(int x, int y){
		super(x, y);
		
		density = 1000;
	}
	
	override element update(){
		hasUpdated = true;
		return this;
	}
}
