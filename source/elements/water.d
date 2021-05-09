module elements.water;

import std.stdio;
import std.random;
import raylib;
import elements;

class water : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		color = Colors.BLUE;
		
		density = 1;
	}
	
	this(float x, float y, float size, element*[3][3] neighbors){
		this(x, y, size);
		this.neighbors = neighbors;
	}
	
	// Basic water rule
	override element update(){
		hasUpdated = true;
		
		if(neighbors[1][2].density < density) return swapElements!water(neighbors[1][2]);
		else if(neighbors[0][2].density < density && neighbors[2][2].density < density){
			auto i = (uniform!"[]"(0, 1, rnd)) * 2;
			return swapElements!water(neighbors[i][2]);
		} 
		else if(neighbors[0][2].density < density) return swapElements!water(neighbors[0][2]);
		else if(neighbors[2][2].density < density) return swapElements!water(neighbors[2][2]);
		else if(neighbors[0][1].density < density && neighbors[2][1].density < density){
			auto i = uniform!"[]"(0, 2, rnd);
			if(i == 1) return this;
			return swapElements!water(neighbors[i][1]);
		} 
		else if(neighbors[0][1].density < density){
			if(uniform!"[]"(0, 1, rnd) == 1) return this;
			return swapElements!water(neighbors[0][1]);
		}
		else if(neighbors[2][1].density < density){
			if(uniform!"[]"(0, 1, rnd) == 1) return this;
			return swapElements!water(neighbors[2][1]);
		}
		return this;
	}
}
