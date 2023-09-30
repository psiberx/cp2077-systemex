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
		this.m_playerData = playerData;
		this.m_overridableSlots = SlotConfig.OverridableSlots();
		for slot in this.m_overridableSlots {
			let areaRecord = this.m_playerData.GetEquipAreaRecordByType(slot.areaType);
			slot.defaultSlots = areaRecord.GetEquipSlotsCount();
		}
	}
	
	public func GetSlotState(areaType: gamedataEquipmentArea) -> ref<SlotState> {
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

			slotState.canBuyOverride = (playerMoney >= SlotConfig.UpgradePrice());
			slotState.canBuyReset = (playerMoney >= SlotConfig.ResetPrice());
		}

		return slotState;
	}

	public func UpgradeSlot(areaType: gamedataEquipmentArea, opt free: Bool, opt vendor: wref<GameObject>) -> Bool {
		let slotState = this.GetSlotState(areaType);

		if !slotState.isOverridable || slotState.currentSlots == slotState.maxSlots {
			return false;
		}

		if !slotState.canBuyOverride && !free {
			return false;
		}

		ArrayResize(this.m_playerData.m_equipment.equipAreas[slotState.areaIndex].equipSlots, slotState.currentSlots + 1);
		this.m_playerData.InitializeEquipSlotFromRecord(TDB.GetEquipSlotRecord(t"EquipmentArea.SimpleEquipSlot"),
		    this.m_playerData.m_equipment.equipAreas[slotState.areaIndex].equipSlots[slotState.currentSlots]);

		if !free {
			let transactionSystem = GameInstance.GetTransactionSystem(this.m_playerData.m_owner.GetGame());
			if IsDefined(vendor) {
				transactionSystem.TransferItem(this.m_playerData.m_owner, vendor, MarketSystem.Money(), SlotConfig.UpgradePrice());
			} else {
				transactionSystem.RemoveItem(this.m_playerData.m_owner, MarketSystem.Money(), SlotConfig.UpgradePrice());
			}
		}

		return true;
	}

	public func ResetSlot(areaType: gamedataEquipmentArea, opt free: Bool, opt vendor: wref<GameObject>) -> Bool {
		let slotState = this.GetSlotState(areaType);

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

		if !free {
			let transactionSystem = GameInstance.GetTransactionSystem(this.m_playerData.m_owner.GetGame());
			if IsDefined(vendor) {
				transactionSystem.TransferItem(this.m_playerData.m_owner, vendor, MarketSystem.Money(), SlotConfig.ResetPrice());
			} else {
				transactionSystem.RemoveItem(this.m_playerData.m_owner, MarketSystem.Money(), SlotConfig.ResetPrice());
			}
		}

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
