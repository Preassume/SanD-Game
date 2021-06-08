module elements.air;

import std.stdio;
import std.random;
import raylib;
import elements;

class air : element{
	
	@property override enum Color color() { return Colors.BLACK; }
	
	this(int x, int y){
		super(x, y);
		
		density = 0;
	}
	
	// Bare minimum needed for an update method, as air does nothing
	override element update(){
		hasUpdated = true;
		return this;
	}
}
