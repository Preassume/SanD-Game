module elements.wood;

import std.random;
import raylib;
import elements;

class wood : element{
	this(float x, float y, float size){
		super(x, y, size);
		
		hoverColor = Colors.YELLOW;
		neutralColor = Colors.GOLD;
		
		density = 1000;
	}
	
	int checkFire(ref element*[] neighbors){
		auto count = 0;
		foreach(n; neighbors){
			if(n.elementType == typeid(fire)) count++;
		}
		return count;
	}
	
	override element update(element*[] neighbors){
		hasUpdated = true;
		int fireNeighbors = checkFire(neighbors);
		if(fireNeighbors > 0){
			auto i = uniform!"[]"(1, 8, rnd);
			if(i < fireNeighbors){
				return new fire(this.x, this.y, this.size);
			}
		}
		return this;
	}
}
