class_name Item extends StaticBody2D

enum Size {Small, Medium, Large}

@export var is_dud: bool = false
@export var metallic_score: float = 60
@export var value: int = 5 
@export var item_name: String = "Gold"
@export var size: Size = Size.Small