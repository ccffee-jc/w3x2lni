package.path = package.path .. ';' .. arg[1] .. '\\src\\?.lua'
package.cpath = package.cpath .. ';' .. arg[1] .. '\\build\\?.dll'

require 'luabind'
require 'filesystem'
require 'utility'
local uni      = require 'unicode'
local w3x2txt  = require 'w3x2txt'

local root_dir = fs.path(uni.a2u(arg[1]))

local count = 0
local function remove_then_create_dir(dir)
	-- 将原来的目录改名后删除(否则之后创建同名目录时可能拒绝访问)
	count = count + 1
	local temp_dir = root_dir / ('temp' .. count .. os.time())
	if fs.exists(dir) then
		fs.rename(dir, temp_dir)
		fs.remove_all(temp_dir)
	end
	fs.create_directories(dir)
end

local function main()
	if not arg[2] then
		print('请将地图或文件夹拖动到bat中!')
		return
	end

	w3x2txt:init(root_dir)
	
	local input_path = fs.path(uni.a2u(arg[2]))
	if fs.is_directory(input_path) then
		local map_name = input_path:filename():string() .. '.w3x'
		local map_file = w3x2txt:create_map(io.load(input_path / 'war3map.w3i'))
		map_file:add_dir(input_path)
		map_file:save(input_path:parent_path() / map_name, function(name, file)
			return w3x2txt:lni2w3x(name, file)
		end)
	else
		local output_dir = root_dir / input_path:stem()
		remove_then_create_dir(output_dir)
		w3x2txt:unpack(input_path, function(name)
			return output_dir
		end)
	end
	
	print('[完毕]: 用时 ' .. os.clock() .. ' 秒') 
end

main()
