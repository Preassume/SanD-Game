module elements.water;

import std.stdio;
import std.random;
import raylib;
import elements;

class water : element{
	
	@property override enum Color color() { return Colors.BLUE; }
	
	this(int x, int y){
		super(x, y);
		
		density = 10;
	}
	
	// Wetting is currently only used to grow plant
	bool canWet(element* e){
		if(e == null) return false;
		auto i = uniform!"[]"(0, 6, rnd);
		if(i != 0) return false;
		if(typeid(*e) == typeid(plant)) return true;
		return false;
	}
	
	element wet(element* e){
		if(e == null) return this;
		if(typeid(*e) == typeid(plant)) return wet!plant(e);
		return this;
	}
	
	element wet(T)(element* e){
		if(!canWet(e)) return this;
		
		*e = new T(e.x, e.y);
		e.hasUpdated = true;
		
		return new T(x, y);
	}
	
	// Similar to sand, but with additional left and right movement to emulate flowing
	override element update(){
		hasUpdated = true;
		
		auto wetDir = randomShuffle([Dn, DnR, DnL]);
		foreach(e; wetDir){
			if(canWet(e)) return wet(e);
		}
		
		if(canMove(Dn)) return move!water(Dn);
		
		auto i = uniform!"[]"(0, 2, rnd);
		if(i == 1){
			if(canMove(DnL)) return move!water(DnL);
			if(canMove(DnR)) return move!water(DnR);
		}
		else if(i == 0){
			if(canMove(DnR)) return move!water(DnR);
			if(canMove(DnL)) return move!water(DnL);
		}
		
		if(i == 2) return this;
		
		if(i == 1){
			if(canMove(L)) return move!water(L);
			if(canMove(R)) return move!water(R);
		}
		else{
			if(canMove(R)) return move!water(R);
			if(canMove(L)) return move!water(L);
		}
		
		return this;
	}
}
