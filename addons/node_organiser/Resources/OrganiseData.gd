extends Resource
tool
class_name OrganiseData

export (String, MULTILINE) var organise_rules:String setget set_org_rules
export var settings:Dictionary setget set_settings

func set_org_rules(value:String):
	organise_rules = value
	emit_changed()

func set_settings(value:Dictionary):
	settings = value
	emit_changed()
