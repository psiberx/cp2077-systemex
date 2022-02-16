
// Override the initialization of the cyberware grid so that it correctly displays the number of available mods
// when there is more than one slot for the equipment area.
@wrapMethod(RipperDocGameController)
protected cb func OnGridSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
	wrappedMethod(widget, userData);

	if Equals(this.m_screen, CyberwareScreenType.Inventory) {
		let gridUserData: ref<GridUserData> = userData as GridUserData;
		let minigridController: ref<CyberwareInventoryMiniGrid> = widget.GetController() as CyberwareInventoryMiniGrid;
		minigridController.UpdateTitles(this.GetAmountOfModsInArea(gridUserData.equipArea), this.m_screen);
	}
}

// Override the update / redraw of the cyberware grid so that it correctly displays the number of available mods
// when there is more than one slot for the equipment area.
@wrapMethod(RipperDocGameController)
private final func UpdateCWAreaGrid(selectedArea: gamedataEquipmentArea) -> Void {
	wrappedMethod(selectedArea);

	if Equals(this.m_screen, CyberwareScreenType.Inventory) {
		for minigridController in this.m_cybewareGrids {
			if Equals(minigridController.GetEquipementArea(), selectedArea) {
				minigridController.UpdateTitles(this.GetAmountOfModsInArea(selectedArea), this.m_screen);
				break;
			}
		}
	}
}

// Calculate the number of mods available for all items in the specified equipment area.
@addMethod(RipperDocGameController)
private final func GetAmountOfModsInArea(equipArea: gamedataEquipmentArea) -> Int32 {
	let numSlots: Int32 = this.m_InventoryManager.GetNumberOfSlots(equipArea);
	let slotIndex: Int32 = 0;
	let modsCount: Int32 = 0;

	while slotIndex < numSlots {
		let equippedData: InventoryItemData = this.m_InventoryManager.GetItemDataEquippedInArea(equipArea, slotIndex);

		if !InventoryItemData.IsEmpty(equippedData) {
			modsCount += this.GetAmountOfMods(equippedData);
		}

		slotIndex += 1;
	}

	return modsCount;
}
