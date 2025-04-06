class_name Menu extends Control

@export var _default_focus_item: Control

var _breadcrumb: Menu
# Used if this menu is only closed to open another one in it's place.
# We don't want to process input on the hidden menu.
var is_active: bool

func open(breadcrumb: Menu = null):
	is_active = true
	if breadcrumb:
		_breadcrumb = breadcrumb
		_breadcrumb.close()

	_default_focus_item.grab_focus()
	show()

func close():
	is_active = false
	hide()
	if _breadcrumb:
		_breadcrumb.open()
