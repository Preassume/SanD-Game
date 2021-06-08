module menu.button;

import std.string;
import raylib;

class Button{
	float textSize = 0.8;
	string text;
	Rectangle rec, textRec;
	Color backColor, pressColor, hoverColor, textColor;
	
	// Dimensions/location getters
	@property Rectangle Rec() { return rec; }
	@property float x() { return rec.x; }
	@property float y() { return rec.y; }
	@property float w() { return rec.w; }
	@property float h() { return rec.h; }
	
	// Dimensions/location setters
	@property void Rec(Rectangle r){
		rec = r;
		
		textRec.w = rec.w * textSize;
		textRec.h = rec.h * textSize;
		
		textRec.x = rec.x + (rec.w - textRec.w) / 2;
		textRec.y = rec.y + (rec.h - textRec.h) / 2;
	}
	@property void x(float f) { rec.x = f; }
	@property void y(float f) { rec.y = f; }
	@property void w(float f) { rec.w = f; }
	@property void h(float f) { rec.h = f; }
	
	// Mouse detection stuff
	@property bool Pressed() { return (IsMouseButtonPressed(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	@property bool Down() { return (IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	@property bool Released() { return (IsMouseButtonReleased(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	@property bool Hovering() { return (IsMouseButtonUp(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec)); }
	
	this(Rectangle rec, string text){
		this.rec = rec;
		this.text = text;
		
		backColor = Colors.WHITE;
		pressColor = Colors.YELLOW;
		hoverColor = Colors.BLUE;
		textColor = Colors.BLACK;
		
		textRec.w = rec.w * textSize;
		textRec.h = rec.h * textSize;
		
		textRec.x = rec.x + (rec.w - textRec.w) / 2;
		textRec.y = rec.y + (rec.h - textRec.h) / 2;
	}
	
	void draw(){
		if(this.Down) DrawRectangleRec(rec, pressColor);
		else if(this.Hovering) DrawRectangleRec(rec, hoverColor);
		else DrawRectangleRec(rec, backColor);
		
		auto txtPosX = rec.x + ((rec.w - (MeasureText(toStringz(text), cast(int)(textRec.h)))) / 2.0f);
		
		DrawText(toStringz(text), cast(int)(txtPosX), cast(int)(textRec.y), cast(int)(textRec.h), textColor);
	}
}

class ToggleButton : Button{
	bool isDown = false;
	
	@property override bool Pressed(){
		if(IsMouseButtonPressed(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec))
			toggle();
		return isDown;
	}
	
	@property override bool Released(){
		auto b = IsMouseButtonReleased(MouseButton.MOUSE_LEFT_BUTTON) && CheckCollisionPointRec(GetMousePosition(), rec);
		if(b) toggle();
		return b;
	}
	
	this(Rectangle rec, string text){
		super(rec, text);
	}
	
	void toggle(){
		isDown = !isDown;
	}
	
	override void draw(){
		if(this.Down) DrawRectangleRec(rec, pressColor);
		else if(this.Hovering) DrawRectangleRec(rec, hoverColor);
		else if(isDown) DrawRectangleRec(rec, pressColor);
		else DrawRectangleRec(rec, backColor);
		
		auto txtPosX = rec.x + ((rec.w - (MeasureText(toStringz(text), cast(int)(textRec.h)))) / 2.0f);
		
		DrawText(toStringz(text), cast(int)(txtPosX), cast(int)(textRec.y), cast(int)(textRec.h), textColor);
	}
}
