// Overrides how the best matching slot is determined for the specified item.
@wrapMethod(CyberwareInventoryMiniGrid)
public final func GetSlotToEquipe(itemID: ItemID) -> Int32 {
	if Equals(this.m_equipArea, gamedataEquipmentArea.SystemReplacementCW) {
		return this.m_selectedSlotIndex;
	}

	return wrappedMethod(itemID);
}
