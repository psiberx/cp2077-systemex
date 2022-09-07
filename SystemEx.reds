// -----------------------------------------------------------------------------
// System-EX
// -----------------------------------------------------------------------------

module SystemEx

public abstract class SystemEx {
	// Mod version
	public static func Version() -> String = "1.0.3"

	// Number of system replacement slots
	// [3] To use Cyberdeck, Operating System, and TechDeck (Drone Companions Mod) at the same time
	// [2] To use Cyberdeck and Operating System at the same time
	// [1] To remove extra slots from the player if you want to uninstall the mod
	public static func NumberOfSlots() -> Int32 = 2
}
