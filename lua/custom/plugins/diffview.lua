-- lua/plugins/diffview.lua
--------------------------------------------------------------------------------
-- Helper ── find our "parent" branch (the one we rebased from) and open a diff
--------------------------------------------------------------------------------
local function guess_parent_branch()
  -------------------------------------------------------------------------------
  -- 1. Search reflog for:   rebase (start): checkout <branch>
  -------------------------------------------------------------------------------
  for _, l in ipairs(vim.fn.systemlist 'git reflog --no-abbrev --pretty=%gs') do
    local parent = l:match 'rebase %(start%): checkout (.+)'
    if parent then
      return parent
    end
  end

  -------------------------------------------------------------------------------
  -- 2. Fallback: look for the last "checkout: moving from <X> to <current>"
  -------------------------------------------------------------------------------
  local current = vim.trim(vim.fn.system 'git rev-parse --abbrev-ref HEAD')
  local patt = ('checkout: moving from%s+([^%s]+)%s+to%s+' .. current):format('%s', '%s')
  for _, l in ipairs(vim.fn.systemlist 'git reflog --no-abbrev --pretty=%gs') do
    local parent = l:match(patt)
    if parent then
      return parent
    end
  end
end

local function diff_against_parent()
  local parent = guess_parent_branch()

  -- 3. If still unknown, ask the user
  if not parent or parent == '' then
    parent = vim.fn.input('Diff against which branch? ', 'origin/', 'file')
    if parent == '' then
      vim.notify('No branch specified; aborting Diffview', vim.log.levels.WARN)
      return
    end
  end

  -- 4. Open a symmetric diff and include any unstaged edits
  vim.cmd(('DiffviewOpen %s...HEAD --imply-local'):format(parent))
end

--------------------------------------------------------------------------------
-- Plugin spec
--------------------------------------------------------------------------------
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  dependencies = { 'nvim-lua/plenary.nvim' },

  -- stylua: ignore
  keys = {
    { "<leader>gb", diff_against_parent,               desc = "Diff – parent…HEAD (live)" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",           desc = "Diff – HEAD ↔ index"       },
    { "<leader>gD", "<cmd>DiffviewOpen origin/HEAD<cr>", desc = "Diff – HEAD ↔ origin/HEAD" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",  desc = "File history (this file)"  },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",    desc = "Repo history"              },
    { "<leader>gq", "<cmd>DiffviewClose<cr>",          desc = "Close Diffview"            },
  },

  opts = {
    enhanced_diff_hl = true,
    use_icons = vim.g.have_nerd_font == true,

    view = {
      merge_tool = { layout = 'diff3_mixed', disable_diagnostics = true },
    },

    file_panel = {
      listing_style = 'tree',
      win_config = { position = 'left', width = 35 },
    },
  },
}
