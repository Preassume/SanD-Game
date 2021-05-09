module elements.sand;

import std.stdio;
import std.random;
import raylib;
import elements;

class sand : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		color = Colors.BEIGE;
		
		density = 2;
	}
	
	this(float x, float y, float size, element*[3][3] neighbors){
		this(x, y, size);
		this.neighbors = neighbors;
	}
	
	// Basic falling sand rule
	override element update(){
		hasUpdated = true;
		
		if(neighbors[1][2].density < density) return swapElements!sand(neighbors[1][2]);
		else if(neighbors[0][2].density < density && neighbors[2][2].density < density){
			auto i = (uniform!"[]"(0, 1, rnd)) * 2;
			return swapElements!sand(neighbors[i][2]);
		} 
		else if(neighbors[0][2].density < density) return swapElements!sand(neighbors[0][2]);
		else if(neighbors[2][2].density < density) return swapElements!sand(neighbors[2][2]);
		else return this;
	}
}
