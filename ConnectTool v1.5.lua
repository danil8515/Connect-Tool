script_name('Connect Tool')
script_author('kopnev')
script_version('1.5')
script_version_number(3)

local sampev   = require 'lib.samp.events'
local inicfg   = require 'inicfg'
local imgui 	 = require 'imgui'
local encoding = require 'encoding'
local sha1     = require 'sha1'
local basexx   = require 'basexx'
local memory   = require 'memory'
local dlstatus = require('moonloader').download_status
local band     = bit.band


------------------------NEW-----------------
local imadd    = require 'imgui_addons'
local rkeys 	 = require 'rkeys'
local vkeys    = require 'vkeys'
local fa 			 = require 'faIcons'
----------------------------------------------


encoding.default = 'CP1251'
u8 = encoding.UTF8

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })



local informer  = imgui.ImBool(false)
local main_windows_state = imgui.ImBool(false)
local add_window_state  = imgui.ImBool(false)
local edit_window_state  = imgui.ImBool(false)
local delete_window_state  = imgui.ImBool(false)
local pass_window_state  = imgui.ImBool(false)
local code_window_state  = imgui.ImBool(false)
local server_window_state  = imgui.ImBool(false)
local gadd_window = imgui.ImBool(false)
local imguiDemo = imgui.ImBool(false)
local savepass = imgui.ImBuffer(64)
local savecode = imgui.ImBuffer(64)
local showpass = imgui.ImBool(false)
local showcode = imgui.ImBool(false)
local gauthcode = imgui.ImBuffer(64)


local sel = imgui.ImInt(0)
local selacc = -1
local gcode = 0
local xuypoimidlyachecgo = 0
local lacc = false


local rename = imgui.ImBuffer(64)
local reip = imgui.ImBuffer(16)
local report = imgui.ImBuffer(16)
local redelay = imgui.ImInt(1000)


local servers = {
    false,
}

local serv = {
	{
		projectname = "Arizona Role Play",
		title = "Arizona RP",
		list = {
			{
				name = "Phoenix",
				ip = "185.169.134.3",
				port = "7777"
			},
			{
				name = "Tucson",
				ip = "185.169.134.4",
				port = "7777"
			},
			{
				name = "Scottdale",
				ip = "185.169.134.43",
				port = "7777"
			},
			{
				name = "Chandler",
				ip = "185.169.134.44",
				port = "7777"
			},
			{
				name = "Brainburg",
			  ip = "185.169.134.45",
				port = "7777"
			},
			{
				name = "Saint Rose",
			  ip = "185.169.134.5",
				port = "7777"
			},
			{
				name = "Mesa",
			  ip = "185.169.134.59",
				port = "7777"
			},
			{
				name = "Red-Rock",
			  ip = "185.169.134.61",
				port = "7777"
			},
			{
				name = "Yuma",
			  ip = "185.169.134.107",
				port = "7777"
			},
		},
	},

	{
		projectname = "Advance Role Play",
		title = "Advance RP",
		list = {
			{
				name = "Red",
				ip = "5.254.104.131",
				port = "7777",
			},
			{
				name = "Green",
				ip = "5.254.104.132",
				port = "7777",
			},
			{
				name = "Yellow",
				ip = "5.254.104.133",
				port = "7777",
			},
			{
				name = "Orange",
				ip = "5.254.104.134",
				port = "7777",
			},
			{
				name = "Blue",
				ip = "5.254.104.135",
				port = "7777",
			},
			{
				name = "White",
				ip = "5.254.104.136",
				port = "7777",
			},
			{
				name = "Silver",
				ip = "5.254.104.137",
				port = "7777",
			},
			{
				name = "Purple",
				ip = "5.254.104.138",
				port = "7777",
			},
			{
				name = "Chocolate",
				ip = "5.254.104.139",
				port = "7777",
			},
		},
	},

	{
		projectname = "Diamond Role Play", -- �������� �������
		title = "Diamond RP",              -- ����������� ��������
		list = {        									 -- ������� �������
			{
				name = 'Emerald',
				ip = '194.61.44.61',
				port = "7777",
			},
			{
				name = 'Radiant',
				ip = '5.254.123.3',
				port = "7777",
			},
			{
				name = 'Trilliant',
				ip = '5.254.123.4',
				port = "7777",
			},
			{
				name = 'Crystal',
				ip = '5.254.123.4',
				port = "7777",
			},
			{
				name = 'Sapphire',
				ip = '5.254.123.6',
				port = "7777",
			},
			{
				name = 'Onyx',
				ip = '5.254.105.202',
				port = "7777",
			},
			{
				name = 'Amber',
				ip = '194.61.44.67',
				port = "7777",
			},
			{
				name = 'Quartz',
				ip = '5.254.105.204',
				port = "7777",
			},
		},
	},


	{
 		projectname = "Evolve Role Play", -- �������� �������
 		title = "Evolve RP",              -- ����������� ��������
 		list = {        									 -- ������� �������
				{
					name = 'First',
					ip = '185.169.134.67',
					port = "7777",
				},
				{
					name = 'Second',
					ip = '185.169.134.68',
					port = "7777",
				},
				{
					name = 'Third',
					ip = '185.169.134.91',
					port = "7777",
				}
 		},
 	},

	{
 		projectname = "Monser DeathMatch", -- �������� �������
 		title = "Monser DM",              -- ����������� ��������
 		list = {        									 -- ������� �������
				{
					name = 'One',
					ip = '176.32.37.37',
					port = "7777",
				},
				{
					name = 'Two',
					ip = '176.32.39.185',
					port = "7777",
				},
				{
					name = 'Three',
					ip = '176.32.36.229',
					port = "7777",
				}
 		},
 	},


	{
 		projectname = "Trinity GTA", -- �������� �������
 		title = "Trinity GTA",              -- ����������� ��������
 		list = {        									 -- ������� �������
				{
					name = 'RPG',
					ip = '185.169.134.83',
					port = "7777",
				},
				{
					name = 'RP1',
					ip = '185.169.134.84',
					port = "7777",
				},
				{
					name = 'RP2',
					ip = '185.169.134.85',
					port = "7777",
				}
 		},
 	},

	--[[---------------------------------------------------------------------------
  ----------------------------------������---------------------------------------
  -------------------------------------------------------------------------------
  {
 		projectname = "Advance Role Play", -- �������� �������
 		title = "Advance RP",              -- ����������� ��������
 		list = {        									 -- ������� �������
 			{
 				name = "Red",         -- ��� �������
 				ip = "5.254.104.131", -- �� �������
 				port = "7777",	      -- ���� �������
 			},
 			{
 				name = "Green",
 				ip = "5.254.104.132",
 				port = "7777",
 			},
 		},
 	},
 	------------------------------------------------------------------------------
   ------------------------------------------------------------------------------
   --------------------------------------------------------------------------]]--
}


function genCode(skey)
  skey = basexx.from_base32(skey)
  value = math.floor(os.time() / 30)
  value = string.char(
  0, 0, 0, 0,
  band(value, 0xFF000000) / 0x1000000,
  band(value, 0xFF0000) / 0x10000,
  band(value, 0xFF00) / 0x100,
  band(value, 0xFF))
  local hash = sha1.hmac_binary(skey, value)
  local offset = band(hash:sub(-1):byte(1, 1), 0xF)
  local function bytesToInt(a,b,c,d)
    return a*0x1000000 + b*0x10000 + c*0x100 + d
  end
  hash = bytesToInt(hash:byte(offset + 1, offset + 4))
  hash = band(hash, 0x7FFFFFFF) % 1000000
  return ('%06d'):format(hash)
end

checkpass = false
checkbank = false

local accounts = {
  {
    user_name         = 'Nick_Name',
    user_password     = '123456',
    server_ip         = '185.169.134.3',
		server_port       = '7777',
	  gauth             = "nil",
		code              = "nil",
  }
}

local def = {
	settings = {
		theme = 3,
		spass = false,
		fastconnect = true,
		key = 120,
		autopass = true,
		autogcode = true,
		autocode = true,
		uahungry = false,
		hungry = false,
		animsuse = false,
		anims = "/anims 32",
		altbot = false,
		animsbot = false,
		chipsbot = false,
		fishbot = false,
		vkladka = 5,
		bg = false,
	},
	helper = {
		reconif = 0,
		recondelay = 0
	}
}

local directIni = "KopnevScripts\\Connect Tool.ini"

local ini = inicfg.load(def, directIni)

local reconifkick = imgui.ImBool(ini.helper.reconif)
local redelayifkick = imgui.ImInt(ini.helper.recondelay/1000)

local tema = imgui.ImInt(ini.settings.theme)
local spass = imgui.ImBool(ini.settings.spass)
local fastconnect = imgui.ImBool(ini.settings.fastconnect)

local autopass = imgui.ImBool(ini.settings.autopass)
local autogcode = imgui.ImBool(ini.settings.autogcode)
local autocode = imgui.ImBool(ini.settings.autocode)

local uahungry = imgui.ImBool(ini.settings.uahungry)
local hungry = imgui.ImBool(ini.settings.hungry)
local animsuse = imgui.ImBool(ini.settings.animsuse)
local anims = imgui.ImBuffer(ini.settings.anims, 32)

local altbot = imgui.ImBool(ini.settings.altbot)
local animsbot = imgui.ImBool(ini.settings.animsbot)
local chipsbot = imgui.ImBool(ini.settings.chipsbot)
local fishbot = imgui.ImBool(ini.settings.fishbot)

local bg = imgui.ImBool(ini.settings.bg)
local key = imgui.ImInt(ini.settings.key)

local sat_flag = false -- https://blast.hk/threads/31640/
local sat_full = false
local f_scrText_state = false
local textdraw = { numb = 549.5, del = 54.5, {549.5, 60, -1436898180}, {547.5, 58, -16777216}, {549.5, 60, 1622575210} }

local ActiveMenu = {
	v = {ini.settings.key}
}
local bindID = 0

local vkladki = {
    false,
		false,
		false,
		false,
		false,
		false,
}

vkladki[ini.settings.vkladka] = true


local items = {
	u8"Ҹ���� ����",
	u8"����� ����",
	u8"������� ����",
	u8"������� ����",
	u8"������ ����",
	u8"��������� ����"
}


local accounts_buffs = {}
local account_info = nil

gou = false
recon = false

function sampev.onShowDialog(id)
	if id == 8929 and account_info == nil then
		checkpass = false
		savepass = savepas
		pass_window_state.v = true
	end
	if id == 8928 and account_info == nil then
		checkpass = false
		savepass = savepas
		pass_window_state.v = true
	end
  if id == 2 and account_info ~= nil then
		if autopass.v == true then
    sampSendDialogResponse(id, 1, 0, account_info['user_password'])
    return false
		else
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ���� ���� ������ ��������.', 0xF1CB09)
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ����� ��������, ��������� � ���������.', 0xF1CB09)
		end
  end
	if id == 2 and account_info == nil then
		checkpass = true
	end
	if id == 8921 and account_info ~= nil then
		findcode = true
	end
	if id == 8929 and account_info ~= nil and account_info['gauth'] ~= "nil" then
		if autogcode.v == true then
		sampSendDialogResponse(id, 1, 0, genCode( account_info['gauth'] ))
    return false
		else
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ���� ���� ���� ���� ��������.', 0xF1CB09)
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ����� ��������, ��������� � ���������.', 0xF1CB09)
		end
	end
	if id == 991 and account_info ~= nil and account_info['code'] ~= "nil" then
		if autocode.v == true then
			sampSendDialogResponse(id, 1, 0, account_info['code'] )
	    return false
		else
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ���� ���� ���� �� ����� ��������.', 0xF1CB09)
			sampAddChatMessage('[Connect-Tool] {FFFFFF} ����� ��������, ��������� � ���������.', 0xF1CB09)
		end
	end
	if id == 991 and account_info ~= nil and account_info['code'] == "nil" then
		checkbank = true
	end
	if id == 33 and account_info['code'] == "nil" then
		checkbank = false
		savecode = savecodee
		code_window_state.v = true
	end
end

function sampev.onTogglePlayerControllable()
	if checkpass == true then
		checkpass = false
		savepass = savepas
		pass_window_state.v = not pass_window_state.v
	end
end


---------------------------------------https://blast.hk/threads/31640/-------------------------------------------
function onReceiveRpc(id, bs)
    if id == 134 then
		local td = readBitstream(bs)
		if td.x == textdraw[1][1] and td.y == textdraw[1][2] and td.color == textdraw[1][3] then
			sat = td.hun
			print(sat)
			--print(math.floor((sat/textdraw.del)*100))
			--print(tostring(sat_flag))
			local tmp = math.floor((sat/textdraw.del)*100)
			if hungry.v then
				if tmp < 20 then
					sat_flag = true
					--print(tostring(sat_flag))
				else
					sat_flag = false
				end
			end
			if tmp > 99 then sat_full = true else sat_full = false end
		end
    end
end

function sampev.onDisplayGameText(style, time, text)
    if uahungry.v and (altbot or animsbot or chipsbot or fishbot) then
        if text:find("You are hungry!") or text:find("You are very hungry!") then
			f_scrText_state = true
		end
	end
end

function sampev.onServerMessage(color,text)
	if f_scrText_state and (altbot or animsbot or chipsbot or fishbot) then
		if string.find(text,"�� ����� ����������� ����. ���������� ��������� ������ �����") then
			f_scrText_state=false
		end
	end
end
-----------------------------------------------------------------------------------------------------------

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
  	while not isSampAvailable() do wait(100) end
  	sampAddChatMessage('[Connect Tool] {FFFFFF}������ ��������. ���������: {F1CB09}F9', 0xF1CB09)
		sampRegisterChatCommand("recon", function()
		recon = true end)
		sampRegisterChatCommand("name", name)

  	--main_windows_state.v = not main_windows_state.v
		update()
		local result, clientId = sampGetPlayerIdByCharHandle(playerPed)
		savepass = "pass"
		savecode = "code"
		ip, port = sampGetCurrentServerAddress()
		name = sampGetPlayerNickname(clientId)


		rename.v = name
		reip.v = ip
		report.v = port..""

		if ini.settings.fastconnect == true then
			fastconnect()
		end


		--sampAddChatMessage(sampGetCurrentDialogId(), 0xffd600)
		local fpath = getWorkingDirectory()..'\\config\\KopnevScripts\\accounts.json'
		if doesFileExist(fpath) then
			local f = io.open(fpath, 'r')
			if f then
				accounts = decodeJson(f:read('*a'))
				f:close()
				accounts_buffs = {}
				for i, v in ipairs(accounts) do
					local temptable = {
						user_name         = imgui.ImBuffer(64),
						user_password     = imgui.ImBuffer(64),
						server_ip         = imgui.ImBuffer(16),
						server_port       = imgui.ImBuffer(16),
						gauth             = imgui.ImBuffer(64),
						code              = imgui.ImBuffer(16),
					}
					temptable['user_name'].v         = v['user_name']
					temptable['user_password'].v     = v['user_password']
					temptable['server_ip'].v         = v['server_ip']
					temptable['server_port'].v       = v['server_port']
					temptable['gauth'].v             = v['gauth']
					temptable['code'].v             = v['code']
					table.insert(accounts_buffs, temptable)
				end
			end
		else
			sampAddChatMessage('[Connect Tool]: ����������� ���� �� ������� ������� �� ���� {2980b0}'..fpath..'{FFFFFF}.', 0xF1CB09)
			sampAddChatMessage('[Connect Tool]: ������ ������������� ������� ��������� ����.', 0xF1CB09)
			local f = io.open(fpath, 'w+')
			if f then
				f:write(encodeJson({
					{
						user_name         = 'Nick_Name',
						user_password     = '123456',
						server_ip         = ip,
						server_port       = port.."",
						gauth             = "nil",
						code             = "nil",
					}
				})):close()
				local temptable = {
					user_name         = imgui.ImBuffer(64),
					user_password     = imgui.ImBuffer(64),
					server_ip         = imgui.ImBuffer(16),
					server_port       = imgui.ImBuffer(16),
					gauth             = imgui.ImBuffer(64),
					code              = imgui.ImBuffer(16),
				}
				accounts_buffs = {}
				temptable['user_name'].v         = 'Nick_Name'
				temptable['user_password'].v     = '123456'
				temptable['server_ip'].v        = ip
				temptable['server_port'].v      = port..""
				temptable['gauth'].v            = "nil"
				temptable['code'].v            = "nil"
				table.insert(accounts_buffs, temptable)
			else
				sampAddChatMessage('[Connect Tool]: ���-�� ����� �� ��� :(', 0xF1CB09)
			end
		end

		account_info = nil
		for i, v in ipairs(accounts) do
			ip, port = sampGetCurrentServerAddress()
			name = sampGetPlayerNickname(clientId)
			wait(100)
				if v['server_ip'] == ip and v['server_port'] == port.."" and v['user_name'] == name then
					print('{00FF00}�������{FFFFFF} �������� ������� {2980b9}'..v['user_name']..'{FFFFFF}.')
					account_info = v
					break
				end
		end

		while true do
		wait(350)
		imgui.Process = main_windows_state.v or pass_window_state.v or informer.v or gadd_window.v or code_window_state.v



		bindID = rkeys.registerHotKey(ActiveMenu.v, true, function ()
		main_windows_state.v = not main_windows_state.v
		end)

		if checkpass == true then
			savepas = sampGetCurrentDialogEditboxText(2)
		end

		if checkbank == true then
			savecodee = sampGetCurrentDialogEditboxText(991)
			sampAddChatMessage(savecodee, -1)
		end

		if bg.v == true then
			WorkInBackground(true)
		else WorkInBackground(false) end

		if gou == true then
					goupdate()
		end

		if findcode == true then
			for i = 99, 1, -1 do
				text, prefix, color, pcolor = sampGetChatString(i)
				if color == 4294967295 then
					gauthcode.v = text
					gadd_window.v = true
					break
				end
			end
			findcode = false
		end

		if lacc == true then
			account_info = nil
			for i, v in ipairs(accounts) do
				ip, port = sampGetCurrentServerAddress()
				name = sampGetPlayerNickname(clientId)
				wait(200)
					if v['server_ip'] == ip and v['server_port'] == port.."" and v['user_name'] == name then
						print('{00FF00}�������{FFFFFF} �������� ������� {2980b9}'..v['user_name']..'{FFFFFF}.')
						account_info = v
						lacc = false
						break
					end
			end
		end

		if reconifkick.v == true then
			dwait = redelayifkick.v * 1000
			ini.helper.reconif = true
			ini.helper.recondelay = dwait
			inicfg.save(def, directIni)
		else if ini.helper.reconif == true then
			ini.helper.reconif = false
			inicfg.save(def, directIni)
		end end
		if recon == true then
			sampAddChatMessage("��������������� �����: "..redelay.v.." ms", 0x00ac35)
			sampAddChatMessage("��������� ������ ����� ���� ����������", 0x00ac35)
			if reconifkick.v == true then reconifkick.v = false tape1 = true end
			sampDisconnectWithReason(-1)
			wait(redelay.v)
			sampSetLocalPlayerName(rename.v)
			sampConnectToServer(reip.v, report.v)
			name = sampGetPlayerNickname(clientid)
			recon = false
			checkpass = false
			account_info = nil
			if tape1 == true then reconifkick.v = true tape1 = false end
			for i, v in ipairs(accounts) do
				print(reip.v..' '..report.v..' '..rename.v..' ')
					if v['server_ip'] == reip.v and v['server_port'] == report.v.."" and v['user_name'] == rename.v then
						print('{00FF00}�������{FFFFFF} �������� ������� {2980b9}'..v['user_name']..'{FFFFFF}.')
						account_info = v
						break
					end
			end
		end
			text, prefix, color, pcolor = sampGetChatString(99)
		andtext4 = 'Use /quit to exit or press ESC and select Quit Game'
		if text == andtext4 then
			if reconifkick.v == true then reconifkick.v = false tape1 = true end
			redelay.v = 15000
			recon = true
			if tape1 == true then reconifkick.v = true tape1 = false end
		end

		if (altbot or animsbot or chipsbot or fishbot) and (f_scrText_state or sat_flag) then
			sampAddChatMessage('[Connect Tool]: �������, ������ ����� � ������.', 0xF1CB09)
			if altbot or animsbot then
				sampSendChat("/house")
				wait(250)
				sampSendDialogResponse(174, 1, 1, -1)
				wait(250)
				sampSendDialogResponse(2431, 1, 0, -1)
				wait(250)
				sampSendDialogResponse(185, 1, 6, -1)
				wait(250)
				sampCloseCurrentDialogWithButton(0)
				sampAddChatMessage('[Connect Tool]: �����, ������ ����� � �������.', 0xF1CB09)
			elseif chipsbot or fishbot then
				sampSendChat("/eat")
				wait(250)
				if chipsbot then
					while not sat_full do
					-- for i = 1, 15 do
						sampSendDialogResponse(9965, 1, 0, -1)
						wait(4000)
					end
				elseif fishbot then
					while not sat_full do
					-- for i = 1, 4 do
						sampSendDialogResponse(9965, 1, 1, -1)
						wait(4000)
					end
				end
				sampAddChatMessage('[Connect Tool]: �����, ������ ����� � �������.', 0xF1CB09)
			end


			if animsuse.v then
				if altbot then
					setGameKeyState(21, 255)--alt
				elseif animsbot or chipsbot or fishbot then
					sampSendChat(anims)
				end
			end
		end

	end


end


function name(nick)
rename.v = nick
recon = true
end

local function drawImguiDemo()
	if imguiDemo.v then
		imgui.ShowTestWindow(imguiDemo)
	end
end


local ips = imgui.ImBuffer(16)
local name = imgui.ImBuffer(64)
local pass = imgui.ImBuffer(64)

function ShowHelpMarker(desc)

    imgui.TextDisabled(fa.ICON_QUESTION_CIRCLE)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(desc)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function ShowCOPYRIGHT(desc)

    imgui.TextDisabled(fa.ICON_COPYRIGHT)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(desc)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end



function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig()
    font_config.MergeMode = true

		fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 11.0, font_config, fa_glyph_ranges)
  end
end


function imgui.OnDrawFrame()
	local result, clientId = sampGetPlayerIdByCharHandle(playerPed)
	if ini.settings.theme == 0 then theme1() end
	if ini.settings.theme == 1 then theme2() end
	if ini.settings.theme == 2 then theme3() end
	if ini.settings.theme == 3 then theme4() end
	if ini.settings.theme == 4 then theme5() end
	if ini.settings.theme == 5 then theme6() end

	local tLastKeys = {}

	drawImguiDemo()

	if informer.v then
		imgui.Begin('Informer')
		imgui.Text(u8'�������� ������:   '..sampGetCurrentDialogId())
		imgui.End()
	end

if main_windows_state.v then

	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(700, 340), imgui.Cond.FirstUseEver)
	imgui.Begin('Connect Tool | version '..thisScript().version , main_windows_state, 2)

	imgui.BeginChild('left pane', imgui.ImVec2(150, 0), true)
	--[[if imgui.Selectable(u8'���������', sel == 0) then sel.v = 0 end
	if imgui.Selectable(u8'FastConnect', sel == 1) then sel.v = 1 end ]]--
	if imgui.Button(u8"�������� ���. "..fa.ICON_USER_CIRCLE, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[1] = true
						ini.settings.vkladka = 1
						inicfg.save(def, directIni)
  end
	if imgui.Button(u8"���. ���� "..fa.ICON_ASTERISK, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[3] = true
						ini.settings.vkladka = 3
						inicfg.save(def, directIni)
  end
  if imgui.Button(u8"��������� "..fa.ICON_REFRESH, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[2] = true
						ini.settings.vkladka = 2
						inicfg.save(def, directIni)
  end
	if imgui.Button(u8"����-����� "..fa.ICON_CUTLERY, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[6] = true
						ini.settings.vkladka = 6
						inicfg.save(def, directIni)
  end
	if imgui.Button(u8"��������� "..fa.ICON_COGS, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[4] = true
						ini.settings.vkladka = 4
						inicfg.save(def, directIni)
  end
	if imgui.Button(u8"���������� "..fa.ICON_INFO_CIRCLE, imgui.ImVec2(133, 35)) then
            uu()
            vkladki[5] = true
						ini.settings.vkladka = 5
						inicfg.save(def, directIni)
  end
	--[[if imgui.Button(u8'ImguiDemo', imgui.ImVec2(133, 35)) then
		imguiDemo.v = not imguiDemo.v
	end]]--


	imgui.EndChild()
	imgui.SameLine(175)

		if vkladki[1] then
			imgui.BeginGroup()
			imgui.Text(u8'��������:')
			imgui.BeginChild('acc', imgui.ImVec2(0, 150), true)


					imgui.Columns(3, 'mycolumns')
					imgui.Separator()
					imgui.Text(fa.ICON_ID_CARD.. u8'  �������') imgui.NextColumn()
					imgui.Text(fa.ICON_KEY.. u8'  ������') imgui.NextColumn()
					imgui.Text(fa.ICON_SERVER.. u8'  ������') imgui.NextColumn()
					imgui.Separator()
			local g



					for i, v in ipairs(accounts) do
	          if imgui.Selectable(i..'. '..v['user_name']..'##'..i, selacc == i, 2) then selacc = i end
						imgui.NextColumn()
						if ini.settings.spass == true then imgui.Text(v['user_password'])	imgui.NextColumn() else
							imgui.Text('******')	imgui.NextColumn() end

						vv = false
						for i2, v2 in ipairs(serv) do
							for i3, v3 in ipairs(v2['list']) do
								if v['server_ip'] == v3['ip'] and v['server_port'] == v3['port'] then
								 imgui.Text(v2['title'].." | "..v3['name']) imgui.NextColumn()
								 vv = true
								 break
							 end
							end
						end -- ����� ������ �� ������, � ���� ���� �����
						if vv == false then
							imgui.Text(v['server_ip']..":"..v['server_port']) imgui.NextColumn()
						end
					end




			imgui.EndChild()

			if imgui.Button(fa.ICON_USER_PLUS.. u8'  ��������', imgui.ImVec2(110, 27)) then


				local fpath = getWorkingDirectory()..'\\config\\KopnevScripts\\accounts.json'
					if doesFileExist(fpath) then
						local f = io.open(fpath, 'w+')
						if f then
							ip, port = sampGetCurrentServerAddress()
							local temptable = {
								user_name         = imgui.ImBuffer(64),
								user_password     = imgui.ImBuffer(64),
								server_ip         = imgui.ImBuffer(16),
								server_port       = imgui.ImBuffer(16),
								gauth             = imgui.ImBuffer(64),
								code              = imgui.ImBuffer(16),
							}
							temptable['user_name'].v         = sampGetPlayerNickname(clientId)
							temptable['user_password'].v     = '123456'
							temptable['server_ip'].v         = ip
							temptable['server_port'].v       = port..""
							temptable['gauth'].v             = "nil"
							temptable['code'].v             = "nil"
							table.insert(accounts_buffs, temptable)
							table.insert(accounts, {
								user_name         = sampGetPlayerNickname(clientId),
								user_password     = '123456',
								server_ip         = ip,
								server_port       = port.."",
								gauth             = "nil",
								code              = "nil",
							})
							f:write(encodeJson(accounts)):close()
							selacc = #accounts
						else
							sampAddChatMessage(u8:decode('[Autologin]: ���-�� ����� �� ��� :('), -1)
						end
					else
						sampAddChatMessage(u8:decode('[Autologin]: ���-�� ����� �� ��� :('), -1)
					end
					add_window_state.v = not add_window_state.v
			end

			if selacc > -1 then
				imgui.SameLine()
				if imgui.Button(fa.ICON_PENCIL.. u8'  ��������', imgui.ImVec2(110, 27)) then
					add_window_state.v = not add_window_state.v
				end imgui.SameLine()


				if imgui.Button(fa.ICON_TRASH.. u8'  �������', imgui.ImVec2(110, 27)) then delete_window_state.v = true end imgui.SameLine()
				if imgui.Button(fa.ICON_PLUG.. u8'  ������������', imgui.ImVec2(110, 27)) then
									sampSetLocalPlayerName(accounts[selacc]['user_name'])
									sampConnectToServer(accounts[selacc]['server_ip'], accounts[selacc]['server_port'])
									account_info = nil
									for i, v in ipairs(accounts) do
											ip, port = sampGetCurrentServerAddress()
											if v['server_ip'] == ip and v['server_port'] == port.."" and v['user_name'] == sampGetPlayerNickname(clientId) then
												print('{00FF00}�������{FFFFFF} �������� ������� {2980b9}'..v['user_name']..'{FFFFFF}.')
												account_info = v
												break
											end
									end
								 end


				if selacc ~= -1 then imgui.Text(u8'��������� �������: '..accounts[selacc]['user_name']) end
				imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(396)
				if imgui.Button(fa.ICON_WINDOW_CLOSE.. u8' �������', imgui.ImVec2(120, 30)) then autosave() main_windows_state.v = false end
			else
				imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(396)
				if imgui.Button(fa.ICON_WINDOW_CLOSE.. u8' �������', imgui.ImVec2(120, 30)) then autosave() main_windows_state.v = false end
			end

			imgui.EndGroup()
		end

		if vkladki[2] == true then
			imgui.BeginGroup()
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(200) imgui.Text(u8'���������')
			imgui.NewLine()
			imgui.Text(u8'���-����:  ') imgui.SameLine(130) imgui.PushItemWidth(190) imgui.InputText('##11', rename) imgui.PopItemWidth()
			imgui.NewLine()
			imgui.Text(u8'��:���� �������:  ') imgui.SameLine(130) imgui.PushItemWidth(120) imgui.InputText('##12', reip) imgui.PopItemWidth()
			imgui.SameLine() imgui.Text(':') imgui.SameLine() imgui.PushItemWidth(57) imgui.InputText('##13', report) imgui.PopItemWidth() imgui.SameLine()
			vv = false
			for i2, v2 in ipairs(serv) do
				for i3, v3 in ipairs(v2['list']) do
					if reip.v == v3['ip'] and report.v == v3['port'] then
					 ShowHelpMarker(v2['title'].." | "..v3['name'])
					 vv = true
					 break
				 end
				end
			end -- ����� ������ �� ������, � ���� ���� �����
			if vv == false then
				ShowHelpMarker(u8'����������� ������')
			end imgui.SameLine()
			if imgui.Button(u8'�������') then
				 reip.v = ip
				 report.v = port..""
			 end imgui.SameLine()
			if imgui.Button(u8'�������') then server_window_state.v = not server_window_state.v end
			imgui.NewLine()
			imgui.Text(u8'��������:  ') imgui.SameLine(130) imgui.PushItemWidth(190) imgui.InputInt('ms ', redelay, 1000) imgui.PopItemWidth() imgui.SameLine()
			sec = redelay.v / 1000
			ShowHelpMarker(u8'�������� ������� � ������������ (ms). '..redelay.v..' ms = '..sec..u8' ������')
			imgui.NewLine() imgui.NewLine() imgui.SameLine(120)
			if imgui.Button(fa.ICON_BAN.. u8'  �����������') then
				sampDisconnectWithReason(1)
			end imgui.SameLine()
			if imgui.Button(fa.ICON_PLUG.. u8'  ������������') then
				recon = true

			end imgui.NewLine()
			imgui.Text(u8'����� ���� ���: ') imgui.SameLine(130) imadd.ToggleButton('##recon', reconifkick)
			if reconifkick.v == true then
				imgui.NewLine()
				imgui.Text(u8'��������:') imgui.SameLine(130) imgui.PushItemWidth(190) imgui.InputInt('sec', redelayifkick, 10) imgui.PopItemWidth() imgui.SameLine()
				min = redelayifkick.v / 60
				ShowHelpMarker(u8'�������� ������� � �������� (sec). '..redelayifkick.v..u8' ������ = '..min..u8' �����')
			end
			imgui.EndGroup()
		end

		if vkladki[6] == true then
			imgui.BeginGroup()
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(200) imgui.Text(u8'����-�����')
			imgui.SameLine() ShowCOPYRIGHT(u8'�����: James Hawk')
			imgui.NewLine() imgui.Separator() imgui.NewLine()
			imgui.SameLine(15) imgui.Text(u8'�������� ��� ������ �������:')
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(15) imgui.Text(u8'You are hungry: ') imgui.SameLine() if imadd.ToggleButton(u8'Yoy are hungry', uahungry) then
				ini.settings.uahungry = uahungry.v
				inicfg.save(def, directIni)
			end imgui.SameLine() ShowHelpMarker(u8'You are hungry - �����������, ����� �� ������ ���������� ������� ������� \"You are hungry!\" ��� \"You are very hungry!\".') imgui.SameLine(200)
			imgui.Text(u8'�����: ') imgui.SameLine() if imadd.ToggleButton(u8'�����', hungry)  then
				ini.settings.hungry = hungry.v
				inicfg.save(def, directIni)
			end imgui.SameLine() ShowHelpMarker(u8'����� - ����������� ����� �������� ������� ��������� ���� 20 ������.')
			imgui.NewLine() imgui.Separator() imgui.NewLine()
			imgui.SameLine(15) imgui.Text(u8'������������ ��������: ') imgui.SameLine()
			if imadd.ToggleButton(u8'������������ ��������', animsuse) then
				ini.settings.animsuse = animsuse.v
				inicfg.save(def, directIni)
			end
			if animsuse.v == true and not altbot.v then
				imgui.SameLine(215)  imgui.PushItemWidth(150) imgui.InputText('##anims', anims) imgui.PopItemWidth()
			end
			imgui.NewLine() imgui.Separator() imgui.NewLine()
			imgui.SameLine(15) imgui.Text(u8'����� ������ �������� ��� ����:')
			imgui.SameLine() ShowHelpMarker(u8'����� ������������ ��������, �� �������� �������� ��, � ������ ����')
			imgui.NewLine()	imgui.NewLine()


			imgui.SameLine(15) imgui.Text(u8'Alt-bot:') imgui.SameLine(100) if imadd.ToggleButton('##alt', altbot) then
				chipsbot.v = false
				animsbot.v = false
				fishbot.v = false
				ini.settings.chipsbot = chipsbot.v
				ini.settings.animsbot = animsbot.v
				ini.settings.altbot = altbot.v
				ini.settings.fishbot = fishbot.v
				inicfg.save(def, directIni)
			end
			imgui.SameLine() ShowHelpMarker(u8'Alt-���: ��� ��� �� ������������. ����� ���� ��� ����� ��������� � alt �������� (�������� ALT)')


			imgui.SameLine(200) imgui.Text(u8'Chips-bot:') imgui.SameLine(285) if imadd.ToggleButton('##Chips', chipsbot) then
				altbot.v = false
				animsbot.v = false
				fishbot.v = false
				ini.settings.chipsbot = chipsbot.v
				ini.settings.animsbot = animsbot.v
				ini.settings.altbot = altbot.v
				ini.settings.fishbot = fishbot.v
				inicfg.save(def, directIni)
			end
			imgui.SameLine() ShowHelpMarker(u8'Alt-���: ��� �����. ����� ���� ��� ����� ��������� � �������� �� (/anims)')


			imgui.NewLine()	imgui.NewLine()
			imgui.SameLine(15) imgui.Text(u8'Anims-bot:') imgui.SameLine(100) if imadd.ToggleButton('##animsbot', animsbot) then
				altbot.v = false
				chipsbot.v = false
				fishbot.v = false
				ini.settings.chipsbot = chipsbot.v
				ini.settings.animsbot = animsbot.v
				ini.settings.altbot = altbot.v
				ini.settings.fishbot = fishbot.v
				inicfg.save(def, directIni)
			end
			imgui.SameLine() ShowHelpMarker(u8'Alt-���: ��� ��� �� ������������. ����� ���� ��� ����� ��������� � �������� �� (/anims)')


			imgui.SameLine(200) imgui.Text(u8'Fish-bot:') imgui.SameLine(285) if imadd.ToggleButton('##fish', fishbot) then
				altbot.v = false
				chipsbot.v = false
				animsbot.v = false
				ini.settings.chipsbot = chipsbot.v
				ini.settings.animsbot = animsbot.v
				ini.settings.altbot = altbot.v
				ini.settings.fishbot = fishbot.v
				inicfg.save(def, directIni)
			end
			imgui.SameLine() ShowHelpMarker(u8'Alt-���: ��� ����. ����� ���� ��� ����� ��������� � �������� �� (/anims)')

			imgui.EndGroup()
		end


		if vkladki[3] == true then
			imgui.BeginGroup()
			imgui.BeginChild('acc', imgui.ImVec2(0, 150), true)


					imgui.Columns(3, 'mycolumns')
					imgui.Separator()
					imgui.Text(fa.ICON_ID_CARD.. u8'  �������') imgui.NextColumn()
					imgui.Text(fa.ICON_GOOGLE.. u8'  GAuth') imgui.NextColumn()
					imgui.Text(fa.ICON_CREDIT_CARD.. u8'  ��� �� �����') imgui.SameLine() ShowHelpMarker('for Arizona RP') imgui.NextColumn()
					imgui.Separator()




					for i, v in ipairs(accounts) do
						xuypoimidlyachecgo = v
	          if imgui.Selectable(i..'. '..v['user_name']..'##'..i, selacc == i, 2) then selacc = i  end
						imgui.SameLine()
						vv = false
						for i2, v2 in ipairs(serv) do
							for i3, v3 in ipairs(v2['list']) do
								if v['server_ip'] == v3['ip'] and v['server_port'] == v3['port'] then
								 ShowHelpMarker(v2['title'].." | "..v3['name']) imgui.NextColumn()
								 vv = true
								 break
							 end
							end
						end -- ����� ������ �� ������, � ���� ���� �����
						if vv == false then
							ShowHelpMarker(v['server_ip']..":"..v['server_port']) imgui.NextColumn()
						end

						if v['gauth'] == "nil" then imgui.Text('No GAuth') imgui.NextColumn() else
							if gcode == 0 then imgui.Text(u8'��� �� ������������') imgui.NextColumn() else
								imgui.Text(gcode) imgui.NextColumn()
							end
						end
						if v['code'] == "nil" then imgui.Text('No bank') imgui.NextColumn() else
							if ini.settings.spass == true then imgui.Text(v['code']) imgui.NextColumn() else
								imgui.Text("******") imgui.NextColumn()
							end
							end
					end
			imgui.EndChild()
			if imgui.Button(fa.ICON_REFRESH.. u8'  �������������', imgui.ImVec2(120, 30)) then
				gcode = genCode( accounts[selacc]['gauth'] )
				print(gcode)
			end imgui.SameLine()
			if selacc ~= -1 then
			if imgui.Button(fa.ICON_PENCIL.. u8'  �������� ', imgui.ImVec2(120, 30)) then
				accounts_buffs[selacc]['code'].v = accounts[selacc]['code']
				accounts_buffs[selacc]['gauth'].v = accounts[selacc]['gauth']
				edit_window_state.v = true
			end imgui.SameLine()
			if imgui.Button(fa.ICON_TRASH.. u8'  �������', imgui.ImVec2(120, 30)) then delete_window_state.v = true end
		end
			imgui.EndGroup()
	end

	if vkladki[4] == true then
			imgui.BeginGroup()
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(200)
			imgui.Text(u8'���������')
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(1) imgui.Text(u8'����� ����:   ') imgui.SameLine()
			imgui.PushItemWidth(250)
			if imgui.Combo('', tema, items, -1)then
				ini.settings.theme = tema.v
				inicfg.save(def, directIni)
			end imgui.PopItemWidth()
			imgui.NewLine()
			imgui.Text(u8'���������:      ') imgui.SameLine()
			--[[if imadd.HotKey("##active", ActiveMenu, tLastKeys, 100) then
	      rkeys.changeHotKey(bindID, ActiveMenu.v)
	      sampAddChatMessage("�������! ������ ��������: " .. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. " | �����: " .. table.concat(rkeys.getKeysName(ActiveMenu.v), " + "), -1)
	   	end]]--
			imgui.PushItemWidth(100) if imgui.InputInt('##key', key, 0) then
				ini.settings.key = key.v
				inicfg.save(def, directIni)
			end imgui.PopItemWidth()
			 imgui.SameLine()
			ShowHelpMarker(u8'������ �� ������, ����� ���:  https://blast.hk/threads/8760/')
			imgui.NewLine()
			imgui.Text(u8'���������� ������ � ���:') imgui.SameLine(250)
			if imadd.ToggleButton(u8'##spass', spass) then

				ini.settings.spass = spass.v
				inicfg.save(def, directIni)
			end
			imgui.Text(u8'������������� ������� ������:') imgui.SameLine(250)
			if imadd.ToggleButton(u8'##autopass', autopass) then

				ini.settings.autopass = autopass.v
				inicfg.save(def, directIni)
			end
			imgui.Text(u8'������������� ������� GAuth:') imgui.SameLine(250)
			if imadd.ToggleButton(u8'##autogcode', autogcode) then

				ini.settings.autogcode = autogcode.v
				inicfg.save(def, directIni)
			end
			imgui.Text(u8'������������� ������� ��� �� �����:') imgui.SameLine(250)
			if imadd.ToggleButton(u8'##autocode', autocode) then

				ini.settings.autocode = autocode.v
				inicfg.save(def, directIni)
			end
			imgui.Text(u8'������ � �������� ������:') imgui.SameLine(250)
			if imadd.ToggleButton(u8'##bg', bg) then

				ini.settings.bg = bg.v
				inicfg.save(def, directIni)
			end


				imgui.NewLine() imgui.NewLine()
				imgui.SameLine(1) if imgui.Button(fa.ICON_UPLOAD ..  u8'   ��������� ����������') then
					local fpath = os.getenv('TEMP') .. '\\ctool_version.json' -- ���� ����� �������� ��� ������ ��� ��������� ������
				  downloadUrlToFile('https://raw.githubusercontent.com/danil8515/Connect-Tool/master/version.json', fpath, function(id, status, p1, p2) -- ������ �� ��� ������ ��� ���� ������� ������� � ��� � ���� ��� ����� ������ ����
				    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				    local f = io.open(fpath, 'r') -- ��������� ����
				    if f then
				      local info = decodeJson(f:read('*a')) -- ������
				      updatelink = info.updateurl
				      if info and info.latest then
				        version = tonumber(info.latest) -- ��������� ������ � �����
				        ver = tonumber(info.ver)
				        if version > thisScript().version_num then -- ���� ������ ������ ��� ������ ������������� ��...
				          new = 1
									sampAddChatMessage(('[Connect-Tool]: {FFFFFF}�������� ����������!'), 0xF1CB09)
				        	else -- ���� ������, ��
				          update = false -- �� ��� ����������
				          sampAddChatMessage(('[Connect-Tool]: {FFFFFF}� ��� ����������� ��������� ������!'), 0xF1CB09)
				        end
				      end
				    end
				  end
				end)
			end








			if new == 1 then
				imgui.SameLine()
				if imgui.Button(u8'��������') then
					gou = true
				end
			end


			imgui.EndGroup()
		end

		if vkladki[5] == true then
			imgui.BeginGroup()
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(150)
			imgui.Text(u8'����������')
			imgui.NewLine() imgui.NewLine() imgui.NewLine()
			imgui.SameLine(50) imgui.Text(u8'�����: ������ ������')
			imgui.NewLine()
			imgui.SameLine(50) imgui.Text(u8'�� ������: vk.com/d.k8515   ')
			imgui.SameLine(250) if imgui.Button(u8'�������') then os.execute('explorer "https://vk.com/d.k8515"') end
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(50) imgui.Text(u8'���������� ���: ������� | �������� ����')
			imgui.NewLine()
			imgui.SameLine(50) imgui.Text(u8'������: vk.com/arizonapolezno  ')
			imgui.SameLine(250) if imgui.Button(u8'�e�����') then os.execute('explorer "https://vk.com/arizonapolezno"') end
			imgui.NewLine() imgui.NewLine()
			imgui.SameLine(50) imgui.Text(u8'������ �������: '..thisScript().version)
			if new == 1 then imgui.SameLine() imgui.Text(u8'( �������� ����� ������: '..ver..' )') else
				imgui.SameLine() imgui.Text(u8'( ��������� ������ )') end
			imgui.EndGroup()
		end

    imgui.End()
	end

if delete_window_state.v then
imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(3, 2.5))
imgui.Begin(u8'�������������')
imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8'��������!')
imgui.Text(u8'���� �� ������� �������, �� ��� ������ �� �������� ��������')
imgui.Text(u8'� ��� ����� � TOTP ��� � ��� �� �����')
imgui.Text(u8'���� �� �� �������� ���, �� �� �� ������� ��� ������������')
imgui.NewLine()
imgui.SameLine(210) if imgui.Button(u8'������', imgui.ImVec2(100, 25)) then delete_window_state.v = false end imgui.SameLine()
if imgui.Button(u8'�������', imgui.ImVec2(100, 25)) then
	local fpath = getWorkingDirectory()..'\\config\\KopnevScripts\\accounts.json'
	if doesFileExist(fpath) then
		local f = io.open(fpath, 'w+')
		if f then
			if selacc ~= 1 then   selacc = selacc-1 else selacc = -1 end
			table.remove(accounts, temp)
			table.remove(accounts_buffs, temp)
			f:write(encodeJson(accounts)):close()
		else
			sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
		end
	else
		sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
	end

	delete_window_state.v = false
end
imgui.End()
end

if edit_window_state.v then
	if selacc == -1 then selacc = 1 end
	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 5, imgui.GetIO().DisplaySize.y / 7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.Begin(u8'��������� ������ ��������', edit_window_state, 64)
	imgui.Text(u8'������� ������ ��������: '..selacc)
	imgui.InputText(u8'������� TOTP code (gauth)', accounts_buffs[selacc]['gauth']) imgui.SameLine()
	ShowHelpMarker(u8'����� ������� ���� ��������������, �������� ���� ������')
	imgui.InputText(u8'������� ��� �� �����', accounts_buffs[selacc]['code']) imgui.SameLine()
	ShowHelpMarker(u8'����� ������� ��� �� �����, �������� ���� ������') imgui.SameLine()
	imgui.NewLine() imgui.NewLine()
	imgui.SameLine(350) if imgui.Button(u8'���������') then
		if accounts_buffs[selacc]['gauth'].v == "" then xuypoimidlyachecgo['gauth'] = "nil" else
		accounts[selacc]['gauth'] = accounts_buffs[selacc]['gauth'].v end
		if accounts_buffs[selacc]['code'].v == "" then xuypoimidlyachecgo['code'] = "nil" else
		accounts[selacc]['code'] = accounts_buffs[selacc]['code'].v end
		edit_window_state.v = false
		autosave()
		lacc = true
	end


	imgui.End()

end

if add_window_state.v then
	ip, port = sampGetCurrentServerAddress()
	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 5, imgui.GetIO().DisplaySize.y / 7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

	imgui.Begin(u8'��������� ������ �������� ', add_window_state, 64)
	imgui.Text(u8'������� ������ ��������: '..selacc)
	imgui.Text(u8'������� ���-����: ') imgui.SameLine(150)
	imgui.InputText('##Nick', accounts_buffs[selacc]['user_name']) imgui.SameLine()
	if imgui.Button(u8' �������') then
		 accounts_buffs[selacc]['user_name'].v = sampGetPlayerNickname(clientId)
	 end
	 imgui.Text(u8'������� ������: ') imgui.SameLine(150)
	imgui.InputText('##pass', accounts_buffs[selacc]['user_password'])
	imgui.Text(u8'������� �� �������: ') imgui.SameLine(150)
	imgui.InputText('##ip', accounts_buffs[selacc]['server_ip']) imgui.SameLine()
	if imgui.Button(u8'�������') then
		 accounts_buffs[selacc]['server_ip'].v = ip
		 accounts_buffs[selacc]['server_port'].v = port..""
	 end imgui.SameLine()
	 if imgui.Button(u8'�������')  then
		 server_window_state.v = not server_window_state.v
	 end
	 imgui.Text(u8'������� ���� �������: ') imgui.SameLine(150)
	 imgui.InputText('##Port', accounts_buffs[selacc]['server_port'])
	 imgui.NewLine()
	  imgui.SameLine(305) if imgui.Button(u8'���������') then
		accounts[selacc]['user_name'] = accounts_buffs[selacc]['user_name'].v
		accounts[selacc]['user_password'] = accounts_buffs[selacc]['user_password'].v
		accounts[selacc]['server_ip'] = accounts_buffs[selacc]['server_ip'].v
		accounts[selacc]['server_port'] = accounts_buffs[selacc]['server_port'].v
		autosave()
		add_window_state.v = not add_window_state.v
	end

	imgui.End()

end

if pass_window_state.v then
	ip, port = sampGetCurrentServerAddress()
	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x - 185, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(255, 292), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'���������� ������', main_windows_state, 2)
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	imgui.Text(u8'�������: '..sampGetPlayerNickname(clientId))
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	imgui.Text(u8'������: ') imgui.SameLine()
	if showpass.v == false then imgui.Text(u8'******') else imgui.Text(savepass) end
	imgui.SameLine() imgui.Checkbox('##22', showpass) imgui.SameLine() ShowHelpMarker(u8'�������� ��� ������ ������.')
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	--imgui.Text(u8'������: '..ip..":"..port)
	vv = false
	for i2, v2 in ipairs(serv) do
		for i3, v3 in ipairs(v2['list']) do
			if reip.v == v3['ip'] and report.v == v3['port'] then
			 imgui.Text(u8'������: '..v2['title'].." | "..v3['name']..'.')
			 vv = true
			 break
		 end
		end
	end -- ����� ������ �� ������, � ���� ���� �����
	if vv == false then
		imgui.Text(u8'������: '..ip..":"..port)
	end
	imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(125)
	if imgui.Button(u8'������') then pass_window_state.v = not pass_window_state.v end
 	imgui.SameLine()
	if imgui.Button(u8'��������') then
		local fpath = getWorkingDirectory()..'\\config\\KopnevScripts\\accounts.json'
			if doesFileExist(fpath) then
				local f = io.open(fpath, 'w+')
				if f then
					ip, port = sampGetCurrentServerAddress()
					local temptable = {
						user_name         = imgui.ImBuffer(64),
						user_password     = imgui.ImBuffer(64),
						server_ip         = imgui.ImBuffer(16),
						server_port       = imgui.ImBuffer(16),
						gauth             = imgui.ImBuffer(64),
						code              = imgui.ImBuffer(16),
					}
					temptable['user_name'].v         = sampGetPlayerNickname(clientId)
					temptable['user_password'].v     = savepass
					temptable['server_ip'].v         = ip
					temptable['server_port'].v       = port..""
					temptable['gauth'].v         			= "nil"
					temptable['gauth'].v         			= "code"
					table.insert(accounts_buffs, temptable)
					table.insert(accounts, {
						user_name         = sampGetPlayerNickname(clientId),
						user_password     = savepass,
						server_ip         = ip,
						server_port       = port.."",
						gauth             = "nil",
						code              = "nil",
					})
					f:write(encodeJson(accounts)):close()
					selacc = #accounts
				else
					sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
				end
			else
				sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
			end
			lacc = true
			pass_window_state.v = not pass_window_state.v
	end
	imgui.End()
end





if code_window_state.v then
	ip, port = sampGetCurrentServerAddress()
	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x - 185, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(255, 292), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'���������� ���� �� �����', main_windows_state, 2)
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	imgui.Text(u8'�������: '..sampGetPlayerNickname(clientId))
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	imgui.Text(u8'���: ') imgui.SameLine()
	if showcode.v == false then imgui.Text(u8'******') else imgui.Text(savecode) end
	imgui.SameLine() imgui.Checkbox('##223', showcode) imgui.SameLine() ShowHelpMarker(u8'�������� ��� ������ ���.')
	imgui.NewLine() imgui.NewLine() imgui.SameLine(25)
	--imgui.Text(u8'������: '..ip..":"..port)
	vv = false
	for i2, v2 in ipairs(serv) do
		for i3, v3 in ipairs(v2['list']) do
			if reip.v == v3['ip'] and report.v == v3['port'] then
			 imgui.Text(u8'������: '..v2['title'].." | "..v3['name']..'.')
			 vv = true
			 break
		 end
		end
	end -- ����� ������ �� ������, � ���� ���� �����
	if vv == false then
		imgui.Text(u8'������: '..ip..":"..port)
	end
	imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(125)
	if imgui.Button(u8'������') then code_window_state.v = false end
 	imgui.SameLine()
	if imgui.Button(u8'��������') then
			account_info['code'] =  savecode
			autosave()
			lacc = true
			code_window_state.v = false
	end
	imgui.End()
end













if gadd_window.v then
 imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 9, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
 imgui.SetNextWindowSize(imgui.ImVec2(170, 210), imgui.Cond.FirstUseEver)
 imgui.Begin(u8'���� ��������������', gadd_window, 2)
 imgui.Text(u8'��� ��������� TOTP ���:')
 imgui.PushItemWidth(150)   imgui.InputText(u8'##ga', gauthcode) imgui.PopItemWidth()
 imgui.NewLine()
 if imgui.Button(u8'������������� ���') then gen = true end
 if gen == true then
	 imgui.NewLine()
 	imgui.Text(u8"��� ���:  "..genCode(gauthcode.v))
	imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(100)
	if imgui.Button(u8'��������') then
		account_info['gauth'] = gauthcode.v
		sampAddChatMessage('[Autologin]: {FFFFFF}��� ������� �������', 0xF1CB09)
		autosave()
	end
	else
 	imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.NewLine() imgui.SameLine(100)
 	if imgui.Button(u8'��������') then
		account_info['gauth'] = gauthcode.v
		sampAddChatMessage('[Autologin]: {FFFFFF}��� ������� �������', 0xF1CB09)
		autosave()
	end
	end
 imgui.End()
end
--EVYHZMTZ64HEBPAU

if server_window_state.v then
	imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 1.55, imgui.GetIO().DisplaySize.y / 13), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
imgui.Begin(u8'����� �������', server_window_state, 64)
imgui.BeginGroup()
imgui.BeginChild('Server', imgui.ImVec2(140, 200), true)


for i, v in ipairs(serv) do
if imgui.Button(v['projectname'], imgui.ImVec2(120, 20)) then
	mq()
	servers[1] = true
	ss = i
end

end

imgui.EndChild()
imgui.EndGroup()


imgui.SameLine(165)

if servers[1] == true then
imgui.BeginGroup()
for i, v in ipairs(serv[ss]['list']) do
	if imgui.Button(serv[ss]['title'].." | "..v['name'], imgui.ImVec2(150, 20)) then
			if add_window_state.v == true then
				accounts_buffs[selacc]['server_ip'].v = v['ip']
				accounts_buffs[selacc]['server_port'].v = v['port']
			end
			if vkladki[2] == true then
				reip.v = v['ip']
				report.v = v['port']
			end
	end
end

imgui.EndGroup()
end



imgui.End()
end

end

function autosave()
	local fpath = getWorkingDirectory()..'\\config\\KopnevScripts\\accounts.json'
	if doesFileExist(fpath) then
		local f = io.open(fpath, 'w+')
		if f then
			f:write(encodeJson(accounts)):close()
		else
			sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
		end
	else
		sampAddChatMessage(u8'[Autologin]: ���-�� ����� �� ��� :(', -1)
	end
end

function loadacc()
	for i, v in ipairs(accounts) do
			ip, port = sampGetCurrentServerAddress()
			name = sampGetPlayerNickname(clientId)
			if v['server_ip'] == ip and v['server_port'] == port.."" and v['user_name'] == sampGetPlayerNickname(clientId) then
				print('{00FF00}�������{FFFFFF} �������� ������� {2980b9}'..v['user_name']..'{FFFFFF}.')
				account_info = v
				break
			end
	end
end

function readBitstream(bs)
	local data = {}
	data.id = raknetBitStreamReadInt16(bs)
	raknetBitStreamIgnoreBits(bs, 104)
	data.hun = raknetBitStreamReadFloat(bs) - textdraw.numb
	raknetBitStreamIgnoreBits(bs, 32)
	data.color = raknetBitStreamReadInt32(bs)
	raknetBitStreamIgnoreBits(bs, 64)
	data.x = raknetBitStreamReadFloat(bs)
	data.y = raknetBitStreamReadFloat(bs)
	return data
end

function update()
  local fpath = os.getenv('TEMP') .. '\\ctool_version.json' -- ���� ����� �������� ��� ������ ��� ��������� ������
  downloadUrlToFile('https://raw.githubusercontent.com/danil8515/Connect-Tool/master/version.json', fpath, function(id, status, p1, p2) -- ������ �� ��� ������ ��� ���� ������� ������� � ��� � ���� ��� ����� ������ ����
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- ��������� ����
    if f then
      local info = decodeJson(f:read('*a')) -- ������
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- ��������� ������ � �����
        ver = tonumber(info.ver)
        if version > thisScript().version_num then -- ���� ������ ������ ��� ������ ������������� ��...
          new = 1
					sampAddChatMessage(('[Connect-Tool]: {FFFFFF}�������� ����������!'), 0xF1CB09)
        	else -- ���� ������, ��
          update = false -- �� ��� ����������
          sampAddChatMessage(('[Connect-Tool]: {FFFFFF}� ��� ����������� ��������� ������!'), 0xF1CB09)
        end
      end
    end
  end
end)
end

function goupdate()
gou = false
sampAddChatMessage(('[Connect-Tool]: ���������� ����������. AutoReload ����� �������������. ����������...'), 0xF1CB09)
sampAddChatMessage(('[Connect-Tool]: ������� ������: '..thisScript().version..". ����� ������: "..ver), 0xF1CB09)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- ������ ��� ������ � latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Connect-Tool]: ���������� ���������!'), 0xF1CB09)
  thisScript():reload()
end
end)
end

function uu()
    for i = 0,6 do
        vkladki[i] = false
    end
		autosave()
end

function mq()
	for i = 0,5 do
			servers[i] = false
	end
end

function qq()
	altbot = false
	animsbot = false
	chipsbot = false
	fishbot = false
	ini.settings.altbot = altbot
	ini.settings.animsbot = animsbot
	ini.settings.chipsbot = chipsbot
	ini.settings.fishbot = fishbot
	inicfg.save(def, directIni)
end


function WorkInBackground(work)
    local memory = require 'memory'
    if work then
        memory.setuint8(7634870, 1)
        memory.setuint8(7635034, 1)
        memory.fill(7623723, 144, 8)
        memory.fill(5499528, 144, 6)
    else
        memory.setuint8(7634870, 0)
        memory.setuint8(7635034, 0)
        memory.hex2bin('5051FF1500838500', 7623723, 8)
        memory.hex2bin('0F847B010000', 5499528, 6)
    end
end

function fastconnect()
memory.fill(sampGetBase() + 0x2D3C45, 0, 2, true)
end

function theme1()
		imgui.SwitchContext()
		local style = imgui.GetStyle()
		local Colors = style.Colors
		local ImVec4 = imgui.ImVec4
		local ImVec2 = imgui.ImVec2

			WindowPadding = ImVec2(15, 15)
		    WindowRounding = 5.0
		    FramePadding = ImVec2(5, 5)
		    FrameRounding = 4.0
		    ItemSpacing = ImVec2(12, 8)
		    ItemInnerSpacing = ImVec2(8, 6)
		    IndentSpacing = 25.0
		    ScrollbarSize = 15.0
		    ScrollbarRounding = 9.0
		    GrabMinSize = 5.0
		    GrabRounding = 3.0
				style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)

		    Colors[imgui.Col.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
		    Colors[imgui.Col.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
		    Colors[imgui.Col.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
		    Colors[imgui.Col.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		    Colors[imgui.Col.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		    Colors[imgui.Col.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
		    Colors[imgui.Col.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
		    Colors[imgui.Col.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		    Colors[imgui.Col.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		    Colors[imgui.Col.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
		    Colors[imgui.Col.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
		    Colors[imgui.Col.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		    Colors[imgui.Col.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		    Colors[imgui.Col.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		    Colors[imgui.Col.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
		    Colors[imgui.Col.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
		    Colors[imgui.Col.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		    Colors[imgui.Col.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		    Colors[imgui.Col.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		    Colors[imgui.Col.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		    Colors[imgui.Col.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
		    Colors[imgui.Col.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		    Colors[imgui.Col.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		    Colors[imgui.Col.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
		    Colors[imgui.Col.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		    Colors[imgui.Col.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		    Colors[imgui.Col.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
		    Colors[imgui.Col.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
		    Colors[imgui.Col.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
		    Colors[imgui.Col.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
		    Colors[imgui.Col.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		    Colors[imgui.Col.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
		    Colors[imgui.Col.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		    Colors[imgui.Col.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		    Colors[imgui.Col.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

function theme2()
	imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme3()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme4()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.16, 0.48, 0.42, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 1.00)
    colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.10, 0.75, 0.63, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.10, 0.75, 0.63, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.26, 0.98, 0.85, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.98, 0.85, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.98, 0.85, 0.95)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.98, 0.85, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function theme5()
	local style = imgui.GetStyle()
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4

	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.Alpha = 1.0
  style.Colors[clr.Text] = ImVec4(1.000, 1.000, 1.000, 1.000)
  style.Colors[clr.TextDisabled] = ImVec4(0.000, 0.543, 0.983, 1.000)
  style.Colors[clr.WindowBg] = ImVec4(0.000, 0.000, 0.000, 0.895)
  style.Colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
  style.Colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  style.Colors[clr.Border] = ImVec4(0.184, 0.878, 0.000, 0.500)
  style.Colors[clr.BorderShadow] = ImVec4(1.00, 1.00, 1.00, 0.10)
  style.Colors[clr.TitleBg] = ImVec4(0.026, 0.597, 0.000, 1.000)
  style.Colors[clr.TitleBgCollapsed] = ImVec4(0.099, 0.315, 0.000, 0.000)
  style.Colors[clr.TitleBgActive] = ImVec4(0.026, 0.597, 0.000, 1.000)
  style.Colors[clr.MenuBarBg] = ImVec4(0.86, 0.86, 0.86, 1.00)
  style.Colors[clr.ScrollbarBg] = ImVec4(0.000, 0.000, 0.000, 0.801)
  style.Colors[clr.ScrollbarGrab] = ImVec4(0.238, 0.238, 0.238, 1.000)
  style.Colors[clr.ScrollbarGrabHovered] = ImVec4(0.238, 0.238, 0.238, 1.000)
  style.Colors[clr.ScrollbarGrabActive] = ImVec4(0.004, 0.381, 0.000, 1.000)
  style.Colors[clr.CheckMark] = ImVec4(0.009, 0.845, 0.000, 1.000)
  style.Colors[clr.SliderGrab] = ImVec4(0.139, 0.508, 0.000, 1.000)
  style.Colors[clr.SliderGrabActive] = ImVec4(0.139, 0.508, 0.000, 1.000)
  style.Colors[clr.Button] = ImVec4(0.000, 0.000, 0.000, 0.400)
  style.Colors[clr.ButtonHovered] = ImVec4(0.000, 0.619, 0.014, 1.000)
  style.Colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
  style.Colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
  style.Colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
  style.Colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  style.Colors[clr.ResizeGrip] = ImVec4(0.000, 1.000, 0.221, 0.597)
  style.Colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
  style.Colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
  style.Colors[clr.PlotLines] = ImVec4(0.39, 0.39, 0.39, 1.00)
  style.Colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
  style.Colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
  style.Colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  style.Colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
  style.Colors[clr.ModalWindowDarkening] = ImVec4(0.20, 0.20, 0.20, 0.35)

  style.ScrollbarSize = 16.0
  style.GrabMinSize = 8.0
  style.WindowRounding = 0.0

  style.AntiAliasedLines = true
end

function theme6()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

	colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
	colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
	colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
	colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
	colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
	colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
	colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
	colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
	colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
