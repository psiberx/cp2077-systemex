import SystemEx.*

public abstract class SystemEx {
    public static func Version() -> String = "1.2.0"

    public static func UpgradeAllSlotsToMax(game: GameInstance) {
        let player = GetPlayer(game);
        let slotManager = new SlotManager();
	    slotManager.Initialize(EquipmentSystem.GetData(player));
        for slot in SlotConfig.OverridableSlots() {
            while (slotManager.UpgradeSlot(slot.areaType, true)) {}
        }
    }

    public static func ResetAllSlots(game: GameInstance) {
        let player = GetPlayer(game);
        let slotManager = new SlotManager();
	    slotManager.Initialize(EquipmentSystem.GetData(player));
        for slot in SlotConfig.OverridableSlots() {
            slotManager.ResetSlot(slot.areaType, true);
        }        
    }

    public static func UpgradeSlot(game: GameInstance, areaType: gamedataEquipmentArea, opt count: Int32) {
        let player = GetPlayer(game);
        let slotManager = new SlotManager();
	    slotManager.Initialize(EquipmentSystem.GetData(player));
        if count == 0 {
            count = 1;
        }
        while (count > 0) {
            slotManager.UpgradeSlot(areaType, true);
            count -= 1;
        }
    }

    public static func ResetSlot(game: GameInstance, areaType: gamedataEquipmentArea) {
        let player = GetPlayer(game);
        let slotManager = new SlotManager();
	    slotManager.Initialize(EquipmentSystem.GetData(player));
        slotManager.ResetSlot(areaType, true);
    }
}
