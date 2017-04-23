local collector = table.deepcopy(data.raw['container']['wooden-chest'])
collector.name = "thelist-collector"
collector.inventory_size = 24
collector.max_health = 1000000
collector.minable = {mining_time = 3, result = "thelist-collector"}
collector.icon = "__TheList__/assets/collection-point-icon.png"
collector.picture = table.deepcopy(data.raw['logistic-container']['logistic-chest-passive-provider']['picture'])
collector.picture.filename = "__TheList__/assets/collection-point-sprite.png"

local item = table.deepcopy(data.raw['item']['wooden-chest'])
item.name = "thelist-collector"
item.icon = "__TheList__/assets/collection-point-icon.png"
item.stack_size = 10
item.place_result = "thelist-collector"
item.order = "a[items]-z[thelist-collector]"
item.stack_size = 10

local recipe = {
	type = "recipe",
	name = "thelist-collector",
	ingredients = {
		{"steel-chest", 1},
		{"electronic-circuit", 10},
		{"red-wire", 20},
		{"green-wire", 20},
	},
	result = "thelist-collector"
}

-- FIXME: find a way to only enable the entity/item/recipe when the user wants
-- to play The List
data:extend({collector})
data:extend({item})
data:extend({recipe})
