#include "script_component.hpp"

if (isServer) then {
    [QGVAR(handleDisconnect), {
        addMissionEventHandler ["HandleDisconnect", {
            params ["_unit", "_id", "_uid", "_name"];
            {
                detach _x;
            } forEach attachedObjects _unit;
        }];
    }] call CBA_fnc_addEventHandler;

    [QGVAR(checkLandedPFH), {
        params ["_ropeTop", "_cargo"];
        [{
            params ["_ropeTop", "_pfhID"];
            if (speed _ropeTop < 1 && {getPos _ropeTop # 2 < 1}) exitWith {
                deleteVehicle _ropeTop;
                [_pfhID] call CBA_fnc_removePerFrameHandler;
            };
        }, 1, _ropeTop] call CBA_fnc_addPerFrameHandler;
        /*
        [{
            params ["_cargo", "_pfhID"];
            if (speed _cargo < 1 && {getPos _cargo # 2 < 1} && {isNull ropeAttachedTo _cargo}) exitWith {
                private _pos = getPos _cargo;
                _pos set [2, 0];
                _cargo setPos _pos;
                [_pfhID] call CBA_fnc_removePerFrameHandler;
            };
        }, 1, _cargo] call CBA_fnc_addPerFrameHandler;
        */
    }] call CBA_fnc_addEventHandler;

    [QGVAR(localizeBundle), {
        params ["_unit", "_cargo"];
        if (isObjectHidden _cargo) then {
            _cargo hideObjectGlobal false;
        };
        private _unitOwner = owner _unit;
        if (_unitOwner != owner _cargo) then {
            _cargo setOwner _unitOwner;
        };
    }] call CBA_fnc_addEventHandler;

};

#include "ACE_Actions.sqf"
