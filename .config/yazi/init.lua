Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("cyan"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("cyan"),
		" ",
	})
end, 500, Status.RIGHT)

require("full-border"):setup()

require("smart-enter"):setup({
	open_multi = true,
})

require("whoosh"):setup({
	bookmarks = {
		{ tag = "Desktop", path = "~/Desktop", key = "E" },
		{ tag = "Documents", path = "~/Documents", key = "D" },
		{ tag = "Downloads", path = "~/Downloads", key = "O" },
	},
	jump_notify = false,
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	special_keys = {
		create_temp = false,
		fuzzy_search = false,
		history = "<Enter>",
		previous_dir = "'",
		project_root = "r",
	},
	bookmarks_path = (
		ya.target_family() == "windows"
		and os.getenv("APPDATA") .. "\\yazi\\config\\plugins\\whoosh.yazi\\bookmarks"
	) or (os.getenv("HOME") .. "/.config/yazi/plugins/whoosh.yazi/bookmarks"),
	home_alias_enabled = true,
	path_truncate_enabled = true,
	path_max_depth = 3,
	fzf_path_truncate_enabled = false,
	fzf_path_max_depth = 5,
	path_truncate_long_names_enabled = false,
	fzf_path_truncate_long_names_enabled = false,
	path_max_folder_name_length = 20,
	fzf_path_max_folder_name_length = 20,
	history_size = 10,
	history_fzf_path_truncate_enabled = false,
	history_fzf_path_max_depth = 5,
	history_fzf_path_truncate_long_names_enabled = false,
	history_fzf_path_max_folder_name_length = 30,
})

require("git"):setup()

require("starship"):setup()

require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})

require("sshfs"):setup({
	mount_dir = "/tmp/" .. os.getenv("USER") .. "/mnt",
	sshfs_options = {
		"reconnect",
		"compression=yes",
		"cache_timeout=10",
		"ConnectTimeout=10",
		"dir_cache=yes",
		"dcache_timeout=20",
	},
})

require("mux"):setup({
	aliases = {
		eza_tree_1 = {
			previewer = "piper",
			args = {
				'LS_COLORS="ex=32" eza --oneline --tree --level 1 --color=always --icons=always --group-directories-first --no-quotes "$1"',
			},
		},
		eza_tree_2 = {
			previewer = "piper",
			args = {
				'LS_COLORS="ex=32" eza --oneline --tree --level 2 --color=always --icons=always --group-directories-first --no-quotes "$1"',
			},
		},
		eza_tree_3 = {
			previewer = "piper",
			args = {
				'LS_COLORS="ex=32" eza --oneline --tree --level 3 --color=always --icons=always --group-directories-first --no-quotes "$1"',
			},
		},
	},
})
