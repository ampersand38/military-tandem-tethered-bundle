#include "script_component.hpp"
/*
 * Author: Ampersand
 * Make the unit tandem jump with cargo from the aircraft
 *
 * Arguments:
 * 0: Aircraft <OBJECT>
 * 1: Unit <OBJECT>
 * 2: Array containing the cargo object and caro mode: 0 if ViV, 1 if ACE <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_aircraft, _player, [_cargo]] call mttb_main_fnc_tandemJump;
 *
 * Public: No
 */

#define TERMINALSPEED 55

params ["_aircraft", "_unit", "_args"];
_args params [["_cargo", objNull, [objNull]], ["_cargoMode", -1, [0]]];

[QGVAR(localizeBundle), [_unit, _cargo]] call CBA_fnc_serverEvent;
_unit setVariable [QGVAR(cargo), _cargo];
moveOut _unit;

[{
    params ["_unit"];
    vehicle _unit == _unit
}, {
    params ["_unit", "_aircraft", "_cargo"];
    _unit setPosASL (_aircraft modelToWorldVisualWorld [0, -((0 boundingBoxReal _aircraft) select 2), 0]);
    _unit setDir getDir _aircraft;
    _unit setVelocity velocity _aircraft;

    switch (_cargoMode) do {
        case CARGOMODEVIV: {
            // Mass
            _aircraft setMass (getMass _aircraft - getMass _cargo);
        };
        case CARGOMODEACE: {
            // Loaded cargo list
            private _loaded = _aircraft getVariable ["ace_cargo_loaded", []];
            if !(_cargo in _loaded) exitWith {false};
            _loaded deleteAt (_loaded find _cargo);
            _aircraft setVariable ["ace_cargo_loaded", _loaded, true];

            // Cargo space
            private _cargoSpace = [_aircraft] call ace_cargo_fnc_getCargoSpaceLeft;
            private _cargoSize = [_cargo] call ace_cargo_fnc_getSizeItem;
            _aircraft setVariable ["ace_cargo_space", (_cargoSpace + _cargoSize), true];
        };
    };

    // Rope top helper, workaround parachute rope visual bug, allow cut
    private _ropeTop = createVehicle ["ace_fastroping_helper", getPos _unit, [], 0, "CAN_COLLIDE"];
    _unit setVariable [QGVAR(loweringLine), _ropeTop];
    _ropeTop allowDamage false;

    boundingBoxReal _cargo params ["", "", "_cargoTop"];
    private _rope = ropeCreate [
        _ropeTop, [0, 0.1, -0.5],
        _cargo, getCenterOfMass _cargo vectorAdd [0, 0, 0.5],
        5
    ];

    [{
        params ["_unit", "_ropeTop", "_cargo"];

        _ropeTop attachTo [_unit, [0, 0, 0]];
        _cargo attachTo [_unit, [0, 0, -1]];

        [{
            params ["_unit", "_ropeTop", "_cargo"];

            _unit allowDamage false;
            detach _cargo;
            _cargo setVelocity velocity _unit;

            [{
                params ["_unit", "_pfhID"];
                if (_unit != vehicle _unit) exitWith {
                    [_pfhID] call CBA_fnc_removePerFrameHandler;
                };
                _velocity = velocity _unit;
                if (vectorMagnitude _velocity > TERMINALSPEED ) then {
                    _unit setVelocity (vectorNormalized _velocity vectorMultiply TERMINALSPEED);
                };
            }, 1, _unit] call CBA_fnc_addPerFrameHandler;
        }, [_unit, _ropeTop, _cargo], 1] call CBA_fnc_waitAndExecute;

    }, [_unit, _ropeTop, _cargo]] call CBA_fnc_execNextFrame;

    [QGVAR(checkLandedPFH), [_ropeTop, _cargo]] call CBA_fnc_serverEvent;

    _unit setVariable [QGVAR(parachuteCheckEH), ["vehicle", {
        params ["_unit", "_newVehicle", "_oldVehicle"];

        if (_newVehicle isKindOf "ParachuteBase") then {
            _unit allowDamage true;
            private _ropeTop = _unit getVariable [QGVAR(loweringLine), objNull];
            _ropeTop attachTo [_newVehicle, [0,0,0]];

            private _cargo = _unit getVariable [QGVAR(cargo), objNull];
            _unit setVariable [QGVAR(cargo), objNull];

            private _parachuteCheckEH = _unit getVariable [QGVAR(parachuteCheckEH), -1];
            if (_parachuteCheckEH != -1) then {
                ["vehicle", _parachuteCheckEH] call CBA_fnc_removePlayerEventHandler;
            };
        };
        // TODO: handle ACE reserve chute and landing
    }, true] call CBA_fnc_addPlayerEventHandler];

}, [_unit, _aircraft, _cargo], 1 ,{
    diag_log "mttb_main_fnc_tandemJump timed out waiting for _unloadSucess";
}] call CBA_fnc_waitUntilAndExecute;
