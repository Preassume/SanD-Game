module elements.air;

import std.stdio;
import std.random;
import raylib;
import elements;

class air : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		color = Colors.BLACK;
		
		density = 0;
	}
	
	this(float x, float y, float size, element*[3][3] neighbors){
		this(x, y, size);
		this.neighbors = neighbors;
	}
	
	// Bare minimum needed for an update method, as air does nothing
	override element update(){
		hasUpdated = true;
		return this;
	}
}
