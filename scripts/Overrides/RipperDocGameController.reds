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

    let text = new inkText();
    text.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    text.SetFontStyle(n"Regular");
    text.SetFontSize(28);
    text.SetOpacity(0.1);
    text.SetAnchor(inkEAnchor.TopRight);
    text.SetAnchorPoint(new Vector2(1.0, 0.0));
    text.SetMargin(new inkMargin(0, 160, 100, 0));
    text.SetHorizontalAlignment(textHorizontalAlignment.Left);
    text.SetVerticalAlignment(textVerticalAlignment.Top);
    text.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
    text.BindProperty(n"tintColor", n"MainColors.Red");
    text.SetText("POWERED BY SYSTEM-EX");
    text.Reparent(this.GetRootCompoundWidget());
}

@wrapMethod(RipperDocGameController)
protected cb func OnSlotHover(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
	wrappedMethod(evt);

	if Equals(this.m_screen, CyberwareScreenType.Ripperdoc) {
		// let cursorContext = n"Hover";
		// let cursorData: ref<MenuCursorUserData>;

		if Equals(this.m_filterMode, RipperdocModes.Default) {
			let slotState = this.m_slotManager.GetSlotState(evt.display.GetEquipmentArea());
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
					this.m_buttonHintsController.AddButtonHint(n"drop_item", 
						// "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + 
						GetLocalizedTextByKey(n"UI-ResourceExports-Buy"));
					// cursorData.AddAction(n"drop_item");
				}
			}
		}

		// this.SetCursorContext(cursorContext, cursorData);
	}
}

@wrapMethod(RipperDocGameController)
private final func SetButtonHintsUnhover() {
    wrappedMethod();

    this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
}

@wrapMethod(RipperDocGameController)
protected cb func OnPreviewCyberwareClick(evt: ref<inkPointerEvent>) -> Bool {
	wrappedMethod(evt);

	if Equals(this.m_screen, CyberwareScreenType.Ripperdoc) && Equals(this.m_filterMode, RipperdocModes.Default) {
		let areaType = this.GetCyberwareSlotControllerFromTarget(evt).GetEquipmentArea();
		let slotState = this.m_slotManager.GetSlotState(areaType);
		
		switch (true) {
			case evt.IsAction(n"drop_item"):
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
		this.UpdateMinigrids();
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
		this.UpdateMinigrids();
    }

	this.m_confirmationToken = null;
}
