class_name Menu extends Control

@export var _default_focus_item: Control

var _breadcrumb: Menu

func open(breadcrumb: Menu = null):
	if breadcrumb:
		_breadcrumb = breadcrumb
		_breadcrumb.close()

	_default_focus_item.grab_focus()
	show()

func close():
	hide()
	if _breadcrumb:
		_breadcrumb.open()
