module elements.air;

import std.stdio;
import raylib;
import elements;

class air : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.DARKGRAY;
		neutralColor = Colors.BLACK;
		
		density = 0;
	}
	
	// Bare minimum needed for an update method, as air does nothing
	override element update(element*[] neighbors){
		hasUpdated = true;
		return this;
	}
}
