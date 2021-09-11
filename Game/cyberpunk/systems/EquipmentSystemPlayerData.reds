import SystemEx.*

// Override the initialization of equipment data for a new game to add extra system replacement slots.
@wrapMethod(EquipmentSystemPlayerData)
private final func InitializeEquipment() -> Void {
	wrappedMethod();

	this.OverloadSystemReplacementCW();
}

// Override the initialization of the equipment data loaded from the save file to add extra system replacement slots.
@wrapMethod(EquipmentSystemPlayerData)
public final func OnRestored() -> Void {
	this.OverloadSystemReplacementCW();

	wrappedMethod();
}

// Add extra system replacement slots.
@addMethod(EquipmentSystemPlayerData)
private func OverloadSystemReplacementCW() -> Void {
	let systemAreaIndex: Int32 = this.GetEquipAreaIndex(gamedataEquipmentArea.SystemReplacementCW);

	if ArraySize(this.m_equipment.equipAreas[systemAreaIndex].equipSlots) < 1 {
		return;
	}

	let systemNumSlots: Int32 = SystemEx.NumberOfSlots();
	let emptyEquipSlot: SEquipSlot;

	while ArraySize(this.m_equipment.equipAreas[systemAreaIndex].equipSlots) < systemNumSlots {
		ArrayPush(this.m_equipment.equipAreas[systemAreaIndex].equipSlots, emptyEquipSlot);
	}
}

// Override how the active item is resolved for the system replacement slot so that
// it returns a Cyberdeck installed in any slot.
// Originally the game always returns the cyberware installed in the first slot.
@replaceMethod(EquipmentSystemPlayerData)
public final const func GetActiveItem(equipArea: gamedataEquipmentArea) -> ItemID {
	if Equals(equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		return this.GetActiveItem(equipArea, n"Cyberdeck");
	}

	return this.GetActiveItemID(this.GetEquipAreaIndex(equipArea));
}

// Get the active item that has the specified tag.
@addMethod(EquipmentSystemPlayerData)
public func GetActiveItem(equipArea: gamedataEquipmentArea, requiredTag: CName) -> ItemID {
	let requiredTags: array<CName>;
	ArrayPush(requiredTags, requiredTag);

	return this.GetActiveItem(equipArea, requiredTags);
}

// Get the active item that has specified tags.
@addMethod(EquipmentSystemPlayerData)
public func GetActiveItem(equipArea: gamedataEquipmentArea, requiredTags: array<CName>) -> ItemID {
	let equipAreaIndex: Int32 = this.GetEquipAreaIndex(equipArea);
    let numSlots: Int32 = ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots);
    let slotIndex: Int32 = 0;

	while slotIndex < numSlots {
		let itemID: ItemID = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;

		if ItemID.IsValid(itemID) && this.CheckTagsInItem(itemID, requiredTags) {
			return this.GetItemInEquipSlot(equipAreaIndex, slotIndex);
		}
		
		slotIndex += 1;
	}

	let noneItemID: ItemID;
	return noneItemID;
}

// Override equip method to unequip conflicting items from all slots with extended rules.
@wrapMethod(EquipmentSystemPlayerData)
private final func EquipItem(itemID: ItemID, slotIndex: Int32, opt addToInventory: Bool, opt blockActiveSlotsUpdate: Bool, opt forceEquipWeapon: Bool) -> Void {
	this.UnequipConflictingItems(itemID);

	wrappedMethod(itemID, slotIndex, addToInventory, blockActiveSlotsUpdate, forceEquipWeapon);
}

// Unequip conflicting items with extended rules.
// Sandevistan and Berserk are considered to be conflicting items.
@addMethod(EquipmentSystemPlayerData)
private func UnequipConflictingItems(itemID: ItemID) -> Void {
	let equipArea: gamedataEquipmentArea = EquipmentSystem.GetEquipAreaType(itemID);

	if Equals(equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		if EquipmentSystem.IsItemSandevistan(itemID) {
			this.UnequipTaggedItems(equipArea, n"Berserk");
		}
		if EquipmentSystem.IsItemBerserk(itemID) {
			this.UnequipTaggedItems(equipArea, n"Sandevistan");
		}
	}
}

// Unequip items that has the specified tag.
@addMethod(EquipmentSystemPlayerData)
private func UnequipTaggedItems(equipArea: gamedataEquipmentArea, requiredTag: CName) -> Void {
	let requiredTags: array<CName>;
	ArrayPush(requiredTags, requiredTag);

	let equipAreaIndex: Int32 = this.GetEquipAreaIndex(equipArea);
	let numSlots: Int32 = ArraySize(this.m_equipment.equipAreas[equipAreaIndex].equipSlots);
	let slotIndex: Int32 = 0;

	while slotIndex < numSlots {
		let itemID: ItemID = this.m_equipment.equipAreas[equipAreaIndex].equipSlots[slotIndex].itemID;

		if ItemID.IsValid(itemID) && this.CheckTagsInItem(itemID, requiredTags) {
			this.UnequipItem(equipAreaIndex, slotIndex);
		}

		slotIndex += 1;
	}
}
