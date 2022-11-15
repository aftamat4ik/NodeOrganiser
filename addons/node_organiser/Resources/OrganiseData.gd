extends Resource
tool
class_name OrganiseData

export (String, MULTILINE) var organise_rules:String setget set_org_rules

func set_org_rules(value:String):
	organise_rules = value
	emit_changed()
