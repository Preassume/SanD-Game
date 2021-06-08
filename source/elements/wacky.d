module elements.wacky;

import std.stdio;
import std.random;
import raylib;
import elements;

class wacky : element{
	
	@property override enum Color color() { return Colors.DARKBLUE; }
	
	this(int x, int y){
		super(x, y);
		
		density = 10;
	}
	
	// Pretty closely approximates the behavior of Wacky from version 1.0
	override element update(){
		hasUpdated = true;
		
		if(canMove(Dn)){
			move!sand(Dn);
			return this;
		}
		
		foreach(e; randomShuffle([L, R])){
			if(canMove(e)) return move!wacky(e);
		}
		
		return this;
	}
}
