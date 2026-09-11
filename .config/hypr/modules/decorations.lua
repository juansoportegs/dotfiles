hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 2,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(ffffffff)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
    },

    decoration = {
        rounding       = 10,
        rounding_power = 1,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 3,
            color        = 0xee0a0a0a,
        },

        blur = {
            enabled  = true,
            size     = 20,
            passes   = 3,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


--- ANIMATIONS

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 90, dampening = 20 })

hl.animation({ leaf = "global",        enabled = true, speed = 1,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 0.3,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 0.3,  spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 0.3,  spring = "easy",         style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 0.15, bezier = "linear",       style = "popin 90%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 0.15, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 0.15, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 0.2,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 0.2,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 0.2,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 0.15, bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.15, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.15, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 0.12, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 0.12, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.12, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 0.3,  bezier = "quick" })