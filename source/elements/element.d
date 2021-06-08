module elements.element;

import grid;
import std.stdio;
import std.random;
import std.array;
import std.conv;
import raylib;

auto rnd = Random(1);

// An abstract base element class for further elements to inherit from
// This class contains much of the methods required to easily implement new elements
class element : elementGrid{
	bool hasUpdated = false;
	
	// Set these in the constructors of child classes
	int density;
	
	// These can be set with constructor parameters
	int x, y, lifespan;
	
	@property string type(){return split(to!string(this), ".")[2];}
	
	// New elements must set their color
	@property abstract enum Color color();
	
	
	// These properties are handy ways to interact with your neighbors
	@property element* Up(){
		if(y-1 >= 0) return &grid[x][y-1];
		else return null;
	}
	@property element* Dn(){
		if(y+1 < height) return &grid[x][y+1];
		else return null;
	}
	@property element* L(){
		if(x-1 >= 0) return &grid[x-1][y];
		else return null;
	}
	@property element* R(){
		if(x+1 < width) return &grid[x+1][y];
		else return null;
	}
	@property element* UpL(){
		if(y-1 >= 0 && x-1 >= 0) return &grid[x-1][y-1];
		else return null;
	}
	@property element* DnL(){
		if(y+1 < height && x-1 >= 0) return &grid[x-1][y+1];
		else return null;
	}
	@property element* UpR(){
		if(y-1 >= 0 && x+1 < width) return &grid[x+1][y-1];
		else return null;
	}
	@property element* DnR(){
		if(y+1 < height && x+1 < width) return &grid[x+1][y+1];
		else return null;
	}
	
	this(){}
	
	this(int x, int y){
		this.x = x;
		this.y = y;
	}
	
	// Check if movement is possible with a specified element
	bool canMove(element* e){
		if(e == null) return false;
		if(e.density >= density) return false;
		return true;
	}
	
	// Move an element to your position, placing an element of type T in its place
	element move(T)(element* e){
		if(!canMove(e)) return this;
		
		element tmp = *e;
		tmp.lifespan = e.lifespan;
		
		*e = new T(e.x, e.y);
		e.hasUpdated = true;
		e.lifespan = this.lifespan;
		
		tmp.x = this.x;
		tmp.y = this.y;
		return tmp;
	}
	
	void draw(){
		DrawPixel(x, y, color);
	}
	
	// New elements must have an update method
	abstract element update();
}
