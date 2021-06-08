module menu.imgButton;

import std.string;
import std.functional;
import raylib;
import menu;

class imgButton : Button{
	// imgButton cannot be created using base Button constructor
	private this(Rectangle rec, string text){
		super(rec, text);
	}
	
	// This is our draw function. It's responsible for drawing the image on this button.
	// It will be passed into the constructor
	void function(Rectangle r, Color back, Color primary) drawFunc;
	
	// This constructor must be used, as we need a draw function for our image
	this(Rectangle rec, void function(Rectangle r, Color back, Color primary) drawFunc){
		this(rec, "");
		this.drawFunc = drawFunc;
	}
	
	// We re-use the backColor and textColor variables from Button
	override void draw(){
		if(Hovering) drawFunc(rec, backColor, textColor);
		else drawFunc(rec, textColor, backColor);
	}
}

// Similar to the imgButton, but inherits from ToggleButton instead
class imgToggleButton : ToggleButton{
	private this(Rectangle rec, string text){
		super(rec, text);
	}
	
	void function(Rectangle r, Color back, Color primary) drawFunc;
	
	this(Rectangle rec, void function(Rectangle r, Color back, Color primary) drawFunc){
		this(rec, "");
		this.drawFunc = drawFunc;
	}
	
	override void draw(){
		if(isDown) drawFunc(rec, backColor, textColor);
		else drawFunc(rec, textColor, backColor);
	}
}
