local api = {
  sol = {
    main = {
      get_elapsed_time = {
        description = "get the elapsed time since the engine started to run",
        type = "function"
      }
    }
  }  
}--TODO : a lot more!



local interpreter = {
  name = "Solarus",
  description = "An ARPG Game Engine",
  api = {"baselib", "solarus"},
  frun = function(self,wfilename,rundebug)
    local projdir = self:fworkdir(wfilename)
    ide:Print(string.format("Solarus started with project path %s and debug set to %s", projdir,rundebug and "true" or "false"))
    local debuggerPath = ide:GetRootPath("lualibs/mobdebug/mobdebug")
    local engine_cmd = "solarus-run" --TODO take windows (and mac) into account
    local cmd = string.format("%s %s",engine_cmd,projdir)
    if rundebug then
      --adapt command to run debug connection
      local code = string.format("local path=package.path;package.path='?.lua;'..path;require('%s').start();package.path=path;",debuggerPath)
      cmd = string.format('%s -s="%s" %s',engine_cmd,code,projdir)
    end
    CommandLineRun(cmd,projdir,true,false)
    ide:GetDebugger():Run()
  end,
  hasdebugger = true
}

return {
  name = "Solarus",
  description = "An ARPG Game Engine",
  author = "stdgregwar",
  version = 1.6,
  
  onRegister = function(self)
    ide:AddInterpreter("Solarus", interpreter)
  end,
  
  onUnRegister = function(self)
    ide:RemoveInterpreter("Solarus")
  end
}
