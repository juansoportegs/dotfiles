hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@144",
    position = "0x0",
    scale    = "1",
    vrr      = 0,
    bitdepth = 10,
    --icc      = "/home/user0/.color/icc/EX2780Q #1 2026-02-21 01-47 0.3127x 0.3291y sRGB F-S XYZLUT+MTX.icm",

})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@360",
    position = "2560x0",
    scale    = "1",
    vrr      = 0,
    bitdepth = 10,
})
