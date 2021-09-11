
// Override the helper that determines if the player has Cyberdeck installed.
@replaceMethod(EquipmentSystem)
public final static func IsCyberdeckEquipped(owner: ref<GameObject>) -> Bool {
	return GameInstance.GetStatsSystem(owner.GetGame()).GetStatBoolValue(Cast(owner.GetEntityID()), gamedataStatType.HasCyberdeck);
}

// The helper that determines if the player has Sandevistan installed.
@addMethod(EquipmentSystem)
public final static func IsItemSandevistan(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Sandevistan");
}

// The helper that determines if the player has Berserk installed.
@addMethod(EquipmentSystem)
public final static func IsItemBerserk(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Berserk");
}

// The helper that determines if the player has ans Operating System installed.
@addMethod(EquipmentSystem)
public final static func IsItemOperatingSystem(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Sandevistan") || ArrayContains(itemTags, n"Berserk");
}
