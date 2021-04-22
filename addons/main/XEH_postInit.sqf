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
        params ["_ropeTop", "_holder"];
        [{
            params ["_ropeTop", "_pfhID"];
            if (speed _ropeTop < 1 && {getPos _ropeTop # 2 < 1}) exitWith {
                deleteVehicle _ropeTop;
                [_pfhID] call CBA_fnc_removePerFrameHandler;
            };
        }, 1, _ropeTop] call CBA_fnc_addPerFrameHandler;
        [{
            params ["_holder", "_pfhID"];
            if (speed _holder < 1 && {getPos _holder # 2 < 1}) exitWith {
                private _pos = getPos _holder;
                _pos set [2, 0];
                _holder setPos _pos;
                [_pfhID] call CBA_fnc_removePerFrameHandler;
            };
        }, 1, _holder] call CBA_fnc_addPerFrameHandler;
    }] call CBA_fnc_addEventHandler;
};

#include "ACE_Actions.sqf"
