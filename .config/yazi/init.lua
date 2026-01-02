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

require("bookmarks"):setup({
	last_directory = { enable = true, persist = true },
	persist = "vim",
	desc_format = "full",
	file_pick_mode = "hover",
	notify = {
		enable = true,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
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
