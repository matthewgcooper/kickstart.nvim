return {
  'folke/snacks.nvim',
  lazy = false,
  opts = {
    input = { enabled = true },
    notifier = { enabled = true },
    indent = { enabled = true },
    dashboard = {
      sections = {
        { section = 'header' },
        { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
      },
    },
  },
  lazygit = {
    vim.keymap.set('n', '<leader>gg', function()
      Snacks.lazygit()
    end, { desc = '[G]oto Lazy[G]it' }),
  },
  -- stylua: ignore
  keys = {
    { "<leader>nh", function()
      if Snacks.config.picker and Snacks.config.picker.enabled then
        Snacks.picker.notifications()
      else
        Snacks.notifier.show_history()
      end
    end, desc = "[N]otification [H]istory" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "[N]otification [D]ismiss" },
  },
}
