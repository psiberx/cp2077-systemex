module SystemEx

public abstract class SlotManager {
	public static func OverloadSlots(playerData: ref<EquipmentSystemPlayerData>) {
		let settings = new Settings();
		let slotOverloads = settings.GetSlotOverloads();

		for slotOverload in slotOverloads {
			let equipmentAreaIndex = SlotManager.GetEquipAreaIndexByType(playerData, slotOverload.equipmentArea);
	
			if ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots) < 1 {
				break;
			}

			let desiredNumSlots = slotOverload.desiredSlots;
			let currentNumSlots = ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots);

			if desiredNumSlots != currentNumSlots {
				if (desiredNumSlots < currentNumSlots) {
					let slotIndex = desiredNumSlots + 1;
					while (slotIndex <= currentNumSlots) {
					    if ItemID.IsValid(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots[slotIndex].itemID) {
						    playerData.UnequipItem(equipmentAreaIndex, slotIndex);
                        }
						slotIndex += 1;
					}
				}
	
				ArrayResize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots, desiredNumSlots);
			}
		}
	}

    private static func GetEquipAreaIndexByType(playerData: ref<EquipmentSystemPlayerData>, areaType: gamedataEquipmentArea) -> Int32 {
        let i = 0;
        while i < ArraySize(playerData.m_equipment.equipAreas) {
            if Equals(playerData.m_equipment.equipAreas[i].areaType, areaType) {
                return i;
            }
            i += 1;
        }
        return -1;
    }
}
