module grid;

import elements;
import std.stdio;
import std.conv;
import raylib;

class elementGrid{
	// The 2D array of elements is static so that it can be accessed from all elements
	static element[][] grid;
	
	// The same goes for the width, height, and dot count
	static int width, height, dotCount;
	
	// Brush stuff
	private string brushType = "sand";
	private string brushTypeAlt = "air";
	int brushSize = 4;
	
	// Determines update order
	bool updateDir = false;
	
	@property void Brush(string s){ brushType = s; }
	@property void BrushAlt(string s){ brushTypeAlt = s; }
	
	this(){}
	
	this(int width, int height){
		this.width = width;
		this.height = height;
		
		grid = new element[][](width, height);
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y] = new air(x, y);
			}
		}
	}
	
	// Set all elements' hasUpdated value to false so they can be updated
	private void preUpdate(){
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y].hasUpdated = false;
			}
		}
	}
	
	// Set all elements in the grid to air
	void reset(){
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y] = new air(grid[x][y].x, grid[x][y].y);
			}
		}
	}
	
	string getType(int x, int y){
		if(x >= width || x < 0) return "";
		if(y >= height || y < 0) return "";
		return grid[x][y].type;
	}
	
	// Update a single dot
	void updateDot(ref int x, ref int y){
		if(grid[x][y].hasUpdated == false){
			grid[x][y] = grid[x][y].update();
		}
	}
	
	// Apply rules to every element on the grid. Updates twice every time it's called
	void updateGridFast(){
		if(updateDir){
			preUpdate();
			foreach(y; 0 .. height ){
				foreach(x; 0 .. width){
					updateDot(x, y);
				}
			}
			preUpdate();
			foreach_reverse(y; 0 .. height ){
				foreach_reverse(x; 0 .. width){
					updateDot(x, y);
				}
			}
		}
		else{
			preUpdate();
			foreach(y; 0 .. height ){
				foreach_reverse(x; 0 .. width){
					updateDot(x, y);
				}
			}
			preUpdate();
			foreach_reverse(y; 0 .. height ){
				foreach(x; 0 .. width){
					updateDot(x, y);
				}
			}
		}
		updateDir = !updateDir;
	}
	
	// Apply rules to every element on the grid
	void updateGrid(){
		preUpdate();
		if(updateDir){
			foreach(y; 0 .. height ){
				foreach(x; 0 .. width){
					updateDot(x, y);
				}
			}
		}
		else{
			foreach(y; 0 .. height ){
				foreach_reverse(x; 0 .. width){
					updateDot(x, y);
				}
			}
		}
		updateDir = !updateDir;
	}
	
	// Place selected element at specified coordinates
	void putElement(int x, int y, string brush){
		brushSwitch : switch(brush){
			static foreach(s; elementNames){
				case s: grid[x][y] = new mixin(s)(grid[x][y].x, grid[x][y].y); break brushSwitch;
			}
			default: break brushSwitch;
		}
	}
	
	// Place elements within the brush boundaries
	void doBrush(int x, int y){
		if(x >= width) return;
		int xBound = x - (brushSize / 2);
		int yBound = y - (brushSize / 2);
		
		foreach(Y; yBound .. yBound + brushSize){
			foreach(X; xBound .. xBound + brushSize){
				if(X >= 0 && X < width && Y >= 0 && Y < height)
					if(typeid(grid[X][Y]) == typeid(air) || brushType == "air") putElement(X, Y, brushType);
			}
		}
	}
	
	// Place elements within the brush boundaries using alt brush
	void doBrushAlt(int x, int y){
		if(x >= width) return;
		int xBound = x - (brushSize / 2);
		int yBound = y - (brushSize / 2);
		
		foreach(Y; yBound .. yBound + brushSize){
			foreach(X; xBound .. xBound + brushSize){
				if(X >= 0 && X < width && Y >= 0 && Y < height)
					if(typeid(grid[X][Y]) == typeid(air) || brushTypeAlt == "air") putElement(X, Y, brushTypeAlt);
			}
		}
	}
	
	// Draw the grid on a texture
	void drawGrid(){
		dotCount = 0;
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y].draw();
				if(typeid(grid[x][y]) != typeid(air)) dotCount++;
			}
		}
	}
}
