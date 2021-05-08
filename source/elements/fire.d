module elements.fire;

import std.random;
import raylib;
import elements;

class fire : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.ORANGE;
		neutralColor = Colors.RED;
		
		density = -1;
		
		lifespan = uniform!"[]"(8, 16, rnd);
	}
	
	// Get neighbor directly above this element if possible
	element* getUp(ref element*[] neighbors){
		foreach(n; neighbors){
			if(n.x == this.x && n.y < this.y && n.density == 0) return n;
		}
		return null;
	}
	
	// Get neighbors diagonally upwards if possible
	element*[] getMovesUp(ref element*[] neighbors){
		element*[] checkArray = null;
		foreach(n; neighbors){
			if(n.x < this.x && n.y < this.y && n.density == 0) checkArray ~= n;
			if(n.x > this.x && n.y < this.y && n.density == 0) checkArray ~= n;
		}
		return checkArray;
	}
	
	// Get neighbors to the left or right if possible
	element*[] getMovesSide(ref element*[] neighbors){
		element*[] checkArray = null;
		foreach(n; neighbors){
			if(n.x < this.x && n.y == this.y && n.density == 0) checkArray ~= n;
			if(n.x > this.x && n.y == this.y && n.density == 0) checkArray ~= n;
		}
		return checkArray;
	}
	
	override element update(element*[] neighbors){
		hasUpdated = true;
		lifespan--;
		if(lifespan <= 0) return new air(this.x, this.y, this.size);
		
		auto up = getUp(neighbors);
		if(up) return swapElements!fire(up);
		
		auto tmp = getMovesUp(neighbors);
		if(tmp != null){
			return swapElements!fire(tmp[uniform!"[)"(0, tmp.length, rnd)]);
		}
		
		tmp = getMovesSide(neighbors);
		if(tmp){
			return swapElements!fire(tmp[uniform!"[)"(0, tmp.length, rnd)]);
		}
		return this;
	}
}
