import SystemEx.*

@addField(RipperDocGameController)
private let m_slotManager: ref<SlotManager>;

@addField(RipperDocGameController)
private let m_confirmationToken: ref<inkGameNotificationToken>;

// Overrides intitialization of RipperDoc screen to create slot manager
// and add fluff text for detecting if System-EX is active.
@wrapMethod(RipperDocGameController)
private final func Init() {
    wrappedMethod();

	this.m_slotManager = new SlotManager();
	this.m_slotManager.Initialize(EquipmentSystem.GetData(this.m_player));

    if IsDefined(this.m_ripperId) {
        let text = new inkText();
        text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        text.SetFontStyle(n"Regular");
        text.SetFontSize(28);
        text.SetOpacity(0.1);
        text.SetAnchor(inkEAnchor.TopRight);
        text.SetAnchorPoint(new Vector2(1.0, 0.0));
        text.SetMargin(new inkMargin(0, 160, 4, 0));
        text.SetHorizontalAlignment(textHorizontalAlignment.Left);
        text.SetVerticalAlignment(textVerticalAlignment.Top);
        text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        text.BindProperty(n"tintColor", n"MainColors.Red");
        text.SetText("POWERED BY SYSTEM-EX");
        text.Reparent(this.m_ripperId.GetRootCompoundWidget());
    }
}

// Overrides initialization of the cyberware grid so that it correctly displays the number of available mods
// when there is more than one slot per equipment area.
@wrapMethod(RipperDocGameController)
protected cb func OnGridSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
	wrappedMethod(widget, userData);

	if Equals(this.m_screen, CyberwareScreenType.Inventory) {
		let gridUserData: ref<GridUserData> = userData as GridUserData;
		let minigridController: ref<CyberwareInventoryMiniGrid> = widget.GetController() as CyberwareInventoryMiniGrid;
		minigridController.UpdateTitles(this.GetAmountOfModsInArea(gridUserData.equipArea), this.m_screen);
	}
}

// Overrides initialization of the cyberware grid so that it correctly displays the number of available mods
// when there is more than one slot per equipment area.
@wrapMethod(RipperDocGameController)
private final func UpdateCWAreaGrid(selectedArea: gamedataEquipmentArea) {
	wrappedMethod(selectedArea);

	if Equals(this.m_screen, CyberwareScreenType.Inventory) {
		for minigridController in this.m_cybewareGrids {
			if Equals(minigridController.GetEquipementArea(), selectedArea) {
				minigridController.UpdateTitles(this.GetAmountOfModsInArea(selectedArea), this.m_screen);
				break;
			}
		}
	}
}

// Calculates the number of mods available for all items in the specified equipment area.
@addMethod(RipperDocGameController)
private final func GetAmountOfModsInArea(equipArea: gamedataEquipmentArea) -> Int32 {
	let numSlots = this.m_InventoryManager.GetNumberOfSlots(equipArea);
	let slotIndex = 0;
	let modsCount = 0;

	while slotIndex < numSlots {
		let equippedData: InventoryItemData = this.m_InventoryManager.GetItemDataEquippedInArea(equipArea, slotIndex);

		if !InventoryItemData.IsEmpty(equippedData) {
			modsCount += this.GetAmountOfMods(equippedData);
		}

		slotIndex += 1;
	}

	return modsCount;
}

@wrapMethod(RipperDocGameController)
private final func SetInventoryItemButtonHintsHoverOver(displayingData: InventoryItemData) {
	wrappedMethod(displayingData);

	if Equals(this.m_screen, CyberwareScreenType.Ripperdoc) {
		// let cursorContext = n"Hover";
		// let cursorData: ref<MenuCursorUserData>;

		if Equals(this.m_mode, RipperdocModes.Default) {
			let slotState = this.m_slotManager.GetSlotState(displayingData.EquipmentArea);
			if slotState.isOverridable {
				// cursorData = new MenuCursorUserData();
				// cursorData.SetAnimationOverride(n"hoverOnHoldToComplete");
				// cursorContext = n"HoldToComplete";

				if slotState.currentSlots != slotState.defaultSlots {
					this.m_buttonHintsController.AddButtonHint(n"disassemble_item", 
						// "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + 
						GetLocalizedTextByKey(n"UI-ResourceExports-Reset"));
					// cursorData.AddAction(n"disassemble_item");
				}
				
				if slotState.currentSlots < slotState.maxSlots {
					this.m_buttonHintsController.AddButtonHint(n"upgrade_perk", 
						// "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + 
						GetLocalizedTextByKey(n"UI-Crafting-Upgrade"));
					// cursorData.AddAction(n"upgrade_perk");
				}
			}
		}

		// this.SetCursorContext(cursorContext, cursorData);
	}
}

@wrapMethod(RipperDocGameController)
protected cb func OnPreviewCyberwareClick(evt: ref<inkPointerEvent>) -> Bool {
	wrappedMethod(evt);

	if Equals(this.m_screen, CyberwareScreenType.Ripperdoc) && Equals(this.m_mode, RipperdocModes.Default) {
		let areaType = this.GetCyberwareSlotControllerFromTarget(evt).GetEquipmentArea();
		let slotState = this.m_slotManager.GetSlotState(areaType);
		
		switch (true) {
			case evt.IsAction(n"upgrade_perk"):
				if slotState.currentSlots < slotState.maxSlots {
					if slotState.canBuyOverride {
						this.m_confirmationToken = ConfirmationPopup.Show(this, OperrideAction.Upgrade, slotState);
						this.m_confirmationToken.RegisterListener(this, n"OnSlotUpgradeConfirmed");
					} else {
						this.ShowNotEnoughMoneyNotification();
					}
				}
				break;
			case evt.IsAction(n"disassemble_item"):
				if slotState.currentSlots != slotState.defaultSlots {
					if slotState.canBuyReset {
						this.m_confirmationToken = ConfirmationPopup.Show(this, OperrideAction.Reset, slotState);
						this.m_confirmationToken.RegisterListener(this, n"OnSlotResetConfirmed");
					} else {
						this.ShowNotEnoughMoneyNotification();
					}
				}
				break;
		}
	}
}

@addMethod(RipperDocGameController)	
protected func ShowNotEnoughMoneyNotification() {
	let notification = new UIMenuNotificationEvent();
	notification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
	
	this.QueueEvent(notification);
}

@addMethod(RipperDocGameController)
protected cb func OnSlotUpgradeConfirmed(data: ref<inkGameNotificationData>) -> Bool {
    if ConfirmationPopup.IsConfirmed(data) {
		let areaType = ConfirmationPopup.GetAreaType(data);
		let vendor = NotEquals(this.m_VendorDataManager.GetVendorName(), "")
			? this.m_VendorDataManager.GetVendorInstance()
			: null;

		this.m_slotManager.UpgradeSlot(areaType, false, vendor);
		this.UpdateCWAreaGrid(areaType);
		this.UpdateMoney();
    }

	this.m_confirmationToken = null;
}

@addMethod(RipperDocGameController)
protected cb func OnSlotResetConfirmed(data: ref<inkGameNotificationData>) -> Bool {
    if ConfirmationPopup.IsConfirmed(data) {
		let areaType = ConfirmationPopup.GetAreaType(data);
		let vendor = NotEquals(this.m_VendorDataManager.GetVendorName(), "")
			? this.m_VendorDataManager.GetVendorInstance()
			: null;

		this.m_slotManager.ResetSlot(areaType, false, vendor);
		this.UpdateCWAreaGrid(areaType);
		this.UpdateMoney();
    }

	this.m_confirmationToken = null;
}
