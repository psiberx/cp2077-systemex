module SystemEx

public abstract class SlotManager {
	public static func OverloadSlots(playerData: ref<EquipmentSystemPlayerData>) {
		let settings = new Settings();
		let slotOverloads = settings.GetSlotOverloads();

		for slotOverload in slotOverloads {
			let equipmentAreaIndex = playerData.GetEquipAreaIndexByType(slotOverload.equipmentArea);
	
			if ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots) < 1 {
				break;
			}

			let desiredNumSlots = slotOverload.desiredSlots;
			let currentNumSlots = ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots);

			if desiredNumSlots != currentNumSlots {
				if (desiredNumSlots < currentNumSlots) {
					let slotIndex = desiredNumSlots + 1;
					while (slotIndex <= currentNumSlots) {
						playerData.UnequipItem(equipmentAreaIndex, slotIndex);
						slotIndex += 1;
					}
				}
	
				ArrayResize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots, desiredNumSlots);
			}
		}
	}
}