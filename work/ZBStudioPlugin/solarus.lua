local api = {
  sol = {
    type = "lib",
    description = "Solarus library",
    childs = {
      main = {
        type = "lib",
        description = "Main Solarus library, ...",
        childs = {
          get_elapsed_time = {
            description = "get the elapsed time since the engine started to run",
            args = "()",
            returns = "(time_ms : number)",
            type = "function"
          }
        }
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
    
    local debuggerPath = ide:GetRootPath("lualibs/mobdebug/?.lua")
    local packagePath = ide:GetPackagePath("?.lua")
    
    local engine_cmd = "solarus-run" --TODO take windows (and mac) into account
    local cmd = string.format("%s %s",engine_cmd,projdir)
    if rundebug then
      ide:GetDebugger():SetOptions({runstart = true})
      --adapt command to run debug connection
      local code = string.format(
[[local path=package.path;package.path='%s;%s;'..path;local mdb=require('mobdebug');require('solarus_pretty_printer');package.path=path;mdb.coro();mdb.start()]],
        debuggerPath,
        packagePath)
      cmd = string.format('%s -s="%s" %s',engine_cmd,code,projdir)
    end
    CommandLineRun(cmd,projdir,true,false)
  end,
  hasdebugger = true,
  takeparameters = true
}

return {
  name = "Solarus",
  description = "An ARPG Game Engine",
  author = "stdgregwar",
  version = 1.6,
  
  onRegister = function(self)
    ide:AddAPI("lua","solarus",api)
    ide:AddInterpreter("Solarus", interpreter)
  end,
  
  onUnRegister = function(self)
    ide:RemoveAPI("lua","solarus")
    ide:RemoveInterpreter("Solarus")
  end
}
