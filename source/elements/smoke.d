module elements.smoke;

import std.stdio;
import std.conv;
import std.random;
import raylib;
import elements;

class smoke : element{
	
	@property override enum Color color() { return Color(50, 50, 50, 255); }
	
	this(int x, int y){
		super(x, y);
		
		lifespan = uniform!"[]"(8, 64, rnd);
		if(uniform!"[]"(0, 4, rnd) == 0) lifespan *= 3;
		
		density = 8;
	}
	
	// Movement similar to fire, but doesn't burn anything
	override element update(){
		hasUpdated = true;
		lifespan--;
		if(lifespan <= 0) return new air(x, y);
		
		foreach(e; randomShuffle([Up, UpL, UpR])){
			if(canMove(e)) return move!smoke(e);
		}
		
		foreach(e; randomShuffle([L, R])){
			if(canMove(e)) return move!smoke(e);
		}
		
		foreach(e; randomShuffle([Dn, DnL, DnR])){
			if(canMove(e)) return move!smoke(e);
		}
		
		return this;
	}
}
