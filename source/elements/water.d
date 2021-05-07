module elements.water;

import std.stdio;
import std.random;
import raylib;
import elements;

class water : sand{	
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.SKYBLUE;
		neutralColor = Colors.BLUE;
		
		density = 1;
	}
	
	// Get the two neighbors to either side of this element, but only if they're less dense
	element*[] getSideMoves(ref element*[] neighbors){
		element*[] checkArr = null;
		
		foreach(n; neighbors){
			if(n.x < this.x && n.y == this.y && n.density < this.density){
				checkArr ~= n;
			}
			if(n.x > this.x && n.y == this.y && n.density < this.density){
				checkArr ~= n;
			}
		}
		return checkArr;
	}
	
	// Basic falling water rule
	override element update(element*[] neighbors){
		hasUpdated = true;
		
		auto down = getDown(neighbors);
		if(down) return swapElements!water(down);
		
		auto checkArr = getMoves(neighbors);
		
		foreach(n; checkArr){
			return swapElements!water(checkArr[uniform!"[)"(0, checkArr.length, rnd)]);
		}
		
		checkArr = getSideMoves(neighbors);
		if(checkArr == null) return this;
		
		auto i = uniform!"[)"(0, checkArr.length, rnd);
		return swapElements!water(checkArr[i]);
	}
}


class wacky : sand{	
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.SKYBLUE;
		neutralColor = Colors.BLUE;
		
		density = 1;
	}
	
	// Get the two neighbors to either side of this element, but only if they're less dense
	element*[] getSideMoves(ref element*[] neighbors){
		element*[] checkArr = null;
		
		foreach(n; neighbors){
			if(n.x < this.x && n.y == this.y && n.density < this.density){
				checkArr ~= n;
			}
			if(n.x > this.x && n.y == this.y && n.density < this.density){
				checkArr ~= n;
			}
		}
		return checkArr;
	}
	
	override element update(element*[] neighbors){
		super.update(neighbors);
		
		element*[] checkArr = getSideMoves(neighbors);
		if(checkArr == null) return this;
		
		auto i = uniform!"[)"(0, checkArr.length, rnd);
		return swapElements!wacky(checkArr[i]);
	}
}
