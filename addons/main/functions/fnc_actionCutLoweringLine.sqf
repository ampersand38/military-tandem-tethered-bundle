#include "script_component.hpp"
/*
 * Author: Ampersand
 * Triggered by the CutLoweringLine-action. Detaches the lowering line top
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player] call mttb_main_fnc_actionCutLoweringLine
 *
 * Public: No
 */

params ["_unit"];

private _ropeTop = _unit getVariable [QGVAR(loweringLine), objNull];
if (isNull _ropeTop) exitWith {};

_unit setVariable [QGVAR(loweringLine), objNull, true];
detach _ropeTop;

private _ropes = ropes _ropeTop;
if (_ropes isEqualTo []) exitWith {deleteVehicle _ropeTop};
private _rope = _ropes # 0;

private _ropeAttachedObjects = ropeAttachedObjects _ropeTop;
if (_ropeAttachedObjects isEqualTo []) exitWith {};
private _bundle = _ropeAttachedObjects # 0;

_bundle ropeDetach _rope;
// ace_fastroping_helper is a helicopter and kind of autorotates down instead
// of falling, much slower than a falling object. Attaching to the holder
// also looks like the rope snapping under tension once cut

[{
    _ropeTop attachTo [_bundle, [0.1,-0.45,-0.6]];
}, [_unit, _ropeTop, _cargo]] call CBA_fnc_execNextFrame;
