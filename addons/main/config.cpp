#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ace_common"};
        author = "Ampersand";
        authors[] = {"Ampersand"};
        authorUrl = "https://github.com/ampersand38/military-tandem-tethered-bundle";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class CfgVehicles {
    class UAV_01_base_F;
    class GVAR(drogue): UAV_01_base_F {
        author = "Ampersand";
        _generalMacro = QGVAR(drogue);
        scope = 1;
        bodyFrictionCoef = 0.1;
    };
};
