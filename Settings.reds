// -----------------------------------------------------------------------------
// System-EX Settings
// -----------------------------------------------------------------------------

module SystemEx

public class Settings {
	@runtimeProperty("ModSettings.mod", "System-EX")
	@runtimeProperty("ModSettings.displayName", "Operating System Slots")
	@runtimeProperty("ModSettings.description", "Number of operating system slots. You must reload your save after making changes.")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "3")
	public let systemReplacementSlots: Int32 = 2;
}
