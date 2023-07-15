module SystemEx

public class SlotState {
	public let areaType: gamedataEquipmentArea;
    public let areaIndex: Int32;
	public let currentSlots: Int32;
	public let defaultSlots: Int32;
    public let maxSlots: Int32;
	public let isOverridable: Bool;
	public let canBuyOverride: Bool;
	public let canBuyReset: Bool;
}

public class SlotManager {
	private let m_overridableSlots: array<OverridableSlotInfo>;
	private let m_playerData: ref<EquipmentSystemPlayerData>;
	
	public func Initialize(playerData: ref<EquipmentSystemPlayerData>) {
		this.m_overridableSlots = SlotConfig.OverridableSlots();
		this.m_playerData = playerData;
	}
	
	public func GetOverridableSlotState(areaType: gamedataEquipmentArea) -> ref<SlotState> {
		let slotState = new SlotState();
		slotState.areaType = areaType;
		slotState.areaIndex = this.GetEquipAreaIndex(areaType);
		slotState.currentSlots = this.GetEquipAreaNumberOfSlots(areaType);
		
		let slotInfo = this.GetOverridableSlotInfo(areaType);
		if OverridableSlotInfo.IsValid(slotInfo) {
			slotState.defaultSlots = slotInfo.defaultSlots;
			slotState.maxSlots = slotInfo.maxSlots;
			slotState.isOverridable = true;

			let playerMoney = GameInstance.GetTransactionSystem(this.m_playerData.m_owner.GetGame())
				.GetItemQuantity(this.m_playerData.m_owner, MarketSystem.Money());

			slotState.canBuyOverride = (playerMoney >= SlotConfig.OverridePrice());
			slotState.canBuyReset = (playerMoney >= SlotConfig.ResetPrice());
		}

		return slotState;
	}

	public func OverrideSlot(areaType: gamedataEquipmentArea, opt free: Bool) -> Bool {
		let slotState = this.GetOverridableSlotState(areaType);

		if !slotState.isOverridable || slotState.currentSlots == slotState.maxSlots {
			return false;
		}

		if !slotState.canBuyOverride && !free {
			return false;
		}

		ArrayResize(this.m_playerData.m_equipment.equipAreas[slotState.areaIndex].equipSlots, slotState.currentSlots + 1);

		GameInstance.GetTransactionSystem(this.m_playerData.m_owner.GetGame())
			.RemoveItem(this.m_playerData.m_owner, MarketSystem.Money(), SlotConfig.OverridePrice());

		return true;
	}

	public func ResetSlot(areaType: gamedataEquipmentArea, opt free: Bool) -> Bool {
		let slotState = this.GetOverridableSlotState(areaType);

		if !slotState.isOverridable || slotState.currentSlots == slotState.defaultSlots {
			return false;
		}

		if !slotState.canBuyReset && !free {
			return false;
		}

		let slotIndex = slotState.defaultSlots + 1;
		while slotIndex <= slotState.currentSlots {
			if ItemID.IsValid(this.m_playerData.m_equipment.equipAreas[slotState.areaIndex].equipSlots[slotIndex].itemID) {
				this.m_playerData.UnequipItem(slotState.areaIndex, slotIndex);
			}
			slotIndex += 1;
		}

		ArrayResize(this.m_playerData.m_equipment.equipAreas[slotState.areaIndex].equipSlots, slotState.defaultSlots);

		GameInstance.GetTransactionSystem(this.m_playerData.m_owner.GetGame())
			.RemoveItem(this.m_playerData.m_owner, MarketSystem.Money(), SlotConfig.ResetPrice());

		return true;
	}
	
	private func GetOverridableSlotInfo(areaType: gamedataEquipmentArea) -> OverridableSlotInfo {
		for slot in this.m_overridableSlots {
			if Equals(slot.areaType, areaType) {
				return slot;
			}
		}

		return OverridableSlotInfo.None();
	}

    private func GetEquipAreaIndex(areaType: gamedataEquipmentArea) -> Int32 {
        let i = 0;
        while i < ArraySize(this.m_playerData.m_equipment.equipAreas) {
            if Equals(this.m_playerData.m_equipment.equipAreas[i].areaType, areaType) {
                return i;
            }
            i += 1;
        }
        return -1;
    }

    private func GetEquipAreaNumberOfSlots(areaType: gamedataEquipmentArea) -> Int32 {
        let i = 0;
        while i < ArraySize(this.m_playerData.m_equipment.equipAreas) {
            if Equals(this.m_playerData.m_equipment.equipAreas[i].areaType, areaType) {
                return ArraySize(this.m_playerData.m_equipment.equipAreas[i].equipSlots);
            }
            i += 1;
        }
        return -1;
    }
}
