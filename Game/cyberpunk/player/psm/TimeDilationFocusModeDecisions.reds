
// Override PSM Focus Mode transitions to activate corresponding time dilation,
// even if Sandevistan time dilation is already active.
// Allows the player to use Scanner and Quickhacks without canceling Sandevistan effect.
// Originally the game cancels Sandevistan effect when the player enters Focus Mode.
@wrapMethod(TimeDilationFocusModeDecisions)
protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
	if !this.IsInVisionModeActiveState(stateContext, scriptInterface) {
		if this.IsTimeDilationActive(stateContext, scriptInterface, TimeDilationHelper.GetFocusModeKey()) {
			let timeSystem: ref<TimeSystem> = scriptInterface.GetTimeSystem();
			let timeDilation: Float = TweakDBInterface.GetFloat(t"timeSystem.focusModeTimeDilation.timeDilation", 0.0);
			let easeOutCurve: CName = TweakDBInterface.GetCName(t"timeSystem.focusModeTimeDilation.easeOutCurve", n"");
			let applyTimeDilationToPlayer: Bool = TweakDBInterface.GetBool(t"timeSystem.focusModeTimeDilation.applyTimeDilationToPlayer", false);

			timeSystem.UnsetTimeDilation(TimeDilationHelper.GetFocusModeKey(), easeOutCurve);

			if applyTimeDilationToPlayer {
				if this.IsTimeDilationActive(stateContext, scriptInterface, TimeDilationHelper.GetSandevistanKey()) {
					timeSystem.SetTimeDilationOnLocalPlayerZero(TimeDilationHelper.GetSandevistanKey(), 1.0, 999.0, n"", n"", true);
				} else {
					timeSystem.UnsetTimeDilationOnLocalPlayerZero(easeOutCurve);
				}
			}
		}

		return false;
	}

	if this.IsPlayerInBraindance(scriptInterface) {
		return false;
	}

	if !this.ShouldActivate(stateContext, scriptInterface) {
		return false;
	}

	if this.IsTimeDilationActive(stateContext, scriptInterface, TimeDilationHelper.GetSandevistanKey()) {
		if !this.IsTimeDilationActive(stateContext, scriptInterface, TimeDilationHelper.GetFocusModeKey()) {
			let timeSystem: ref<TimeSystem> = scriptInterface.GetTimeSystem();
			let timeDilation: Float = TweakDBInterface.GetFloat(t"timeSystem.focusModeTimeDilation.timeDilation", 0.0);
			let playerDilation: Float = TweakDBInterface.GetFloat(t"timeSystem.focusModeTimeDilation.playerTimeDilation", 0.0);
			let easeInCurve: CName = TweakDBInterface.GetCName(t"timeSystem.focusModeTimeDilation.easeInCurve", n"");
			let easeOutCurve: CName = TweakDBInterface.GetCName(t"timeSystem.focusModeTimeDilation.easeOutCurve", n"");
			let applyTimeDilationToPlayer: Bool = TweakDBInterface.GetBool(t"timeSystem.focusModeTimeDilation.applyTimeDilationToPlayer", false);

    		timeSystem.SetTimeDilation(TimeDilationHelper.GetFocusModeKey(), timeDilation, 999.0, easeInCurve, easeOutCurve);

			if applyTimeDilationToPlayer {
				timeSystem.SetTimeDilationOnLocalPlayerZero(TimeDilationHelper.GetFocusModeKey(), playerDilation, 999.0, easeInCurve, easeOutCurve, true);
			}
		}

    	return false;
	}

	return this.GetBoolFromTimeSystemTweak("focusModeTimeDilation", "enableTimeDilation");
}
