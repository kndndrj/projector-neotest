local NeotestOutput = require("projector_neotest.output")

local M = {}

---@class NeotestOutputBuilder: OutputBuilder
---@field private hide_tasks boolean
---@field private include_debug boolean
M.OutputBuilder = {}

---@param opts? { hide_tasks: boolean, include_debug: boolean }
---@return NeotestOutputBuilder
function M.OutputBuilder:new(opts)
  opts = opts or {}
  local o = {
    hide_tasks = opts.hide_tasks or false,
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

---@param _ configuraiton_picks
---@return configuraiton_picks # picked configs
function M.OutputBuilder:preprocess(_)
  ---@type configuraiton_picks
  local configs = {}

  configs["__neotest_output_builder_task_id_1__"] = {
    scope = "global",
    group = "test",
    name = "Run Current Test",
    neotest_mode = "run_current",
  }
  configs["__neotest_output_builder_task_id_2__"] = {
    scope = "global",
    group = "test",
    name = "Run Current File Tests",
    neotest_mode = "run_file",
  }

  if self.include_debug then
    configs["__neotest_output_builder_task_id_3__"] = {
      scope = "global",
      group = "test",
      name = "Debug Current Test",
      neotest_mode = "debug_current",
    }
    configs["__neotest_output_builder_task_id_4__"] = {
      scope = "global",
      group = "test",
      name = "Debug Current File Tests",
      neotest_mode = "debug_file",
    }
  end

  -- hide tasks if specified
  if self.hide_tasks then
    for _, cfg in pairs(configs) do
      cfg.presentation = "menuhidden"
    end
  end

  return configs
end

return M
