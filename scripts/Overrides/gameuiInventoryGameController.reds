
// Make Cyberdeck link on the Inventory screen opens the right slot.
@wrapMethod(gameuiInventoryGameController)
private final func SetDeckData() {
	wrappedMethod();

	if inkWidgetRef.IsVisible(this.m_cyberdeckLinkItem) {
		let deckSlotController = inkWidgetRef.GetControllerByType(this.m_cyberdeckLinkItem, n"InventoryWeaponDisplayController") as InventoryWeaponDisplayController;
		deckSlotController.m_slotIndex = deckSlotController.m_itemData.SlotIndex;
	}
}
