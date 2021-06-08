module elements.wood;

import std.stdio;
import std.random;
import raylib;
import elements;

// Does not move or do anything, it's just heavy.
class wood : element{
	
	@property override enum Color color() { return Colors.GOLD; }
	
	this(int x, int y){
		super(x, y);
		
		density = 1000;
	}
	
	override element update(){
		hasUpdated = true;
		
		return this;
	}
}
