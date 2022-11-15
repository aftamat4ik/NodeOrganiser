class_name OrganiseRuleHelpers

const rule_checker_limiter := " & "
const rule_split_limiter := "|"
const rule_cats_limiter := "-"

# parse rule checkers array
static func get_rule_list_chekers(rule:String)->Array:
	var args = rule.split(rule_split_limiter)
	if range(args.size()).has(1):
		var checkers = args[1].split(rule_checker_limiter)
		return checkers
	return []

# parse rule for categories array
static func get_rule_list_cats(rule:String)->Array:
	var args = rule.split(rule_split_limiter)
	if range(args.size()).has(0):
		var checkers = args[0].split(rule_cats_limiter)
		return checkers
	return []

# check if this rule can be processed at all
static func can_process_rule(rule:String)->bool:
	var args = rule.split("|")
	if args.size() == 2:
		return true
	return false

# bubble sort rules list by rules count from small to big
static func sort_rules(rules:Array)->Array:
	for i in range(rules.size()-1, -1, -1):
		#print("i:", i)
		for j in range(1,i+1,1):
			#print("j:", j)
			var rule_a = rules[j-1]
			var rule_b = rules[j]
			if get_rule_list_chekers(rule_a).size() > get_rule_list_chekers(rule_b).size():
				var temp = rules[j-1]
				rules[j-1] = rules[j]
				rules[j] = temp
	return rules

# check if rule is valid
static func is_rule_valid(rule:String, for_node:Node)->bool:
	if not can_process_rule(rule):
		return false
	
	var checkers = get_rule_list_chekers(rule)
	
	for check in checkers:
		# if one of checks dosen't pass
		# (node name dosen't have sich word)
		if for_node.name.find(check) == -1:
			return false
	return true

	
