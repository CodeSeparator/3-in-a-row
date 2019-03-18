--Displays the header and field contents
function Printall(str)
	os.execute("cls")
	local lenside = math.sqrt(string.len(str))
	print("Enter the format string 'mNNc'. X is a digit, c is a symbol l, r, d or u")
	local head = "    "
	for i=1,lenside,1 do
		head = head..(i-1)
	end
	local dash = "----"
	for i=1,lenside do
		dash = dash.."-"
	end
	print(head)
	print(dash)

	for i=0, (lenside-1) do
		local prefix = i.." | "
		print(prefix..string.sub(str, lenside*i+1, lenside*(i+1)))
	end
end
--Generates a string field
function GenerateList(cristalls, lenside)
	local allcr = ""
	i = 0
	math.randomseed(os.time())
	while i < lenside^2 do
		local rnd = math.random(1, string.len(cristalls))
		local adding = string.sub(cristalls, rnd, rnd)
		allcr = allcr .. adding
		i = i + 1
	end

	return(allcr)
end
--User data entry
function Userread()
	local str = io.read()
	if(string.len(str) == 1 and string.sub(str, 1, 1) == 'q') then os.exit()
	end
	if(
		string.sub(str, 1, 1) == 'm' and
		string.len(str) == 4 and
		string.byte(str, 2) <= 57 and
		string.byte(str, 3) <= 57 and
		string.byte(str, 2) >= 48 and
		string.byte(str, 3) >= 48 and
		(string.find(str, 'l') or
			string.find(str, 'r') or
			string.find(str, 'u') or
			string.find(str, 'd')) or
		(string.len(str) == 1 and string.sub(str, 1, 1) == 'q')
	)
	then
		return str
	else return nil
	end
end
--Stroke check
function Movetrue(str, strfull)-- strfull - это строка-игровое поле
	local lenside = math.sqrt(string.len(strfull))
	if(str == nil) then return 0,0 end
	local x = tonumber(string.sub(str, 2, 2))
	local y = tonumber(string.sub(str, 3, 3))
	local num = lenside*y + x
	local move = string.sub(str, 4, 4)
	local temp = 0
	if(
		(move == 'd' and y == lenside-1) or
		(move == 'u' and y == 0) or
		(move == 'l' and x == 0) or
		(move == 'r' and x == lenside-1))
	then
		temp = 0
	elseif (move == 'd') then temp = lenside
	elseif (move == 'u') then temp = -lenside
	elseif (move == 'l') then temp = -1
	elseif (move == 'r') then temp = 1
	else temp = 0
	end

	return num, temp

end
--Move
function Moveto(from, to)
	local a = math.min(from, from+to)
	local b = math.max(from, from+to)
	local fi = string.sub(alllist, a+1, a+1)
	local se = string.sub(alllist, b+1, b+1)  
	if(a == b) then return alllist end
	local newlist =
	(
		string.sub(alllist, 1, math.min( from+1, from+1 + to)-1)..
		se..
		string.sub(alllist, math.min( from+1, from+1 + to)+1, math.max( from+1, from+1 + to)-1)..
		fi..
		string.sub(alllist, math.max( from+1, from+1 + to)+1, string.len(alllist) )
	)
	return newlist
end
--check for triples
function Checkstr(str)
	local lenside = math.sqrt(string.len(str))
	local tempi, tempj, tempk
	local res = false
	for i=1, string.len(str)-2, 1 do
		tempi = string.sub(str,i,i)
		tempj = string.sub(str,i+1,i+1)
		tempk = string.sub(str,i+2,i+2)
		res = res or (tempi == tempj and tempj == tempk and i ~= lenside and i ~= lenside-1)
		i=i+1
	end
	for i=1, string.len(str)-2*lenside, 1 do
		tempi = string.sub(str,i,i)
		tempj = string.sub(str,i+lenside,i+lenside)
		tempk = string.sub(str,i+2*lenside,i+2*lenside)
		res = res or (tempi == tempj and tempj == tempk)
		i=i+1
	end
	return res
end
--Finding 3,4,5
function Find(str)
	local list1 = {}
	local lenside = math.sqrt(string.len(str))
	local tempi, tempj, tempk
	for i=1, string.len(str)-2, 1 do
		tempi = string.sub(str,i,i)
		tempj = string.sub(str,i+1,i+1)
		tempk = string.sub(str,i+2,i+2)
		if(tempi == tempj and tempj == tempk and i%lenside ~= 0 and i%lenside ~= lenside-1) then
			table.insert(list1, i)
			table.insert(list1, i+1)
			table.insert(list1, i+2)
		end
	end
	for i=1, string.len(str)-2*lenside, 1 do
		tempi = string.sub(str,i,i)
		tempj = string.sub(str,i+lenside,i+lenside)
		tempk = string.sub(str,i+2*lenside,i+2*lenside)
		if(tempi == tempj and tempj == tempk) then
			table.insert(list1, i)
			table.insert(list1, i+lenside)
			table.insert(list1, i+2*lenside)
		end
	end
	if(#list1 == 0) then
		return nil
	end
	table.sort(list1)
	list1 = Filter(list1)
	return list1
end
--Deleting characters
function Del(str, list)
	if(list == nil) then return str end
	temp = ""

	for i=1, string.len(str) do
		local flag = true
		for j=1, #list do
			if(i == tonumber(list[j])) then
				temp = temp.." "
				flag = false
			end
		end
		if(flag) then
			temp = temp..string.sub(str, i, i)
		end
	end
	x = temp
	return x
end
--Top dumping
function Damping(str, cristalls)
	local lenside = math.sqrt(string.len(str))
	local A = {}
	for k=1, string.len(str),1 do
		table.insert(A, string.sub(str, k, k))
	end
	local j=1
	local str1 = ""
	math.randomseed(os.time())
	for i=1, lenside,1 do
		local flag = true
		local x = 1

		while flag do


			if(A[i+(x-1)*lenside] == " ") then
				table.remove(A,i+(x-1)*lenside)
				local rnd = math.random(1, string.len(cristalls))
				local adding = string.sub(cristalls, rnd, rnd)
				table.insert(A, i+(x-1)*lenside, adding)
				x = x + 1
			else flag = false
			end
		end
	end

	str1 = table.concat(A, str1)

	return str1
end
--Shift down
function Fillempty(str)
	local lenside = math.sqrt(string.len(str))
	local A = {}
	local str1
	for i=1, string.len(str) do
		table.insert(A, string.sub(str, i, i))
	end
	for i=#A, 1, -1 do
		if(A[i] == " " and i>lenside) then
			local temp = A[i-lenside]
			A[i-lenside] = " "
			A[i] = temp
		end
	end
	str1 = table.concat(A, str1)
	return str1

end
--Superfluous filtering
function Filter(list)
	newlist = {}
	local i=1
	while list[i] ~= nil do
		if(list[i] ~= newlist[#newlist]) then
			table.insert(newlist, list[i])
		end
		i = i+1
	end
	return newlist
end
--Check for voids
function Empty(str)
	res = false
	for i=1,string.len(str),1 do
		if(string.sub(str, i, i) == " ") then
			res = true
			return res
		end
	end
	return res
end
--Mixing
function Mix(str)
	local A = {}
	local str1
	for i=1, string.len(str) do
		table.insert(A, string.sub(str, i, i))
	end
	math.randomseed(os.time())
	for i=1,#A,1 do
		local rnd = math.random(1, #A)
		local x = A[i]
		local y = A[rnd]
		table.remove(A, i)
		table.insert(A, i, y)
		table.remove(A, rnd)
		table.insert(A, rnd, x)
	end
	str1 = table.concat(A, str1)
	return str1
end
--Check for potential triples (n^2 - 1)
function CheckPot(str)
	local res = true
	local lenside = math.sqrt(string.len(str))
	local A = {}
	local str1
	for i=1, string.len(str) do
		table.insert(A, string.sub(str, i, i))
	end
	for i=1,#A,1 do
		if(i%lenside ~= 0) then
			local x = A[i]
			local y = A[i+1]
			table.remove(A, i)
			table.insert(A, i, y)
			table.remove(A, i+1)
			table.insert(A, i+1, x)
			res = Checkstr(str)
		end
		if(res) then
			return res
		else
			table.remove(A, i)
			table.insert(A, i, y)
			table.remove(A, i+1)
			table.insert(A, i+1, x)
		end
		if(i < #A-lenside) then
			y = A[i+lenside]
			table.remove(A, i)
			table.insert(A, i, y)
			table.remove(A, i+lenside)
			table.insert(A, i+lenside, x)
			res = Checkstr(str)
			if(res) then
				return res
			else
				table.remove(A, i)
				table.insert(A, i, y)
				table.remove(A, i+lenside)
				table.insert(A, i+lenside, x)
			end
		end
	end
	return res
end
--Delay
function Sleep(ms) 
	local b = os.clock() * 1000 
	while os.clock() * 1000 - b <= ms do end 
end 

--Wrapping functions
--Setting initial parameters and initializing
function Init()
	alllist = "000"
	lenside = 10
	chars = "ABCDEF"
	sleeptime = 500
	while Checkstr(alllist) do
		alllist = GenerateList(chars, lenside)
	end
	Dump()--First frame
end
--Mix
function Mix()
	while(CheckPot(alllist)) do
		alllist = Mix(alllist)
	end
end
--Moving
function Move()
	from, to = Movetrue(Userread(), alllist)
	newlist = Moveto(from, to)
end
--Actions
function Tick()
	if Checkstr(newlist) then
		alllist = newlist
		Dump()--Swapped
		list1 = Find(alllist)
		alllist = Del(alllist,list1)
		Dump()--Deleted characters output
		while (list1) do
			while(Empty(alllist)) do
				alllist = Damping(alllist, chars)
				Sleep(sleeptime)--Delay
				alllist = Fillempty(alllist)
				Dump()--Output after shifting down
				Sleep(sleeptime)--Delay
			end
			list1 = Find(alllist)
			alllist = Del(alllist,list1)
			Dump()
		end
		Mix()
	end
end
--Display
function Dump()
	Printall(alllist)
end
--------------------

--Final version

Init()
while(true) do
	Move()
	Tick()
end





--Работа программы (исходный вариант)
--[[
alllist = "000"
lenside = 6
chars = "ABCDEF"
sleeptime = 500
while Checkstr(alllist) do
	alllist = GenerateList(chars, lenside)
end
Printall(alllist)--Первый фрейм
local move = Userread()
while(move ~= 'q') do
	from, to = Movetrue(move, alllist)
	newlist = Moveto(from, to)
	if Checkstr(newlist) then
		alllist = newlist
		Printall(alllist)--Поменяли местами
		list1 = Find(alllist)
		alllist = Del(alllist,list1)
		Printall(alllist)--Вывод со стертыми символами
		while (list1) do
			while(Empty(alllist)) do
				alllist = Damping(alllist, chars)
				Sleep(sleeptime)--Задержка
				alllist = Fillempty(alllist)
				Printall(alllist)--Вывод после сдвига вниз
				Sleep(sleeptime)--Задержка
			end
			list1 = Find(alllist)
			alllist = Del(alllist,list1)
			Printall(alllist)
		end

		while(CheckPot(alllist)) do
			alllist = Mix(alllist)
		end
	end
	move = Userread()
end
--Выходим
os.exit()
]]