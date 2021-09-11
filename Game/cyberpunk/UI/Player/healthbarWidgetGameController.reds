
// Override the installed Cyberdeck check that is used to determine
// if the memory bar should be displayed under the health bar.
@replaceMethod(healthbarWidgetGameController)
protected final const func IsCyberdeckEquipped() -> Bool {
	return EquipmentSystem.IsCyberdeckEquipped(this.GetPlayerControlledObject());
}