---- WINDOWS AND WORKSPACES ----

hl.window_rule({ name = "bitwarden", match = { class = "brave-nngceckbapebfimnlniiiahkandclblb-Default" }, float = true})
hl.window_rule({ name = "calculator", match = { class = "org.gnome.Calculator" }, float = true})
hl.window_rule({ name = "localsend", match = { class = "localsend" }, float = true})
hl.window_rule({ name = "emoji-picker", match = { class = "emoji-picker" }, float = true })

hl.window_rule({ match = { class = "org.remmina.Remmina", title = "Remmina Remote Desktop Client" }, workspace = "2" })
hl.window_rule({ match = { class = "org.remmina.Remmina", title = "negative:Remmina Remote Desktop Client" }, workspace = "3" })

hl.window_rule({ match = { class = "vesktop" },                             workspace = "4" })
hl.window_rule({ match = { class = "com.ayugram.desktop" },                 workspace = "4" })
hl.window_rule({ match = { class = "brave-web.whatsapp.com__-Default" },    workspace = "4" })


hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Pin workspace 1,3,5 to DP-1 / 2,4,6 to DP-2
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2", layout = "master" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })