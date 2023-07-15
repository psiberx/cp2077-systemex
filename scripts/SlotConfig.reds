module SystemEx

struct OverridableSlotInfo {
    public let areaType: gamedataEquipmentArea;
    public let defaultSlots: Int32;
    public let maxSlots: Int32;

    public static func None() -> OverridableSlotInfo = new OverridableSlotInfo(gamedataEquipmentArea.Invalid, 0, 0)
    public static func IsValid(slot: OverridableSlotInfo) -> Bool = NotEquals(slot.areaType, gamedataEquipmentArea.Invalid)
}

public abstract class SlotConfig {
    public static func OverridePrice() -> Int32 = 10000
    public static func ResetPrice() -> Int32 = 5000

    public static func OverridableSlots() -> array<OverridableSlotInfo> = [
        new OverridableSlotInfo(gamedataEquipmentArea.FrontalCortexCW, 3, 6),
        //new OverridableSlotInfo(gamedataEquipmentArea.EyesCW, 1, 3),
        new OverridableSlotInfo(gamedataEquipmentArea.CardiovascularSystemCW, 3, 6),
        new OverridableSlotInfo(gamedataEquipmentArea.ImmuneSystemCW, 2, 6),
        new OverridableSlotInfo(gamedataEquipmentArea.NervousSystemCW, 2, 6),
        new OverridableSlotInfo(gamedataEquipmentArea.IntegumentarySystemCW, 3, 6),      
        new OverridableSlotInfo(gamedataEquipmentArea.SystemReplacementCW, 1, 3),
        new OverridableSlotInfo(gamedataEquipmentArea.MusculoskeletalSystemCW, 2, 6),
        new OverridableSlotInfo(gamedataEquipmentArea.HandsCW, 1, 3),
        new OverridableSlotInfo(gamedataEquipmentArea.ArmsCW, 1, 4),
        new OverridableSlotInfo(gamedataEquipmentArea.LegsCW, 1, 2)
    ];
}
