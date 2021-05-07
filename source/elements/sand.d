module elements.sand;

import std.stdio;
import std.random;
import raylib;
import elements;

class sand : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.WHITE;
		neutralColor = Colors.LIGHTGRAY;
		
		density = 2;
	}
	
	// Get the neighbor immediately below this element
	element* getDown(ref element*[] neighbors){
		foreach(n; neighbors){
			if(n.x == this.x && n.y > this.y && n.density < this.density) return n;
		}
		return null;
	}
	
	// Get the neighbors which are below this element (have a greater y value)
	element*[] getMoves(ref element*[] neighbors){
		element*[] checkArr = null;
		
		foreach(n; neighbors){
			if(n.x < this.x && n.y > this.y && n.density < this.density){
				checkArr ~= n;
			}
			else if(n.x > this.x && n.y > this.y && n.density < this.density){
				checkArr ~= n;
			}
		}
		return checkArr;
	}
	
	// Basic falling sand rule
	override element update(element*[] neighbors){
		hasUpdated = true;
		
		auto down = getDown(neighbors);
		if(down) return swapElements!sand(down);
		
		auto checkArr = getMoves(neighbors);
		
		foreach(n; checkArr){
			return swapElements!sand(checkArr[uniform!"[)"(0, checkArr.length, rnd)]);
		}
		return this;
	}
}
