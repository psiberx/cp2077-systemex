// Overrides the Operating System activation so it can correctly detect the installed cyberware.
// Originally the game can't detect the actual cyberware if it's installed in any slot except the first one.
@replaceMethod(PlayerPuppet)
private final func ActivateIconicCyberware() {
	let statsSystem = GameInstance.GetStatsSystem(this.GetGame());
	let playerStatsId = Cast<StatsObjectID>(this.GetEntityID());

	if statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasBerserk) {
		if !StatusEffectSystem.ObjectHasStatusEffect(this, t"BaseStatusEffect.BerserkPlayerBuff") {
			GameObject.PlaySound(this, n"slow");

			let activeItem = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW, n"Berserk");
			ItemActionsHelper.UseItem(this, activeItem);

			let psmEvent = new PSMPostponedParameterBool();
			psmEvent.id = n"OnBerserkActivated";
			psmEvent.value = true;

			this.QueueEvent(psmEvent);
		}
		return;
	}

	if statsSystem.GetStatBoolValue(playerStatsId, gamedataStatType.HasSandevistan) {
		if !StatusEffectSystem.ObjectHasStatusEffect(this, t"BaseStatusEffect.SandevistanPlayerBuff") {
			let activeItem = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW, n"Sandevistan");
			ItemActionsHelper.UseItem(this, activeItem);

			let psmEvent = new PSMPostponedParameterBool();
			psmEvent.id = n"requestSandevistanActivation";
			psmEvent.value = true;

			this.QueueEvent(psmEvent);
		}
		return;
	}
}

// Overrides the time dilation cleanup routine so that it can handle several active effects at the same time,
// as for Sandevistan + Focus Mode in particular.
@wrapMethod(PlayerPuppet)
protected cb func OnCleanUpTimeDilationEvent(evt: ref<CleanUpTimeDilationEvent>) -> Bool {
	let timeSystem = GameInstance.GetTimeSystem(this.GetGame());
    if !timeSystem.IsTimeDilationActive() {
    	wrappedMethod(evt);
    }
}
