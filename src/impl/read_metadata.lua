local read_slk = require 'impl.read_slk'

local function read_metadata(file_name)
	local tbl = read_slk(file_name)
	if not tbl then
		return
	end
	local meta = {}
	local has_index = {}
	for k, v in pairs(tbl) do
		if meta[k] then
			print('meta表id重复', k)
		end
		meta[k] = v
		-- 进行部分预处理
		local name  = v['field']
		local index = v['index']
		if index and index >= 1 then
			has_index[name] = true
		end
	end
	for k, v in pairs(meta) do
		local name = v['field']
		if has_index[name] then
			v['_has_index'] = true
		end
	end
	return meta
end

return read_metadata
