return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        '<leader>ha',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon [A]dd file',
      },
      {
        '<leader>ho',
        function()
          local harpoon = require 'harpoon'
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = '[H]arpoon [O]pen',
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        '<leader>' .. i,
        function()
          require('harpoon'):list():select(i)
        end,
        desc = '[H]arpoon file ' .. i,
      })
    end
    return keys
  end,
}

-- return {
--   'ThePrimeagen/harpoon',
--   branch = 'harpoon2',
--   dependencies = { 'nvim-lua/plenary.nvim' },
--   config = function()
--     local harpoon = require 'harpoon'
--
--     harpoon:setup()
--
--     -- Basic mappings
--     vim.keymap.set('n', '<leader>ha', function()
--       harpoon:list():add()
--     end, { desc = '[H]arpoon [A]dd file' })
--
--     vim.keymap.set('n', '<leader>ho', function()
--       harpoon.ui:toggle_quick_menu(harpoon:list())
--     end, { desc = '[H]arpoon [O]pen menu' })
--
--     -- Quick numeric selection outside menu
--     for i = 1, 9 do
--       vim.keymap.set('n', '<leader>' .. i, function()
--         harpoon:list():select(i)
--       end, { desc = '[H]arpoon file [' .. i .. ']' })
--     end
--
--     -- Quick actions INSIDE the Harpoon quick menu
--     vim.api.nvim_create_autocmd('FileType', {
--       pattern = 'harpoon',
--       callback = function()
--         local bufmap = function(lhs, rhs, desc)
--           vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
--         end
--
--         -- Numeric file selection
--         for i = 1, 9 do
--           bufmap(tostring(i), function()
--             harpoon:list():select(i)
--           end, 'Harpoon select' .. i)
--         end
--
--         -- -- Quickly remove a file with 'dd'
--         -- bufmap('d', function()
--         --   local idx = vim.fn.line '.'
--         --   harpoon:list():remove_at(idx)
--         --   harpoon.ui:toggle_quick_menu(harpoon:list())
--         --   harpoon.ui:toggle_quick_menu(harpoon:list()) -- refresh menu
--         -- end, 'Harpoon remove current')
--         --
--         -- -- Move file to top with 'tt'
--         -- bufmap('t', function()
--         --   local idx = vim.fn.line '.'
--         --   local item = harpoon:list().items[idx]
--         --   harpoon:list():remove_at(idx)
--         --   harpoon:list():prepend(item)
--         --   harpoon.ui:toggle_quick_menu(harpoon:list())
--         --   harpoon.ui:toggle_quick_menu(harpoon:list())
--         -- end, 'Harpoon move to top')
--
--         -- -- Move file to a specific position with '<leader>m<number>'
--         -- for i = 1, 9 do
--         --   bufmap('<leader>m' .. i, function()
--         --     local idx = vim.fn.line('.')
--         --     local item = list.items[idx]
--         --
--         --     -- Remove the item first
--         --     list:remove_at(idx)
--         --
--         --     -- Shift items manually to insert at a specific position
--         --     table.insert(list.items, i, item)
--         --
--         --     -- Update internal length
--         --     list._length = #list.items
--         --
--         --     harpoon.ui:toggle_quick_menu(list)
--         --     harpoon.ui:toggle_quick_menu(list)
--         --   end, 'Harpoon move item to position ' .. i)
--         -- end
--       end,
--     })
--   end,
-- }
