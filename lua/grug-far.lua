local opts = require("grug-far/opts")
local farBuffer = require("grug-far/farBuffer")

local M = {}

local options = nil
local namespace = nil
-- TODO (sbadragan): do we need some sort of health check?
function M.setup(user_opts)
  options = opts.with_defaults(user_opts or {})
  namespace = vim.api.nvim_create_namespace('grug-far.nvim')
  vim.api.nvim_create_user_command("GrugFar", M.grug_far, {})
end

local function is_configured()
  return options ~= nil
end

local function createContext()
  return {
    options = options,
    namespace = namespace,
    extmarkIds = {},
    state = {
      isFirstRender = true,
      inputs = {}
    }
  }
end

local function createWindow()
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()

  -- TODO (sbadragan): make this configurable?
  -- vim.api.nvim_win_set_option(win, 'number', false)
  -- vim.api.nvim_win_set_option(win, 'relativenumber', false)

  return win
end

function M.grug_far()
  if not is_configured() then
    print('Please call require("grug-far").setup(...) before executing require("grug-far").grug_far(...)!')
    return
  end

  local context = createContext()
  local win = createWindow()
  farBuffer.createBuffer(win, context)
end

return M
