Config = {}

Config.categories = {
    lanterns = {
        {
            alwaysAttached = false, -- If true, the item will always be attached when equip the weapon, no matter if in use/hand or not.
            hashName = 'WEAPON_MELEE_LANTERN',
            model = `s_interact_lantern01x`,
            bone = {
                male = 'PH_Lantern',
                female = false, -- leave `false` to use same as male settings.
            },
            offset = {
                male = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.0,
                    pitch = 0.0,
                    roll = 0.0,
                    yaw = 0.0,
                },
                female = false, -- leave `false` to use same as male settings.
            },
        },
        {
            alwaysAttached = false,
            hashName = 'WEAPON_MELEE_DAVY_LANTERN',
            model = `s_interact_lantern02x`,
            bone = {
                male = 'PH_Lantern',
                female = false,
            },
            offset = {
                male = {
                    x = -0.05,
                    y = 0.0,
                    z = 0.0,
                    pitch = 0.0,
                    roll = 0.0,
                    yaw = 0.0,
                },
                female = false,
            },
        },
        {
            alwaysAttached = false,
            hashName = 'WEAPON_KIT_METAL_DETECTOR',
            model = `mp005_s_interact_detectorm01x`,
            bone = {
                male = 'PH_Lantern',
                female = false,
            },
            offset = {
                male = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.0,
                    pitch = 0.0,
                    roll = 0.0,
                    yaw = 0.0,
                },
                female = false,
            },
        }
    },
    lasso = {
        {
            alwaysAttached = false,
            hashName = 'WEAPON_LASSO',
            model = `p_cs_melee_lasso01`,
            bone = {
                male = 'SKEL_L_Thigh',
                female = 'skel_l_thigh',
            },
            offset = {
                male = {
                    x = 0.0,
                    y = 0.0,
                    z = -0.11,
                    pitch = -83.0,
                    roll = 0.0,
                    yaw = 80.0,
                },
                female = false,
            },
        },
        {
            alwaysAttached = false,
            hashName = 'WEAPON_LASSO_REINFORCED',
            model = `p_cs_melee_lasso01`,
            bone = {
                male = 'SKEL_L_Thigh',
                female = 'skel_l_thigh',
            },
            offset = {
                male = {
                    x = 0.0,
                    y = 0.0,
                    z = -0.11,
                    pitch = -83.0,
                    roll = 0.0,
                    yaw = 80.0,
                },
                female = false,
            },
        }
    },
    machete = {
        {
            alwaysAttached = false,
            hashName = 'WEAPON_MELEE_MACHETE',
            model = `p_machete01x`,
            bone = {
                male = 'SKEL_L_Thigh',
                female = 'skel_l_thigh',
            },
            offset = {
                male = {
                    x = 0.0,
                    y = 0.0,
                    z = -0.11,
                    pitch = 0.0,
                    roll = 0.0,
                    yaw = 120.0,
                },
                female = false,
            },
        }
    },
    quiver = {
        {
            alwaysAttached = true,
            hashName = {'weapon_bow', 'weapon_bow_improved'},
            model = `p_arrowbundle01x`,
            bone = {
                male = 'CP_Back',
                female = 'CP_Back',
            },
            offset = {
                male = {
                    x = -0.30,
                    y = 0.0,
                    z = 0.0,
                    pitch = 0.0,
                    roll = -10.0,
                    yaw = 100.0,
                },
                female = false,
            },
        }
    },
}
