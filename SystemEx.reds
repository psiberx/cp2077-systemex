// -----------------------------------------------------------------------------
// System-EX Main Class
// -----------------------------------------------------------------------------

module SystemEx

public abstract class SystemEx {
	// Mod version
	public static func Version() -> String = "1.0.0"

	// Number of system replacement slots
	// Although you can change the number and it will add extra slots
	// it doesn't make much sense because game can't handle more than
	// one Cyberdeck and one Operating System at the same time.
	// So two slots is the only practical value at the moment.
	public static func NumberOfSlots() -> Int32 = 2
}
