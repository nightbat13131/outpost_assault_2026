class_name CoinTextures extends Resource

static var icon_resources : Array[CoinTextures] = []
static var icon_dependent : CoinTextures
static var icon_info : CoinTextures


@export var purchase_type := CostButton.PurchaseTypes.UPGRADE
@export var can_afford := false
@export var missing_dependency := false
@export var texture: Texture2D 

func _get_texture() -> Texture2D: return texture

static func get_coin_texture(purchase_type: CostButton.PurchaseTypes, can_afford : bool, dependency_missing:= false) -> Texture2D:
	if icon_resources.is_empty():
		_populate_icons()
	if dependency_missing:
		return icon_dependent._get_texture()
	if purchase_type == CostButton.PurchaseTypes.INFORMATION:
		return icon_info._get_texture()
	for each_icon in icon_resources:
		if each_icon.purchase_type == purchase_type and each_icon.can_afford == can_afford:
			return each_icon._get_texture() 
	return icon_info._get_texture()

static func _populate_icons() -> void:
	var holder : CoinTextures
	for each in [
		"uid://bw1ht4sb7fyw8",
		"uid://dofloqwn5dtne",
		"uid://o7xxbnh2p0j8",
		"uid://db08k5mfuhcoj",
		"uid://eh0vp78f8phr",
		"uid://dk4u2o7c41laf"]:
			holder = load(each)
			if holder.purchase_type == CostButton.PurchaseTypes.INFORMATION:
				icon_info = holder
			elif holder.missing_dependency:
				icon_dependent = holder
			else:
				icon_resources.append(holder)
