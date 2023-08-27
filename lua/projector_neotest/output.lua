---@type boolean, neotest
local has_neotest, neotest = pcall(require, "neotest")

---@class NeotestOutput: Output
---@field state output_status
---@field current_run_id? string
local NeotestOutput = {}

---@return NeotestOutput
function NeotestOutput:new()
  local o = {
    state = "hidden",
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

---@return output_status
function NeotestOutput:status()
  return self.state or "inactive"
end

---@param configuration task_configuration
---@param callback fun(success: boolean)
function NeotestOutput:init(configuration, callback)
  if not has_neotest then
    return
  end

  self.state = "hidden"

  if configuration.neotest_mode == "run_current" then
    neotest.run.run()
  elseif configuration.neotest_mode == "run_file" then
    neotest.run.run(vim.fn.expand("%"))
  elseif configuration.neotest_mode == "debug_current" then
    neotest.run.run { strategy = "dap" }
  elseif configuration.neotest_mode == "debug_file" then
    neotest.run.run { vim.fn.expand("%"), strategy = "dap" }
  end

  -- run the config
  neotest.run.run()

  callback(true)

  self.current_run_id = neotest.run.get_last_run()
end

function NeotestOutput:show()
  if not has_neotest then
    return
  end
  neotest.summary.open()
  neotest.output_panel.open()
  self.state = "visible"
end

function NeotestOutput:hide()
  if not has_neotest then
    return
  end
  neotest.summary.close()
  neotest.output_panel.close()
  self.state = "hidden"
end

function NeotestOutput:kill()
  if not has_neotest then
    return
  end
  neotest.summary.close()
  neotest.output_panel.close()

  if self.current_run_id then
    neotest.run.stop(self.current_run_id)
  end

  self.state = "inactive"
end

return NeotestOutput
