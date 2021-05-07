module elements.element;

import std.stdio;
import std.random;
import raylib;

auto rnd = Random(1);

// An abstract base element class for further elements to inherit from
class element{
	bool hasUpdated = false;
	int density, lifespan;
	Color hoverColor, neutralColor; // Set these in subclasses so they will be visible
	Rectangle rec;
	typeof(typeid(element)) elementType;
	
	@property float x() { return rec.x; }
	@property void x(float newX) { rec.x = newX; }
	
	@property float y() { return rec.y; }
	@property void y(float newY) { rec.y = newY; }
	
	@property float size() { return rec.w; }
	@property void size(float newSize) { rec.w = rec.h = newSize; }
	
	@property bool Pressed() { return (IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	@property bool Hovering() { return (IsMouseButtonUp(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	
	this(float x, float y, float size){
		rec.x = x;
		rec.y = y;
		rec.w = rec.h = size;
		
		elementType = typeid(this);
	}
	
	// New elements must have an update method
	abstract element update(element*[] neighbors);
	
	// Swap a specified element type (T) with one given (e)
	protected element swapElements(T)(element* e){
		element tmp = *e;
		tmp.lifespan = e.lifespan;
		
		*e = new T(e.x, e.y, e.size);
		e.hasUpdated = true;
		e.lifespan = this.lifespan;
		
		tmp.x = this.x;
		tmp.y = this.y;
		tmp.size = this.size;
		return tmp;
	}
	
	// New elements can override draw, but it's not necessary.
	void draw(){
		if(Hovering) DrawRectangleRec(rec, hoverColor);
		else DrawRectangleRec(rec, neutralColor);
	}
}
