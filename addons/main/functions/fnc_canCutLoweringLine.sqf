#include "script_component.hpp"
/*
 * Author: Ampersand
 * Checks if given unit can cut its lowering line
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Success <BOOLEAN>
 *
 * Example:
 * [_unit] call mttb_main_fnc_canCutLoweringLine;
 *
 * Public: No
 */

params ["_unit"];

!isNull (_unit getVariable [QGVAR(loweringLine), objNull])
