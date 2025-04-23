return {
  'nvim-pack/nvim-spectre',
  config = function()
    require('spectre').setup {
      mapping = {
        ['q'] = {
          map = 'q',
          cmd = '<cmd>lua require("spectre").close()<CR>',
          desc = 'quit',
        },
      },
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = 'Toggle Spectre',
      }),
      vim.keymap.set('n', '<leader>rw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = 'Search current word',
      }),
      vim.keymap.set('v', '<leader>rw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = 'Search current word',
      }),
      -- vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      --   desc = 'Search on current file',
      -- }),
    }
  end,
}
