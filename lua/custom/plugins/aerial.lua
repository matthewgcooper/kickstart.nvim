return {
  'stevearc/aerial.nvim',
  opts = function()
    local opts = {
      attach_mode = 'global',
      close_automatic_events = { 'unfocus', 'switch_buffer' },
      backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      show_guides = true,
      layout = {
        resize_to_content = false,
        win_opts = {
          winhl = 'Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB',
          signcolumn = 'yes',
          statuscolumn = ' ',
        },
      },
      -- stylua: ignore
      guides = {
        mid_item   = "├╴",
        last_item  = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ['<CR>'] = {
          callback = function()
            require('aerial').select()
            require('aerial').close()
          end,
          desc = 'Jump to Symbol',
          nowait = true,
        },
      },
    }
    return opts
  end,
  keys = {
    { '<leader>cs', '<cmd>AerialToggle<cr>', desc = 'Aerial (Symbols)' },
  },
}
