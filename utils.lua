local utils = {}

function utils.pprint(var, tostr)
	local duplicateTable = {}
    local rstr = ''
	local function realfunc(var, stack)
		local function myprint(...)
            rstr = rstr .. string.rep("\t",stack)
            for _, s in pairs({...}) do
                rstr = rstr .. s
            end
		end
		
		if type(var) ~= "table" then
            if type(var) == 'string' then
                myprint(' "'..tostring(var)..'" ')
            else
                myprint(tostring(var))
            end
		else
			--duplicate detect
			if duplicateTable[var] then
				myprint(tostring(var))
				return
			else
				duplicateTable[var] = 1
			end
			--print data
			myprint(tostring(var), "\n")
            if var.__pprint and type(var.__pprint)=='function' then --把日志按照table返回(每行一个元素)
                local tstrs = var:__pprint()
                for _, s in pairs(tstrs) do myprint(s,'\n') end
            else
                myprint("{")
                local nilflag = true
                for k,v in pairs(var) do
                    if nilflag then
                        rstr = rstr .. '\n'
                        nilflag = false
                    end
                    realfunc(k, stack+1)
                    if type(v) == "table" and next(v) ~= nil then
                        rstr = rstr .. '=>\n'
                        realfunc(v, stack+2)
                    elseif type(v) ~= "table" then
                        if type(v) == 'string' then
                            rstr = rstr .. '=>' .. ' "'..tostring(v)..'" '
                        else
                            rstr = rstr .. '=>' .. tostring(v)
                        end
                    else
                        rstr = rstr .. '=>' .. tostring(v) .. '{}'
                    end
                    rstr = rstr .. '\n'
                end
                myprint("}")
            end
		end
	end
	realfunc(var, 0)
    rstr = rstr .. '\n'
    if tostr then return rstr else io.write(rstr) end
end

function utils.pprintTest()
    local d = {a=1, b=2, c={1,2,3,4}}
    local tmpd = {x=1,y={m=1,n=2}}
    d[tmpd] = {1,2,3,4,5,6,7,8,9,{"hello","world"}}
    d["hello"] = {}
    d["dup"] = d
    d[d] = "dup2"
    d.xx = {a=111, b=22,
            __pprint = function(self)
                local t = {}
                table.insert(t, string.format('a=%d',self.a))
                table.insert(t, string.format('b=%d',self.b))
                return t
            end
            }
    print(utils.pprint(d, true))
end

return utils
