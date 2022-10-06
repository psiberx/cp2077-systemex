// -----------------------------------------------------------------------------
// System-EX Settings
// -----------------------------------------------------------------------------

module SystemEx

public struct SlotOverload {
	public let equipmentArea: gamedataEquipmentArea;
	public let numberOfSlots: Int32;
}

public class Settings {
	@runtimeProperty("ModSettings.mod", "System-EX")
	@runtimeProperty("ModSettings.displayName", "Operating System Slots")
	@runtimeProperty("ModSettings.description", "Number of operating system slots.")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "3")
	public let systemReplacementSlots: Int32 = 2;

	@runtimeProperty("ModSettings.mod", "System-EX")
	@runtimeProperty("ModSettings.displayName", "Hands Slots")
	@runtimeProperty("ModSettings.description", "Number of hands slots.")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "2")
	public let handsSlots: Int32 = 1;

	public func GetSlotOverloads() -> array<SlotOverload> {
		return [
			new SlotOverload(gamedataEquipmentArea.SystemReplacementCW, this.systemReplacementSlots),
			new SlotOverload(gamedataEquipmentArea.HandsCW, this.handsSlots)
		];
	}
}
