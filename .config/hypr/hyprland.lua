-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
	local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
	local entry = share .. "/hypr/hyde.lua"
	local handle = io.open(entry, "r")
	if not handle then
		error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
	end
	handle:close()
	dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

-- Cycle fullscreen on ALT + Enter (override convenience bind)
local _cycle_fullscreen = function()
    local active_window = assert(hl.get_active_window(), "No active window to toggle fullscreen")
    local current_state = tonumber(active_window.fullscreen) or 0
    local next_state = (current_state + 1) % 3
    hl.dispatch(
        hl.dsp.window.fullscreen_state(
            {
                internal = next_state,
                client = next_state,
                window = active_window
            }
        )
    )
end
hl.bind("ALT + Return", _cycle_fullscreen, { description = "[Window Management] cycle fullscreen" })

-- Alt-Tab: cycle windows on the CURRENT WORKSPACE only (Hyprland's native
-- cycle_next is workspace-local), replacing HyDE's global altab script.
-- Flags must match HyDE's binds exactly for the override to replace them
-- (see header above). The release binds are neutralized with no_op so they
-- no longer spawn the altab script on every Alt release.
hl.bind("ALT+TAB", hl.dsp.window.cycle_next(), {
	transparent = true,
	description = "[Window Management|alt-tab] cycle next window (current workspace)",
})
hl.bind("ALT+SHIFT+TAB", hl.dsp.window.cycle_next({ next = false }), {
	transparent = true,
	description = "[Window Management|alt-tab] cycle previous window (current workspace)",
})
hl.bind("ALT + ALT_R", hl.dsp.no_op(), { release = true, transparent = true, description = "[Window Management|alt-tab] noop" })
hl.bind("ALT + ALT_L", hl.dsp.no_op(), { release = true, transparent = true, description = "[Window Management|alt-tab] noop" })

-- Snap floating window to corners/edges: ALT + vim directional keys
local _snap_float = function(hdir, vdir)
	return function()
		local win = hl.get_active_window()
		if not win or not win.floating then
			return
		end
		if hdir then
			hl.dispatch(hl.dsp.window.move({ direction = hdir }))
		end
		if vdir then
			hl.dispatch(hl.dsp.window.move({ direction = vdir }))
		end
	end
end

hl.bind("ALT + H", _snap_float("left", nil),    { description = "[Window Management|Snap] float to top-left" })
hl.bind("ALT + L", _snap_float("right", nil),  { description = "[Window Management|Snap] float to bottom-right" })
hl.bind("ALT + K", _snap_float(nil, "up"),        { description = "[Window Management|Snap] float to top" })
hl.bind("ALT + J", _snap_float(nil, "down"),      { description = "[Window Management|Snap] float to bottom" })

hl.monitor({
	output = "eDP-1",
	mode = "2560x1600@60",
	position = "auto",
	scale = 1.6,
})

-- Instant workspace switching: disable workspace switch animations.
-- Loads after HyDE's animation presets, so these overrides take precedence.
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "workspacesIn", enabled = false })
hl.animation({ leaf = "workspacesOut", enabled = false })

-- Invert scroll direction (natural scrolling)
hl.config({
	input = {
		natural_scroll = false, -- invert mouse wheel
		touchpad = {
			natural_scroll = true, -- invert touchpad
		},
	},
})

hl.window_rule({
	name= "opaque-apps",
	match = {
		class = "^(mpv|com.stremio.stremio|zen|kitty)$"
	},
	opaque = true,
})

hl.window_rule({
	name= "borderless-apps",
	match = {
		class = "^(mpv|com.stremio.stremio|zen|kitty)$"
	},
	border_size = 0,
})
