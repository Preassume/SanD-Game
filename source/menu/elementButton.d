module menu.elementButton;

import std.string;
import raylib;
import menu;

// A special type of button used for selecting an element.
// Its color will be the same as the element it represents
class elementButton : Button{
	@property bool AltPressed() { return (IsMouseButtonPressed(MouseButton.MOUSE_RIGHT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	
	private this(Rectangle rec, string text){
		super(rec, text);
	}
	
	this(Rectangle rec, string text, Color backColor){
		this(rec, text);
		
		this.backColor = backColor;
		this.hoverColor = Color(255, 255, 255, 100);
		
		if(this.backColor.r <= 80 && this.backColor.g <= 80 && this.backColor.b <= 80) textColor = Colors.WHITE;
	}
	
	override void draw(){
		DrawRectangleRec(rec, backColor);
		if(this.Hovering) DrawRectangleRec(rec, hoverColor);
		
		auto txtPosX = rec.x + ((rec.w - (MeasureText(toStringz(text), cast(int)(textRec.h)))) / 2.0f);
		
		DrawText(toStringz(text), cast(int)(txtPosX), cast(int)(textRec.y), cast(int)(textRec.h), textColor);
	}
}
