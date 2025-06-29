return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    view = {
      width = 30,
      side = 'left',
      preserve_window_proportions = true,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
    },
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
  },
}
