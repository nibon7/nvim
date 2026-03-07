-- AI Coding, Vim Style
-- https://github.com/olimorris/codecompanion.nvim

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
  },
  opts = {
    interactions = {
      chat = {
        adapter = 'iflow_cli',
      },
      inline = {
        adapter = 'iflow',
      },
      cmd = {
        adapter = 'iflow',
      },
    },
    adapters = {
      acp = {
        iflow_cli = function()
          return require('codecompanion.adapters').extend('kimi_cli', {
            name = 'iflow_cli',
            formatted_name = 'iFlow cli',
            commands = {
              default = {
                'iflow',
                '--experimental-acp',
              },
            },
          })
        end,
      },
      http = {
        iflow = function()
          local _cached_key -- Cache for API key

          return require('codecompanion.adapters').extend('openai_compatible', {
            name = 'iflow',
            formatted_name = 'iFlow',
            env = {
              api_key = function()
                --- Load api_key from environment or config file
                --- @return string? api_key The api key if found, nil if not found
                --- @return string? error Error message if loading failed, nil if api key found successfully
                local function load_api_key()
                  -- First try environment variable
                  local api_key = os.getenv 'IFLOW_API_KEY'

                  if api_key then return api_key, nil end

                  -- Try reading from config file
                  local home = (vim.uv or vim.loop).os_homedir()
                  if not home then return nil, 'Failed to get home directory' end

                  local path = vim.fs.joinpath(home, '.iflow_api_key')

                  local file, msg = io.open(path, 'r')
                  if not file then return nil, msg or ('Failed to open ' .. path) end

                  local line = file:read '*l'

                  if not file:close() then vim.notify('Failed to close ' .. path, vim.log.levels.WARN) end

                  if line and #line > 0 then
                    local ok, decoded = pcall(vim.base64.decode, line)
                    if ok then
                      local trimmed = decoded:gsub('%s', '')
                      return trimmed, nil
                    else
                      return nil, 'Failed to decode api key'
                    end
                  end

                  return nil, 'No valid api key found from IFLOW_API_KEY env or ' .. path
                end

                -- Load API key if _cached_key is not initialized or empty
                if not _cached_key or _cached_key == '' then
                  local key, msg = load_api_key()
                  if key then
                    _cached_key = key
                  else
                    vim.notify(msg, vim.log.levels.ERROR)
                  end
                end

                return _cached_key or ''
              end,
              url = 'https://apis.iflow.cn',
            },
            temperature = {
              default = 0,
            },
            schema = {
              model = {
                default = 'qwen3-coder-plus',
                choices = {
                  ['deepseek-v3'] = {
                    formatted_name = 'DeepSeekV3-671B',
                  },
                  ['kimi-k2-0905'] = {
                    formatted_name = 'kimi-k2-0905',
                  },
                  ['qwen3-coder-plus'] = {
                    formatted_name = 'Qwen3-Coder-Plus',
                  },
                },
              },
            },
          })
        end,
      },
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = 'DEBUG', -- or "TRACE"
    },
  },
  keys = {
    { '<leader>cc', '<cmd>CodeCompanionChat<CR>', desc = 'Open [C]odeCompanion [c]hat panel' },
    { '<leader>ci', '<cmd>CodeCompanion<CR>', desc = 'Open [C]odeCompanion [i]nline assistant' },
    { '<leader>ci', ":'<,'>CodeCompanion<CR>", mode = 'v', desc = 'Open [C]odeCompanion [i]nline assistant' },
  },
}
