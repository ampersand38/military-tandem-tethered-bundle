#include "script_component.hpp"
/*
 * Author: Ampersand
 * Returns children actions for tandem jump with cargo in the aircraft.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * Actions <ARRAY>
 *
 * Example:
 * [_vehicle, _player] call mttb_main_fnc_getTandemChildrenActions;
 *
 * Public: No
 */

params ["_vehicle", "_player"];

private _CargoObjectVIV = getVehicleCargo _vehicle;
private _CargoObjectACE = _vehicle getVariable ["ace_cargo_loaded", []];
private _vivCarrier = isVehicleCargo _vehicle;
if (_vivCarrier != objNull) then {
    // _vehicle is being carried as viv
    _CargoObjectVIV append (getVehicleCargo _vivCarrier);
    _CargoObjectACE append (_vivCarrier getVariable ["ace_cargo_loaded", []]);
};

private _actions = [];
{
    private _cargoMode = _forEachIndex;
    {
        private _config = configOf _x;
        if (getMass _x <= GVAR(MaxCargoMass)) then {
            private _displayName = getText (_config >> "displayName");
            private _picture = getText (_config >> "icon");
            if (_picture select [0,1] != "\") then {
                _picture = "\a3\ui_f\data\Map\VehicleIcons\" + _picture + "_ca.paa";
            };
            private _action = [
                netId _x,
                _displayName,
                _picture,
                {[{_this call FUNC(tandemJump)}, _this] call CBA_fnc_execNextFrame},
                {true},
                {},
                [_x, _cargoMode]
            ] call ace_interact_menu_fnc_createAction;

            _actions pushBack [_action, [], _vehicle];
        }
    } forEach _x;
} forEach [_CargoObjectVIV, _CargoObjectACE];

_actions
