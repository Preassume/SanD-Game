module elements.fire;

import std.stdio;
import std.conv;
import std.random;
import raylib;
import elements;

class fire : element{
	
	@property override enum Color color() { return Colors.RED; }
	
	this(int x, int y){
		super(x, y);
		
		lifespan = uniform!"[]"(24, 72, rnd);
		
		density = 7;
	}
	
	bool canBurn(element* e){
		if(e == null) return false;
		
		// RNG so we're not guaranteed to burn every time
		int i;
		if(e != Dn) i = uniform!"[]"(0, 10, rnd);
		else i = uniform!"[]"(0, 2, rnd);
		if(i > 1) return false;
		
		if(typeid(*e) == typeid(wood)) return true;
		if(typeid(*e) == typeid(water)) return true;
		if(typeid(*e) == typeid(plant)) return true;
		return false;
	}
	
	element burn(element* e){
		if(e == null) return this;
		if(typeid(*e) == typeid(wood)) return burn!fire(e);
		if(typeid(*e) == typeid(water)) return burn!steam(e);
		if(typeid(*e) == typeid(plant)) return burn!fire(e);
		return this;
	}
	
	element burn(T)(element* e){
		if(!canBurn(e)) return this;
		
		*e = new T(e.x, e.y);
		e.hasUpdated = true;
		
		// If we boileded water, we get extinguished
		if(typeid(T) == typeid(steam)) return new smoke(x, y);
		
		return this;
	}
	
	override element update(){
		hasUpdated = true;
		
		// If we're burnt out, become smoke
		lifespan--;
		if(lifespan <= 0) return new smoke(x, y);
		
		// Burn where possible
		foreach(e; randomShuffle([Up, UpL, UpR])){
			if(canBurn(e)) return burn(e);
		}
		
		foreach(e; randomShuffle([L, R])){
			if(canBurn(e)) return burn(e);
		}
		
		foreach(e; randomShuffle([Dn, DnL, DnR])){
			if(canBurn(e)) return burn(e);
		}
		
		// Move where possible
		if(uniform!"[]"(0, 3) != 0){
			if(canMove(Up)) return move!fire(Up);
		}
		
		foreach(e; randomShuffle([UpL, UpR])){
			if(canMove(e)) return move!fire(e);
		}
		
		foreach(e; randomShuffle([L, R])){
			if(canMove(e)) return move!fire(e);
		}
		
		foreach(e; randomShuffle([Dn, DnL, DnR])){
			if(canMove(e)) return move!fire(e);
		}
		
		return this;
	}
}
