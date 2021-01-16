extends Resource
class_name ShopItem

enum ItemType {
	MINER,
}

export(ItemType) var item_type
export(Texture) var item_texture
export(String) var item_name
export(String) var item_description
export(int) var item_cost
export(PackedScene) var tutorial_scene_path
