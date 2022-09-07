
// Override the display of the selected cyberware to fix the duplicate bug.
// Originally the game duplicates the selected item multiple times for each slot
// available for the current equipment area.
@replaceMethod(InventoryCyberwareItemChooser)
protected func RefreshMainItem(opt isClothingSetEquipped: Bool, opt clothingSetIndex: Int32, opt showTransmogedIcon: Bool) -> Void {
	let itemID: ItemID;
	let slot: ref<InventoryItemDisplayController>;
	let numSlots: Int32 = 1; // this.inventoryDataManager.GetNumberOfSlots(this.equipmentArea);
	let i: Int32 = 0;
	while i < numSlots {
		itemID = this.inventoryDataManager.GetEquippedItemIdInArea(this.equipmentArea, this.slotIndex);
		this.itemData = this.inventoryDataManager.GetItemDataFromIDInLoadout(itemID);
		ArrayPush(this.itemDatas, this.itemData);
		i += 1;
	}
	inkCompoundRef.RemoveAllChildren(this.m_itemContainer);
	i = 0;
	while i < numSlots {
		slot = ItemDisplayUtils.SpawnCommonSlotController(this, this.m_itemContainer, n"itemDisplay") as InventoryItemDisplayController;
		slot.GetRootWidget().RegisterToCallback(n"OnRelease", this, n"OnItemInventoryClick");
		slot.GetRootWidget().RegisterToCallback(n"OnHoverOver", this, n"OnInventoryItemHoverOver");
		slot.GetRootWidget().RegisterToCallback(n"OnHoverOut", this, n"OnInventoryItemHoverOut");
		slot.Bind(this.inventoryDataManager, this.equipmentArea, this.slotIndex, ItemDisplayContext.Ripperdoc);
		i += 1;
	}
}
