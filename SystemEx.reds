// -----------------------------------------------------------------------------
// System-EX
// -----------------------------------------------------------------------------

module SystemEx

public class SystemEx extends ScriptableSystem {
	public let slots: ref<SlotsConfig>;

	public static func Version() -> String = "1.0.3"

	public static func GetInstance(game: GameInstance) -> ref<SystemEx> {
		return GameInstance.GetScriptableSystemsContainer(game).Get(n"SystemEx.SystemEx") as SystemEx;
	}

	public static final func Debug(const str: script_ref<String>) -> Void {
		LogChannel(n"DEBUG", s"[SystemEx] \(str)");
	}

	public static final func GetOverloadedEquipmentAreaTypes() -> array<gamedataEquipmentArea> = [
		gamedataEquipmentArea.ArmsCW,
		gamedataEquipmentArea.CardiovascularSystemCW,
		gamedataEquipmentArea.EyesCW,
		gamedataEquipmentArea.FrontalCortexCW,
		gamedataEquipmentArea.HandsCW,
		gamedataEquipmentArea.ImmuneSystemCW,
		gamedataEquipmentArea.IntegumentarySystemCW,
		gamedataEquipmentArea.LegsCW,
		gamedataEquipmentArea.MusculoskeletalSystemCW,
		gamedataEquipmentArea.NervousSystemCW,
		gamedataEquipmentArea.SystemReplacementCW
	];

	private func OnAttach() -> Void {
		this.Initialize();
	}

	private func Initialize() -> Void {
		this.slots = new SlotsConfig();

		SystemEx.Debug("mod initialized");
	}

	public final func GetSlotsCount(areaType: gamedataEquipmentArea) -> Int32 {
		switch (areaType) {
			case gamedataEquipmentArea.ArmsCW:
				return this.slots.arms;
			case gamedataEquipmentArea.CardiovascularSystemCW:
				return this.slots.cardiovascularSystem;
			case gamedataEquipmentArea.EyesCW:
				return this.slots.ocularSystem;
			case gamedataEquipmentArea.FrontalCortexCW:
				return this.slots.frontalCortex;
			case gamedataEquipmentArea.HandsCW:
				return this.slots.hands;
			case gamedataEquipmentArea.ImmuneSystemCW:
				return this.slots.immuneSystem;
			case gamedataEquipmentArea.IntegumentarySystemCW:
				return this.slots.integumentarySystem;
			case gamedataEquipmentArea.LegsCW:
				return this.slots.legs;
			case gamedataEquipmentArea.MusculoskeletalSystemCW:
				return this.slots.musculoSkeletalSystem;
			case gamedataEquipmentArea.NervousSystemCW:
				return this.slots.nervousSystem;
			case gamedataEquipmentArea.SystemReplacementCW:
				return this.slots.systemReplacement;
			default:
				return -1;
		}
	}
}

class SlotsConfig {
	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Operating System")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "3")
	public let systemReplacement: Int32 = 2;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Frontal Cortex")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "3")
	@runtimeProperty("ModSettings.max", "6")
	public let frontalCortex: Int32 = 3;

	// Disable ocular system overloading settings (hardcode to 1) since it does not make sense to use
	// multiple cyberwares
	/*
	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Ocular System slots")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "1")
	*/
	public let ocularSystem: Int32 = 1;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Circulatory System")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "3")
	@runtimeProperty("ModSettings.max", "6")
	public let cardiovascularSystem: Int32 = 3;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Immune System")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "2")
	@runtimeProperty("ModSettings.max", "6")
	public let immuneSystem: Int32 = 2;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Nervous System")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "2")
	@runtimeProperty("ModSettings.max", "6")
	public let nervousSystem: Int32 = 2;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Integumentary System")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "3")
	@runtimeProperty("ModSettings.max", "6")
	public let integumentarySystem: Int32 = 3;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Skeleton")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "2")
	@runtimeProperty("ModSettings.max", "6")
	public let musculoSkeletalSystem: Int32 = 2;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Hands")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "2")
	public let hands: Int32 = 1;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Arms")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "2")
	public let arms: Int32 = 1;

	@runtimeProperty("ModSettings.mod", "System-Ex")
	@runtimeProperty("ModSettings.displayName", "Legs")
	@runtimeProperty("ModSettings.step", "1")
	@runtimeProperty("ModSettings.min", "1")
	@runtimeProperty("ModSettings.max", "2")
	public let legs: Int32 = 1;
}
