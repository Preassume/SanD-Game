module elements.clone;

import std.stdio;
import std.random;
import raylib;
import elements;

class clone : element{
	string cloneType;
	
	element*[] neighbors;
	
	@property override enum Color color() { return Colors.ORANGE; }
	
	this(int x, int y){
		super(x, y);
		cloneType = "";
		density = 1000;
		
		// Add neighbors that exist to our array
		if(Up != null) neighbors ~= Up;
		if(Dn != null) neighbors ~= Dn;
		if(L != null) neighbors ~= L;
		if(R != null) neighbors ~= R;
		if(UpL != null) neighbors ~= UpL;
		if(DnL != null) neighbors ~= DnL;
		if(UpR != null) neighbors ~= UpR;
		if(DnR != null) neighbors ~= DnR;
	}
	
	// Check for non-air neighbors
	string checkForType(){
		foreach(e; neighbors){
			if(typeid(*e) != typeid(air) && typeid(*e) != typeid(clone)){
				return e.type;
			}
		}
		return "";
	}
	
	// Pick a random neighbor to clone into
	void cloneElement(element* e){
		if(e == null) return;
		
		if(typeid(*e) != typeid(air)) return;
		
		cloneSwitch : switch(cloneType){
			static foreach(s; elementNames){
				case s: *e = new mixin(s)(e.x, e.y); break cloneSwitch;
			}
			default: break cloneSwitch;
		}
	}
	
	// Check for non-air neighbors until one is found
	// Then, clone that element endlessly
	override element update(){
		hasUpdated = true;
		if(cloneType == "") cloneType = checkForType;
		else{
			cloneElement(randomShuffle(neighbors)[0]);
		}
		return this;
	}
}
