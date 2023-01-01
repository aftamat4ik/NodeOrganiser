tool
extends VBoxContainer

signal organise(rules, diblicate, uniq_name)

onready var btn_organise:Button = get_node("%Btn_Organise")
onready var txt_org_rules:TextEdit = get_node("%Txt_OrganiseRules")
onready var cb_duplicate:CheckBox = get_node("%CB_Duplicate")
onready var cb_uniqname:CheckBox = get_node("%CB_UniqName")

const data_resource_path = "res://addons/node_organiser/Resources/OrganiseData.tres"

func _ready():
	if Engine.is_editor_hint():
		btn_organise.connect("pressed", self, "on_organise_pressed")
		
		reset_rules()
		var res = ResourceLoader.load(data_resource_path)
		
		cb_duplicate.pressed = res.settings["is_duplicate"]
		cb_uniqname.pressed = res.settings["is_uniqname"]

# emit signal on organise pressed
func on_organise_pressed():
	emit_signal("organise",txt_org_rules.text, cb_duplicate.is_pressed(), cb_uniqname.is_pressed())

# returns current rules
func get_rules()->String:
	var text = txt_org_rules.text
	return text

# sets current rules
func set_rules(rules:String):
	txt_org_rules.text = rules

# resets rules to default value
func reset_rules():
	var res = ResourceLoader.load(data_resource_path)
		
	if res.organise_rules.length() > 0:
		txt_org_rules.text = res.organise_rules

# returns ui state
func get_settings()->Dictionary:
	return {
		"is_duplicate":cb_duplicate.is_pressed(),
		"is_uniqname":cb_uniqname.is_pressed()
	}
