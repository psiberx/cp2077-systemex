
// Override the helper that determines if the player has Cyberdeck installed.
@replaceMethod(EquipmentSystem)
public final static func IsCyberdeckEquipped(owner: ref<GameObject>) -> Bool {
	return GameInstance.GetStatsSystem(owner.GetGame()).GetStatBoolValue(Cast(owner.GetEntityID()), gamedataStatType.HasCyberdeck);
}

// Determine if a given item is Sandevistan.
@addMethod(EquipmentSystem)
public final static func IsItemSandevistan(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Sandevistan");
}

// Determine if a given item is Berserk.
@addMethod(EquipmentSystem)
public final static func IsItemBerserk(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Berserk");
}

// Determine if a given item is an Operating System.
@addMethod(EquipmentSystem)
public final static func IsItemOperatingSystem(itemID: ItemID) -> Bool {
	let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(itemID);
	let itemTags: array<CName> = itemRecord.Tags();
	return ArrayContains(itemTags, n"Sandevistan") || ArrayContains(itemTags, n"Berserk");
}
