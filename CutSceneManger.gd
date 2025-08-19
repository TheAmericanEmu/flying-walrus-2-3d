extends Node3D

@export var subtitles:Label

var lineSpot:int = 0
var lines:Array=["Sup","Sup"]

func nextLine():
	subtitles.text=lines[lineSpot]
		
	
	
	
