-- load api from an external file
local api = dofile(ide:GetPackagePath('solarus_lua_api.lua'))

local function make_map_api(lua_file_path)
  local dat_path = lua_file_path:gsub('.lua','.dat')
  local entities = {}
  local function create_ent(ent_type,params)
    assert(type(params)=='table',"params should be a table")
    local name = params.name
    local x,y,l = params.x,params.y,params.layer
    if name then
      -- Name is exportable!
      entities[name] = {
        type = 'value',
        description = string.format("%s at <%d,%d,%d>",ent_type,x,y,l),
        valuetype = ent_type
      }
    end
  end
  
  local env_mt = {
    __index = function(t,k)
      return function(params)
        create_ent(k,params)
      end
    end
  }
  local env = setmetatable({},env_mt)
  local dat_func = loadfile(dat_path)
  if dat_func then
    setfenv(dat_func,env)
    -- generate entities
    dat_func()
  end
  return entities
end

local current_editor
local current_api
local function switch_editor(editor)
  if current_editor == editor then
    return
  end
  current_editor = editor
  if not editor then
    return
  end
  lua_file_path = ide:GetDocument(editor).filePath
  if lua_file_path and lua_file_path:match('/data/maps/') then
    local map_api = make_map_api(lua_file_path)
    current_api = map_api
    ide:AddAPI('lua','solarus_map',map_api)
  else
    if current_api then
      --ide:RemoveApi('lua','solarus_map')
      ide:AddAPI('lua','solarus_map',{}) --edit api to empty one
      current_api = nil
    end
  end
end

local interpreter = {
  name = "Solarus",
  description = "An ARPG Game Engine",
  api = {"baselib", "solarus","solarus_map"},
  frun = function(self,wfilename, rundebug)
    local projdir = self:fworkdir(wfilename)
    
    local debuggerPath = ide:GetRootPath("lualibs/mobdebug/?.lua")
    local packagePath = ide:GetPackagePath("?.lua")
    
    local engine_cmd = ide.solarus_path or "solarus-run" --TODO take windows (and mac) into account
    local cmd = string.format("%s %s",engine_cmd,projdir)
    if rundebug then
      ide:GetDebugger():SetOptions({runstart = true})
      --adapt command to run debug connection
      local code = string.format(
[=[local path=package.path;package.path=[[%s;%s;]]..path;local mdb=require('mobdebug');require('solarus_pretty_printer');package.path=path;mdb.coro();mdb.start()]=],
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
  
  onEditorFocusSet = function(self,editor)
    switch_editor(editor)
  end,
  
  onUnRegister = function(self)
    ide:RemoveAPI("lua","solarus")
    ide:RemoveInterpreter("Solarus")
  end
}
