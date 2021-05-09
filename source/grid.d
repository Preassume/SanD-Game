module grid;

import elements;
import std.stdio;
import std.conv;
import raylib;

class elementGrid{
	private element[][] grid;
	private element dummyElement = new dummy(0, 0, 0);
	private int width, height, size, dotCount;
	private string brushType = "sand";
	Rectangle pos;
	int counter = 0;
	
	@property void Brush(string s){ brushType = s; }
	
	@property int MouseX(){ return cast(int)(GetMouseX / size); }
	@property int MouseY(){ return cast(int)((GetMouseY - pos.y) / size); }
	
	@property int DotCount(){ return dotCount; }
	
	@property string GetType(){
		if(!CheckCollisionPointRec(GetMousePosition(), pos)) return " ";
		else{
			string name = to!string(grid[MouseX][MouseY].elementType)[8 .. $];
			name = name[(name.length / 2) + 1 .. $];
			return name;
		}
	}
	
	this(Vector2 pos, int width, int height, int size){
		this.width = width;
		this.height = height;
		this.size = size;
		this.pos.x = pos.x;
		this.pos.y = pos.y;
		this.pos.w = (width * size) - 1;
		this.pos.h = (height * size) - 1;
		
		grid = new element[][](width, height);
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y] = new air(x * size + pos.x, y * size + pos.y, size);
			}
		}
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y].neighbors = getNeighbors(x, y);
			}
		}
	}
	
	// Resize the elements in the grid
	void resize(float size){
		this.size = cast(int)size;
		this.pos.w = (width * size) - 1;
		this.pos.h = (height * size) - 1;
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				grid[x][y].size = size;
				grid[x][y].x = x * size;
				grid[x][y].y = y * size + pos.y;
			}
		}
	}
	
	// Get pointers for the surrounding neighbors of an element
	element*[3][3] getNeighbors(int x, int y){
		element*[3][3] neighbors = null;
		
		foreach(j; 0 .. 3){
			foreach(i; 0 .. 3){
				if(x+(i-1) < 0 || x+(i-1) >= width || y+(j-1) < 0 || y+(j-1) >= height){
					neighbors[i][j] = &dummyElement;
				}
				else{
					neighbors[i][j] = &grid[x+(i-1)][y+(j-1)];
				}
			}
		}
		return neighbors;
	}
	
	// Return an array of pointers to neighboring elements
	private element*[] getNeighborsOld(int X, int Y){
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
				grid[x][y] = new air(grid[x][y].x, grid[x][y].y, grid[x][y].size, grid[x][y].neighbors);
			}
		}
	}
	
	// Apply rules to every element on the grid
	void update(){
		preUpdate();
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				if(grid[x][y].hasUpdated == false){
					element*[3][3] tmp = grid[x][y].neighbors;
					grid[x][y] = grid[x][y].update();
					grid[x][y].neighbors = tmp;
				}
			}
		}
	}
	
	// Place selected element at specified coordinates
	void putElement(int x, int y){
		brushSwitch : switch(brushType){
			static foreach(s; elementNames){
				case s: grid[x][y] = new mixin(s)(grid[x][y].x, grid[x][y].y, grid[x][y].size, grid[x][y].neighbors); break brushSwitch;
			}
			default: break brushSwitch;
		}
	}
	
	// Handle mouse clicks
	void checkMouse(){
		if(!IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON)) return;
		if(!CheckCollisionPointRec(GetMousePosition(), pos)) return;
				
		putElement(MouseX, MouseY);
	}
	
	// Draw the grid
	void draw(){
		dotCount = 0;
		checkMouse();
		foreach(y; 0 .. height){
			foreach(x; 0 .. width){
				if(grid[x][y].elementType == typeid(dummy)){ // Temporary "fix" for a bug
					grid[x][y] = new air(grid[x][y].x, grid[x][y].y, grid[x][y].size, grid[x][y].neighbors);
				}
				grid[x][y].draw();
				if(grid[x][y].elementType != typeid(air)) dotCount++;
			}
		}
	}
}
