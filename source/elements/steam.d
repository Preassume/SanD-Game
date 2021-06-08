module elements.steam;

import std.stdio;
import std.random;
import raylib;
import elements;

class steam : element{
	
	@property override enum Color color() { return Colors.SKYBLUE; }
	
	this(int x, int y){
		super(x, y);
		
		lifespan = uniform!"[]"(500, 1200, rnd);
		
		density = 9;
	}
	
	// Moves quite randomly. Becomes water after a while
	override element update(){
		hasUpdated = true;
		lifespan--;
		if(lifespan < 1) return new water(x, y);
		
		// Extra upwards directions so that we tend to rise
		auto dirs = [Up, Dn, L, R, UpR, UpL, DnR, DnL, Up, UpR, UpL];
		dirs = randomShuffle(dirs);
		
		foreach(e; dirs){
			if(canMove(e)) return move!steam(e);
		}
		
		return this;
	}
}
