import SystemEx.*

public class CloseModSettings extends Event {}

@wrapMethod(MenuScenario_BaseMenu)
protected final func SwitchMenu(menuName: CName, opt userData: ref<IScriptable>) {
	if Equals(this.m_currMenuName, n"mod_settings_main") {
		this.QueueEvent(new CloseModSettings());
	}

	wrappedMethod(menuName, userData);
}

@addMethod(PauseMenuGameController)
protected cb func OnCloseModSettings(evt: ref<CloseModSettings>) -> Bool {
    SlotManager.OverloadSlots(EquipmentSystem.GetData(this.GetPlayerControlledObject()));
}

@addMethod(DeathMenuGameController)
protected cb func OnCloseModSettings(evt: ref<CloseModSettings>) -> Bool {
    SlotManager.OverloadSlots(EquipmentSystem.GetData(this.GetPlayerControlledObject()));
}