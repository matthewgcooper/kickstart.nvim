return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    enter_insert_mode_delayed = function(_)
      vim.defer_fn(function()
        vim.cmd 'startinsert!'
      end, 50)
    end

    require('toggleterm').setup {
      open_mapping = [[<C-]>]],
      on_open = enter_insert_mode_delayed,
    }

    local Terminal = require('toggleterm.terminal').Terminal
    julia_terminal = nil

    function julia_toggle()
      if not julia_terminal then
        julia_terminal = Terminal:new {
          cmd = 'cd ' .. vim.fn.getcwd() .. ' && julia -t auto --project',
          display_name = 'julia',
          hidden = true,
          direction = 'float',
          on_open = enter_insert_mode_delayed,
        }
      end
      julia_terminal:toggle()
    end

    function julia_restart()
      if julia_terminal then
        julia_terminal:shutdown()
      end
      vim.defer_fn(julia_toggle, 100)
    end

    function julia_send_line(code)
      local delay = 0
      if not julia_terminal then
        julia_toggle()
        delay = 500
      end
      julia_terminal:open()
      if string.find(code, '\n') ~= nil then
        code = 'begin\n' .. code .. '\nend'
      end
      vim.defer_fn(function()
        julia_terminal:send(code, false)
      end, delay)
    end

    function julia_send_selection()
      -- Use operator-pending mode to maintain the selection
      vim.api.nvim_feedkeys('"zy', 'x', false)

      -- Get the text from register z and remove trailing newline
      local code = vim.fn.getreg('z'):gsub('\n$', '')

      julia_send_line(code)
    end

    function julia_send_file()
      local filetype = vim.bo.filetype
      if filetype == 'julia' then
        local filename = vim.fn.expand '%:p'
        local command = string.format('include("%s")', filename)
        julia_send_line(command)
      else
        print 'Not a Julia file'
      end
    end

    vim.keymap.set({ 'n', 'i', 't', 'v' }, '<C-\\>', julia_toggle)
    vim.keymap.set({ 'n', 'v' }, '<leader>jo', julia_toggle, { desc = '[J]ulia [O]pen' })
    vim.keymap.set({ 'n', 'v' }, '<leader>jr', julia_restart, { desc = '[J]ulia [R]estart' })
    vim.keymap.set('n', '<leader>js', function()
      julia_send_line(vim.api.nvim_get_current_line())
    end, { desc = '[J]ulia [S]end line to REPL' })
    vim.keymap.set('n', '<leader>jS', function()
      julia_restart()
      julia_send_line(vim.api.nvim_get_current_line())
    end, { desc = '[J]ulia [S]end line to REPL (with restart)' })
    vim.keymap.set('v', '<leader>js', julia_send_selection, { desc = '[J]ulia [S]end selection to REPL' })
    vim.keymap.set('v', '<leader>jS', function()
      julia_restart()
      julia_send_selection()
    end, { desc = '[J]ulia [S]end selection to REPL (with restart)' })
    vim.keymap.set({ 'n', 'v' }, '<leader>jf', julia_send_file, { desc = '[J]ulia send [F]ile' })
    vim.keymap.set({ 'n', 'v' }, '<leader>jF', function()
      julia_restart()
      vim.defer_fn(julia_terminal:open(), 400)
      vim.defer_fn(julia_send_file, 500)
    end, { desc = '[J]ulia send [F]ile (with restart)' })
  end,
}
