-- AI Coding, Vim Style
-- https://github.com/olimorris/codecompanion.nvim

local _cached_api_key = {}

local function get_api_key(adapter)
  local key = _cached_api_key[adapter]
  if key and #key > 0 then return key end

  local env_var = adapter:upper() .. '_API_KEY'
  local file_name = string.format('.%s_api_key', adapter)
  key = os.getenv(env_var)
  if key and #key > 0 then
    _cached_api_key[adapter] = key
  else
    local home = (vim.uv or vim.loop).os_homedir()
    if home then
      local path = vim.fs.joinpath(home, file_name)
      local file = io.open(path, 'r')
      if file then
        local line = file:read '*l'
        file:close()
        if line and #line > 0 then
          local decoded = vim.base64.decode(line)
          if decoded then _cached_api_key[adapter] = (decoded:gsub('%s', '')) end
        end
      end
    end
  end

  key = _cached_api_key[adapter]
  if not (key and #key > 0) then
    vim.notify('No valid api key found from environment or file', vim.log.levels.WARN)

    _cached_api_key[adapter] = ''
  end

  return key
end

local acp_adapters = {
  opencode = function()
    return require('codecompanion.adapters').extend('kimi_cli', {
      name = 'opencode',
      formatted_name = 'OpenCode',
      commands = {
        default = {
          'opencode',
          'acp',
        },
      },
    })
  end,
}

vim.pack.add {
  'https://github.com/olimorris/codecompanion.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/lalitmee/codecompanion-spinners.nvim',
  'https://github.com/j-hui/fidget.nvim',
}

require('codecompanion').setup {
  prompt_library = {
    markdown = {
      dirs = {
        vim.fs.joinpath(vim.fn.stdpath 'config', '/codecompanion/prompts'),
      },
    },
  },
  adapters = {
    acp = acp_adapters,
  },
  -- NOTE: The log_level is in `opts.opts`
  opts = {
    prompt_library = {
      markdown = {
        dirs = {
          vim.fs.joinpath(vim.fn.stdpath 'config', '/codecompanion/prompts'),
        },
      },
    },
    interactions = {
      chat = {
        adapter = 'opencode',
      },
    },
    adapters = {
      acp = acp_adapters,
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = 'DEBUG', -- or "TRACE"
    },
    extensions = {
      spinner = {
        opts = {
          style = 'fidget',
        },
      },
    },
    log_level = 'DEBUG', -- or "TRACE"
  },
  extensions = {
    spinner = {
      opts = {
        style = 'fidget',
      },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<cmd>CodeCompanionActions<CR>', { desc = 'Open [C]odeCompanion [A]ction palette' })
vim.keymap.set({ 'n', 'v' }, '<leader>cc', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'Open [C]odeCompanion [C]hat panel' })
vim.keymap.set({ 'n', 'v' }, '<leader>ci', ':CodeCompanion', { desc = 'Open [C]odeCompanion [I]nline assistant' })
