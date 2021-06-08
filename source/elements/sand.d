module elements.sand;

import std.stdio;
import std.random;
import raylib;
import elements;

class sand : element{
	
	@property override enum Color color() { return Colors.BEIGE; }
	
	this(int x, int y){
		super(x, y);
		
		density = 20;
	}
	
	// Simple falling sand rule
	override element update(){
		hasUpdated = true;
		
		if(canMove(Dn)) return move!sand(Dn);
		
		auto i = uniform!"[]"(0, 1, rnd);
		if(i == 1){
			if(canMove(DnL)) return move!sand(DnL);
			if(canMove(DnR)) return move!sand(DnR);
		}
		else{
			if(canMove(DnR)) return move!sand(DnR);
			if(canMove(DnL)) return move!sand(DnL);
		}
		
		return this;
	}
}
