module grid;

import elements;
import std.stdio;
import raylib;

class elementGrid{
	private element[][] grid;
	private int width, height;
	private string brushType = "sand";
	Vector2 pos;
	int counter = 0;
	
	@property void brush(string s){ brushType = s; }
	
	this(Vector2 pos, int width, int height, int size){
		this.width = width;
		this.height = height;
		this.pos = pos;
		
		grid = new element[][](width, height);
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y] = new air(x * size + pos.x, y * size + pos.y, size);
			}
		}
	}
	
	// Resize the elements in the grid
	void resize(float size){
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y].size = size;
			}
		}
	}
	
	// Return an array of pointers to neighboring elements
	private element*[] getNeighbors(int X, int Y){
		element*[] neighbors;
		foreach(y; -1 .. 2){
			foreach(x; -1 .. 2){
				if(!(x == 0 && y == 0)){
					if(X+x >= 0 && X+x <= width-1 && Y+y >= 0 && Y+y <= height-1){
						neighbors ~= &grid[X+x][Y+y];
					}
				}
			}
		}
		return neighbors;
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
				grid[x][y] = new air(grid[x][y].x, grid[x][y].y, grid[x][y].size);
			}
		}
	}
	
	// Apply rules to every element on the grid
	void update(){
		preUpdate();
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				if(grid[x][y].hasUpdated == false)
					grid[x][y] = grid[x][y].update(getNeighbors(x, y));
			}
		}
	}
	
	// Place selected element at specified coordinates
	void putElement(ref int x, ref int y){
		brushSwitch : switch(brushType){
			static foreach(s; elementNames){
				case s: grid[x][y] = new mixin(s)(grid[x][y].x, grid[x][y].y, grid[x][y].size); break brushSwitch;
			}
			default: break brushSwitch;
		}
	}
	
	// Check if the mouse is being clicked at given coordinates
	void checkMouse(ref int x, ref int y){
		if(grid[x][y].Pressed){
			putElement(x, y);
		}
	}
	
	// Draw the grid
	void draw(){
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				checkMouse(x, y);
				grid[x][y].draw();
			}
		}
	}
}
