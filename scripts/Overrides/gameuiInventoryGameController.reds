// Overrides Cyberdeck link in the Inventory screen to open the correct slot.
@wrapMethod(gameuiInventoryGameController)
private final func SetDeckData() {
	wrappedMethod();

	if inkWidgetRef.IsVisible(this.m_cyberdeckLinkItem) {
		let deckSlotController = inkWidgetRef.GetControllerByType(this.m_cyberdeckLinkItem, n"InventoryWeaponDisplayController") as InventoryWeaponDisplayController;
		deckSlotController.m_slotIndex = deckSlotController.m_itemData.SlotIndex;
	}
}
