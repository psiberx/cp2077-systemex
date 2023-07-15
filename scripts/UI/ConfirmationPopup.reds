module SystemEx

enum OperrideAction {
    Upgrade = 1,
    Reset = 2
}

public class ConfirmationPopup {
    public static func Show(controller: ref<worlduiIGameController>, action: OperrideAction, slotState: ref<SlotState>) -> ref<inkGameNotificationToken> {
        let title = ConfirmationPopup.GetTitle(action);

        let areaLabel = ConfirmationPopup.GetAreaLabel();
        let areaName = ConfirmationPopup.GetAreaName(slotState);

        let slotLabel = ConfirmationPopup.GetSlotLabel();
        let initialSlots = ConfirmationPopup.GetInitialSlots(action, slotState);
        let finalSlots = ConfirmationPopup.GetFinalSlots(action, slotState);

        let priceLabel = ConfirmationPopup.GetPriceLabel();
        let actionPrice = ConfirmationPopup.GetActionPrice(action);

        let message = s"\(areaLabel): \(areaName)\n"
            + s"\(slotLabel): \(initialSlots) > \(finalSlots)\n"
            + s"\(priceLabel): \(actionPrice)";

        return GenericMessageNotification.Show(controller, EnumInt(slotState.areaType), title, message, GenericMessageNotificationType.ConfirmCancel);
    }

    public static func IsConfirmed(data: ref<inkGameNotificationData>) -> Bool {
        let popupData = data as GenericMessageNotificationCloseData;
        return Equals(popupData.result, GenericMessageNotificationResult.Confirm);
    }

    public static func GetAreaType(data: ref<inkGameNotificationData>) -> gamedataEquipmentArea {
        let popupData = data as GenericMessageNotificationCloseData;
        return IntEnum<gamedataEquipmentArea>(popupData.identifier);
    }

    private static func GetTitle(action: OperrideAction) -> String {
        return s"\(ConfirmationPopup.GetActionLabel(action)) \(ConfirmationPopup.GetAreaLabel())";
    }

    private static func GetActionLabel(action: OperrideAction) -> String {
        return Equals(action, OperrideAction.Upgrade)
            ? GetLocalizedTextByKey(n"UI-Crafting-Upgrade")
            : GetLocalizedTextByKey(n"UI-ResourceExports-Reset");
    }

    // private static func GetActionText(action: OperrideAction) -> String {
    //     return s"\(ConfirmationPopup.GetActionLabel(action)) \(GetLocalizedText("LocKey#36278"))";
    // }

    private static func GetInitialSlots(action: OperrideAction, slotState: ref<SlotState>) -> Int32 {
        return slotState.currentSlots;
    }

    private static func GetFinalSlots(action: OperrideAction, slotState: ref<SlotState>) -> Int32 {
        return Equals(action, OperrideAction.Upgrade) ? slotState.currentSlots + 1 : slotState.defaultSlots;
    }

    private static func GetActionPrice(action: OperrideAction) -> Int32 {
        return Equals(action, OperrideAction.Upgrade) ? SlotConfig.UpgradePrice() : SlotConfig.ResetPrice();
    }

    private static func GetAreaName(slotState: ref<SlotState>) -> String {
        let name = EnumValueToString("gamedataEquipmentArea", Cast<Int64>(EnumInt(slotState.areaType)));
        let record = TweakDBInterface.GetEquipmentAreaRecord(TDBID.Create("EquipmentArea." + name));
        let result = record.LocalizedName();
        return NotEquals(result, "") ? GetLocalizedText(result) : name;
    }

    private static func GetAreaLabel() -> String = GetLocalizedText("UI-ResourceExports-Cyberware")
    private static func GetSlotLabel() -> String = GetLocalizedText("LocKey#53485")
    private static func GetPriceLabel() -> String = GetLocalizedText("UI-ResourceExports-Price")
    // private static func GetCurrencyLabel() -> String = GetLocalizedText("LocKey#13363")
}
