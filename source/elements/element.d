module elements.element;

import std.stdio;
import std.random;
import std.conv;
import raylib;

auto rnd = Random(1);

// An abstract base element class for further elements to inherit from
class element{
	bool hasUpdated = false;
	int density, lifespan;
	Color color; // Set these in subclasses so they will be visible
	Rectangle rec;
	typeof(typeid(element)) elementType;
	element*[3][3] neighbors;
	
	@property float x() { return rec.x; }
	@property void x(float newX) { rec.x = newX; }
	
	@property float y() { return rec.y; }
	@property void y(float newY) { rec.y = newY; }
	
	@property float size() { return rec.w; }
	@property void size(float newSize) { rec.w = rec.h = newSize; }
	
	this(float x, float y, float size){
		rec.x = x;
		rec.y = y;
		rec.w = rec.h = size;
		
		elementType = typeid(this);
	}
	
	this(float x, float y, float size, element*[3][3] neighbors){
		this(x, y, size);
		this.neighbors = neighbors;
	}
	
	// New elements must have an update method
	abstract element update();
	
	// Swap a specified element type (T) with one given (e)
	protected element swapElements(T)(ref element* e){
		if(typeid(T) == typeid(dummy)) return *e;
		
		element tmp = *e;
		tmp.lifespan = e.lifespan;
		
		*e = new T(e.x, e.y, e.size, e.neighbors);
		
		e.hasUpdated = true;
		e.lifespan = this.lifespan;
		
		tmp.x = this.x;
		tmp.y = this.y;
		tmp.size = this.size;
		return tmp;
	}
	
	// New elements can override draw, but it's not necessary.
	void draw(){
		DrawRectangleRec(rec, color);
	}
}

// A dummy element to be used for out-of-bounds cases
class dummy : element{
	this(float x, float y, float size){ super(x, y, size); }
	
	override element update(){
		density = 999999;
		hasUpdated = true;
		return this;
	}
	override void draw(){return;}
}
