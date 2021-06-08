module elements.acid;

import std.stdio;
import std.conv;
import std.random;
import raylib;
import elements;

class acid : element{
	
	@property override enum Color color() { return Colors.YELLOW; }
	
	this(int x, int y){
		super(x, y);
		
		density = 30;
	}
	
	// Check if an element is the right type to be "eaten"
	bool canEat(element* e){
		if(e == null) return false;
		if(typeid(*e) == typeid(air)) return false;
		if(typeid(*e) == typeid(acid)) return false;
		if(typeid(*e) == typeid(glass)) return false;
		if(typeid(*e) == typeid(clone)) return false;
		return true;
	}
	
	// "Eat" a dot. Both that dot and this dot will become type T
	element eat(T)(element* e){
		if(!canEat(e)) return this;
		
		*e = new T(e.x, e.y);
		e.hasUpdated = true;
		
		return new T(x, y);
	}
	
	// Similar to water's update method, but also checks if it can "eat" neighboring elements
	override element update(){
		hasUpdated = true;
		
		if(canEat(Dn)) return eat!air(Dn);
		else if(canMove(Dn)) return move!acid(Dn);
		
		auto i = uniform!"[]"(0, 2, rnd);
		if(i == 1){
			if(canEat(DnL)) return eat!air(DnL);
			else if(canMove(DnL)) return move!acid(DnL);
			if(canEat(DnR)) return eat!air(DnR);
			else if(canMove(DnR)) return move!acid(DnR);
		}
		else if(i == 0){
			if(canEat(DnR)) return eat!air(DnR);
			else if(canMove(DnR)) return move!acid(DnR);
			if(canEat(DnL)) return eat!air(DnL);
			else if(canMove(DnL)) return move!acid(DnL);
		}
		
		if(i == 2) return this;
		
		if(i == 1){
			if(canEat(L)) return eat!air(L);
			else if(canMove(L)) return move!acid(L);
			if(canEat(R)) return eat!air(R);
			else if(canMove(R)) return move!acid(R);
		}
		else{
			if(canEat(R)) return eat!air(R);
			else if(canMove(R)) return move!acid(R);
			if(canEat(L)) return eat!air(L);
			else if(canMove(L)) return move!acid(L);
		}
		
		if(canEat(Up)) return eat!air(Up);
		
		return this;
	}
}
