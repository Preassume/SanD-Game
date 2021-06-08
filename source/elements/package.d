module elements;
public import elements.element;

// To make add a new element, add its name to this array.
// NOTE: The name of the file and the name of the class MUST match what you add here
// The menu button and its click events will be auto-generated at compile-time
enum elementNames = [
	"air",
	"sand",
	"water",
	"wood",
	"acid",
	"glass",
	"fire",
	"steam",
	"plant",
	"wacky",
	"clone",
	"smoke",
];

// import all modules with names matching the elementNames contents
static foreach(e; elementNames){
	mixin("public import elements." ~ e ~ ';');
}
