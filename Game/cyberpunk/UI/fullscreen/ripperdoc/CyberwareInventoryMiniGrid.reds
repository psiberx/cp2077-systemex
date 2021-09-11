
// Override how the best matching slot is determined for the specified item.
// Sandevistan and Berserk are considered to be replaceable items.
@replaceMethod(CyberwareInventoryMiniGrid)
public final func GetSlotToEquipe(itemID: ItemID) -> Int32 {
	let equipIndex: Int32 = this.m_selectedSlotIndex;
	let slotIndex: Int32 = ArraySize(this.m_gridData) - 1;
	let selectedType: CName = TweakDBInterface.GetCName(ItemID.GetTDBID(itemID) + t".cyberwareType", n"");
	let isSelectedOS: Bool = EquipmentSystem.IsItemOperatingSystem(itemID);

	while slotIndex >= 0 {
		let equippedData: InventoryItemData = this.m_gridData[slotIndex].GetItemData();

		if InventoryItemData.IsEmpty(equippedData) {
			equipIndex = this.m_gridData[slotIndex].GetSlotIndex();
		} else {
			let equippedID: ItemID = InventoryItemData.GetID(equippedData);
			let equippedType: CName = TweakDBInterface.GetCName(ItemID.GetTDBID(equippedID) + t".cyberwareType", n"");
			let isEquippedOS: Bool = EquipmentSystem.IsItemOperatingSystem(equippedID);

			if Equals(selectedType, equippedType) || (isSelectedOS && isEquippedOS) {
				equipIndex = this.m_gridData[slotIndex].GetSlotIndex();
				break;
			}
		}

		slotIndex -= 1;
	}

	return equipIndex;
}
