# NodeOrganiser
 Godot Engine Plugin that can help user to organise nodes based on certain rules

 ![plugin form](/img/Ui.PNG)
 
 This plugin will help it's user to put subnodes of selected node into categories.
 Select desired node, write rules and press Organise it wil turn this:

 ![uncategorised nodes list](/img/Uncategorised%20List.PNG)
 
 to this:

 ![categorised nodes list](/img/Categorised%20List.PNG)
 
 I made this plugin for myself because i tired to order my cloth items inside of the character bu hands. Maybe it will be usefull for you as well, who knows.
 
 Rules presented in form of `category-subcategory|search1 & search2`
 Note1: it's important to have spaces in ` & `
 Note2: rule order matters so try to put rules with many conditions first
 Note3: rule search word case matters so Female and Male will work separately since female word has male in it
 Note4: you can tweak rule processing yourself. It's opensource. Rule processing algorithms can be found in `/Helpers/OrganiseRuleHelpers.gd` it's static function library. There is for example `is_rule_valid` and rule bubble sorter function.