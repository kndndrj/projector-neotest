local NeotestOutput = require("projector_neotest.output")

local M = {}

---@class NeotestOutputBuilder: OutputBuilder
---@field private group boolean
---@field private include_debug boolean
M.OutputBuilder = {}

---@param opts? { group: boolean, include_debug: boolean }
---@return NeotestOutputBuilder
function M.OutputBuilder:new(opts)
  opts = opts or {}
  local o = {
    group = opts.group or false,
    include_debug = opts.include_debug or false,
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- build a new output
---@return NeotestOutput
function M.OutputBuilder:build()
  return NeotestOutput:new()
end

---@return task_mode mode
function M.OutputBuilder:mode_name()
  return "neotest"
end

---@param configuration task_configuration
---@return boolean
function M.OutputBuilder:validate(configuration)
  if configuration and configuration.neotest_mode then
    return true
  end
  return false
end

---@param _ task_configuration[]
---@return task_configuration[]
function M.OutputBuilder:preprocess(_)
  ---@type task_configuration[]
  local configs = {
    {
      name = "Run Current Test",
      neotest_mode = "run_current",
    },
    {
      name = "Run Current File Tests",
      neotest_mode = "run_file",
    },
  }

  if self.include_debug then
    table.insert(configs, {
      name = "Debug Current Test",
      neotest_mode = "debug_current",
    })
    table.insert(configs, {
      name = "Debug Current File Tests",
      neotest_mode = "debug_file",
    })
  end

  -- group tasks if specified
  if self.group then
    return {
      {
        name = "Neotest",
        children = configs,
      },
    }
  end

  return configs
end

return M
