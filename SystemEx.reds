// -----------------------------------------------------------------------------
// System-EX
// -----------------------------------------------------------------------------

module SystemEx

public class SystemEx extends ScriptableSystem {
	public func OverloadSlots() -> Void {
		this.OverloadSlots(EquipmentSystem.GetData(GetPlayer(this.GetGameInstance())));
	}

	public func OverloadSlots(playerData: ref<EquipmentSystemPlayerData>) -> Void {
		let settings = new Settings();
		let slotOverloads = settings.GetSlotOverloads();

		for slotOverload in slotOverloads {
			let equipmentAreaIndex: Int32 = playerData.GetEquipAreaIndexByType(slotOverload.equipmentArea);
	
			if ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots) < 1 {
				break;
			}

			let desiredNumSlots: Int32 = slotOverload.numberOfSlots;
			let currentNumSlots: Int32 = ArraySize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots);
	
			if (desiredNumSlots >= 1 && desiredNumSlots != currentNumSlots) {
				if (desiredNumSlots < currentNumSlots) {
					let slotIndex: Int32 = desiredNumSlots + 1;
					while (slotIndex <= currentNumSlots) {
						playerData.UnequipItem(equipmentAreaIndex, slotIndex);
						slotIndex += 1;
					}
				}
	
				ArrayResize(playerData.m_equipment.equipAreas[equipmentAreaIndex].equipSlots, desiredNumSlots);
			}
		}
	}

	public static func GetInstance(game: GameInstance) -> ref<SystemEx> {
		return GameInstance.GetScriptableSystemsContainer(game).Get(n"SystemEx.SystemEx") as SystemEx;
	}

	public static func Version() -> String = "1.0.5"
}
