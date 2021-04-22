// Add tandem jump self to aircraft
private _condition = {_this call FUNC(canTandemJump)};
private _statement = {};
private _insertChildren = {_this call FUNC(getTandemChildrenActions)};
private _text = localize LSTRING(tandemJump);
private _icon = QPATHTOF(ui\tandem_ca.paa);

private _action = [QGVAR(tandemJump), _text, _icon, _statement, _condition, _insertChildren] call ace_interact_menu_fnc_createAction;
["Air", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

_condition = {[_player] call FUNC(canCutLoweringLine)};
_statement = {[_player] call FUNC(actionCutLoweringLine)};
_text = localize LSTRING(cutLoweringLine);
_icon = "\z\ace\addons\attach\UI\detach_ca.paa";
_action = [QGVAR(cutLoweringLine), _text, _icon, _statement, _condition, _insertChildren] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;
