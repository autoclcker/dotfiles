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

require("git"):setup()

require("starship"):setup()

require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
