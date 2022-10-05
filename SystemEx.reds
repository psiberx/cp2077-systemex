// -----------------------------------------------------------------------------
// System-EX
// -----------------------------------------------------------------------------

module SystemEx

public class SystemEx extends ScriptableSystem {
	private let m_settings: ref<Settings>;

	private func OnAttach() -> Void {
		this.m_settings = new Settings();
	}

	public func GetVersion() -> String = "1.0.4"

	public func GetNumberOfSlots() -> Int32 {
		return this.m_settings.systemReplacementSlots;
	}

	public static func GetInstance(game: GameInstance) -> ref<SystemEx> {
		return GameInstance.GetScriptableSystemsContainer(game).Get(n"SystemEx.SystemEx") as SystemEx;
	}
}
