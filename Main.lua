(function(settings)
	local HttpService = game:GetService("HttpService")
	for _, folder in {".RBXChat", ".RBXChat/assets"} do
		if not isfolder(folder) then
			makefolder(folder)
		end
	end

	if settings == nil then
		if isfile(".RBXChat/settings.json") then
			settings = HttpService:JSONDecode(readfile(".RBXChat/settings.json"))
		else
			settings = { -- true for show false to hide
				showexecutor = true, -- your executor
				allowjoining = true, -- server you are in needs place id on
				showgame = true, -- game you are in
				showcountry = true, -- country you are in
				theme = "#ff0000", -- theme
				maxmessage = 150, -- -1 for inf
			}
			writefile(".RBXChat/settings.json", HttpService:JSONEncode(settings))
		end
	else
		writefile(".RBXChat/settings.json", HttpService:JSONEncode(settings))
	end
	local maxm = Instance.new("BindableEvent")
	local rcassets = {
		[".RBXChat/assets/settings.png"] = "rbxassetid://1204397029",
		[".RBXChat/assets/copy.png"] = "rbxassetid://95123614768661"
	}
	local waxgetcustomasset = getcustomasset or getsynasset
	local function getcustomasset(asset)
		if waxgetcustomasset then
			local success, result = pcall(function()
				return waxgetcustomasset(asset)
			end)
			if success and result ~= nil and result ~= "" then
				return result
			end
		end
		return rcassets[asset]
	end

	if makefolder and isfolder and writefile and isfile then
		pcall(function()
			local assets = "https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/"
			for path in rcassets do
				if not isfile(path) then
					writefile(path, game:HttpGet((path:gsub(".RBXChat/", assets))))
				end
			end
			if false then writefile(".RBXChat/assets/.nomedia", "") end
		end)
	end

	local Players = game:GetService("Players")

	local get = {
		["showexecutor"] = function()
			if settings.showexecutor then
				local exec, ver = identifyexecutor()
				return exec.." "..ver
			end
			return "Unknown"
		end,
		["allowjoining"] = function()
			if settings.allowjoining and settings.showgame then
				return game.JobId
			end
			return "0"
		end,
		["showgame"] = function()
			if settings.showgame then
				return game.PlaceId
			end
			return 76841226351570
		end,
	}


	local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheFortniteFreak/RBXChat/refs/heads/main/API.lua"))()

	if game:HttpGet("https://chat-api-global.momo-momoisreal.workers.dev/") ~= "Chat API Online" then
		error("API IS DOWN", -1)
		return
	end

	api.Connect("wss://chat-api-global.momo-momoisreal.workers.dev")

	local theme = Color3.fromHex(settings.theme)
	local thmupd = Instance.new("BindableEvent")

	local function getcountry()
		local LocalizationService = game:GetService("LocalizationService")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local success, showcountry = pcall(function()
			return LocalizationService:GetCountryRegionForPlayerAsync(player)
		end)
		if success then
			return showcountry
		else
			return "Unknown"
		end
	end

	local function countryToEmoji(countryCode)
		if #countryCode ~= 2 or countryCode == "Unknown" then
			return "🏳️"
		end

		local first = string.byte(countryCode:upper(), 1) + 127397
		local second = string.byte(countryCode:upper(), 2) + 127397

		return utf8.char(first, second)
	end

	local Countries = {
		AF="Afghanistan", AL="Albania", DZ="Algeria", AS="American Samoa", AD="Andorra",
		AO="Angola", AI="Anguilla", AQ="Antarctica", AG="Antigua and Barbuda", AR="Argentina",
		AM="Armenia", AW="Aruba", AU="Australia", AT="Austria", AZ="Azerbaijan",
		BS="Bahamas", BH="Bahrain", BD="Bangladesh", BB="Barbados", BY="Belarus",
		BE="Belgium", BZ="Belize", BJ="Benin", BM="Bermuda", BT="Bhutan",
		BO="Bolivia", BA="Bosnia and Herzegovina", BW="Botswana", BR="Brazil",
		BN="Brunei", BG="Bulgaria", BF="Burkina Faso", BI="Burundi",
		CV="Cabo Verde", KH="Cambodia", CM="Cameroon", CA="Canada",
		KY="Cayman Islands", CF="Central African Republic", TD="Chad",
		CL="Chile", CN="China", CO="Colombia", KM="Comoros", CG="Congo",
		CD="Democratic Republic of the Congo", CR="Costa Rica", CI="Ivory Coast",
		HR="Croatia", CU="Cuba", CY="Cyprus", CZ="Czechia",
		DK="Denmark", DJ="Djibouti", DM="Dominica", DO="Dominican Republic",
		EC="Ecuador", EG="Egypt", SV="El Salvador", GQ="Equatorial Guinea",
		ER="Eritrea", EE="Estonia", SZ="Eswatini", ET="Ethiopia",
		FJ="Fiji", FI="Finland", FR="France",
		GA="Gabon", GM="Gambia", GE="Georgia", DE="Germany", GH="Ghana",
		GR="Greece", GD="Grenada", GU="Guam", GT="Guatemala", GN="Guinea",
		GW="Guinea-Bissau", GY="Guyana",
		HT="Haiti", HN="Honduras", HK="Hong Kong", HU="Hungary",
		IS="Iceland", IN="India", ID="Indonesia", IR="Iran", IQ="Iraq",
		IE="Ireland", IL="Israel", IT="Italy",
		JM="Jamaica", JP="Japan", JO="Jordan",
		KZ="Kazakhstan", KE="Kenya", KI="Kiribati", KP="North Korea",
		KR="South Korea", KW="Kuwait", KG="Kyrgyzstan",
		LA="Laos", LV="Latvia", LB="Lebanon", LS="Lesotho", LR="Liberia",
		LY="Libya", LI="Liechtenstein", LT="Lithuania", LU="Luxembourg",
		MG="Madagascar", MW="Malawi", MY="Malaysia", MV="Maldives",
		ML="Mali", MT="Malta", MH="Marshall Islands", MR="Mauritania",
		MU="Mauritius", MX="Mexico", FM="Micronesia", MD="Moldova",
		MC="Monaco", MN="Mongolia", ME="Montenegro", MA="Morocco",
		MZ="Mozambique", MM="Myanmar",
		NA="Namibia", NR="Nauru", NP="Nepal", NL="Netherlands",
		NZ="New Zealand", NI="Nicaragua", NE="Niger", NG="Nigeria",
		NO="Norway", MK="North Macedonia",
		OM="Oman",
		PK="Pakistan", PW="Palau", PA="Panama", PG="Papua New Guinea",
		PY="Paraguay", PE="Peru", PH="Philippines", PL="Poland",
		PT="Portugal",
		QA="Qatar",
		RO="Romania", RU="Russia", RW="Rwanda",
		SA="Saudi Arabia", SN="Senegal", RS="Serbia", SG="Singapore",
		SK="Slovakia", SI="Slovenia", SB="Solomon Islands",
		SO="Somalia", ZA="South Africa", ES="Spain", LK="Sri Lanka",
		SD="Sudan", SR="Suriname", SE="Sweden", CH="Switzerland",
		SY="Syria",
		TW="Taiwan", TJ="Tajikistan", TZ="Tanzania", TH="Thailand",
		TL="Timor-Leste", TG="Togo", TO="Tonga", TT="Trinidad and Tobago",
		TN="Tunisia", TR="Turkey", TM="Turkmenistan", TV="Tuvalu",
		UG="Uganda", UA="Ukraine", AE="United Arab Emirates",
		GB="United Kingdom", UN="United Nations", US="United States", UY="Uruguay",
		UZ="Uzbekistan",
		VU="Vanuatu", VA="Vatican City", VE="Venezuela", VN="Vietnam",
		YE="Yemen",
		ZM="Zambia", ZW="Zimbabwe"
	}
	local MarketplaceService = game:GetService("MarketplaceService")

	local function getSuperName(p)
		local name = ""
		if p:IsA("Player") then
			name = p.Name
		else
			return "not a player"
		end
		if p.HasVerifiedBadge then
			name = name .. utf8.char(0xE000)
		end
		if p.HasRobloxSubscription then
			name = name .." ".. utf8.char(0xE003)
		end
		return name
	end

	get["showcountry"] = function()
		if settings.showcountry then
			local c = getcountry()
			return {
		code = c, 
		flag = countryToEmoji(c), 
		name = (Countries[c] or "Unknown")
	}
		end
		return {code = "Unknown",
	flag = countryToEmoji("Unknown"),
	name = "Unknown"}
	end
	local function isPrivate()
		local req = syn and syn.request or http and http.request or http_request or request
		if not req then return false end
		
		local success, res = pcall(req, {
			Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100",
			Method = "GET"
		})
		
		if success and res.Body then
			local data = game:GetService("HttpService"):JSONDecode(res.Body)
			if data and data.data then
				for _, server in ipairs(data.data) do
					if server.id == game.JobId then 
						return false
					end
				end
			end
		end
		return true
	end
	local function Send(msg)
		api.Send({
	user = { --basic user info
		username = game:GetService("Players").LocalPlayer.Name, 
		userid = game:GetService("Players").LocalPlayer.UserId,
		displayname = getSuperName(game:GetService("Players").LocalPlayer)
	},
	showexecutor = get.showexecutor(),
	allowjoining = get.allowjoining(), 
	showgame = get.showgame(), 
	showcountry = get.showcountry(),
	private = isPrivate() or false},msg)
	end

	local twin = game:GetService("TweenService")
	local bih = game:GetService("CoreGui"):FindFirstChild("RBXChat") 
	if bih then
		bih:Destroy()
	end
	local Ui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local gts = 24/1440*(Ui.AbsoluteSize.Y) -- global text size
	Ui.Name = "RBXChat"
	Ui.ClipToDeviceSafeArea = false
	Ui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	Ui.IgnoreGuiInset = true

	local MarketplaceService = game:GetService("MarketplaceService")
	local TeleportService = game:GetService("TeleportService")
	local function playerinf(user, allowjoining, showgame, showcountry, showexecutor, private)
		local canjoin = true
		local contr = showcountry["flag"].." "..showcountry["name"]
		local headshot, isReady = Players:GetUserThumbnailAsync(
			user["userid"],
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
		if allowjoining == "0" or showgame == 76841226351570 then
			canjoin = false
		end
		local function join()
			if canjoin then
				TeleportService:TeleportToPlaceInstance(showgame,allowjoining,game:GetService("Players").LocalPlayer)
			end
		end
		local gameinfo
		if showgame ~= 0 then
			gameinfo = MarketplaceService:GetProductInfo(showgame)
		end
		--ui
		local Frame = Instance.new("Frame", Ui)
		Frame.Size = UDim2.new(0.2,0,0.4,0)
		Frame.AnchorPoint = Vector2.new(0.5,0.5)
		Frame.Position = UDim2.new(0.5,0,0.5,0)
		Frame.BorderSizePixel = 0
		local Move = Instance.new("UIDragDetector", Frame)
		Move.DragRelativity = Enum.UIDragDetectorDragRelativity.Relative
		local Aspect = Instance.new("UIAspectRatioConstraint", Frame)
		Aspect.AspectRatio = 4/3
		Aspect.DominantAxis = Enum.DominantAxis.Height
		Aspect.AspectType = Enum.AspectType.FitWithinMaxSize
		local close = Instance.new("TextButton", Frame)
		close.AnchorPoint = Vector2.new(1,0)
		close.Position = UDim2.new(0.995,0,0.005,0)
		close.TextColor3 = Color3.new(1,0.025,0.025)
		close.Size = UDim2.new(0,0,0.06,0)
		close.BorderSizePixel = 0
		close.Font = Enum.Font.BuilderSansExtraBold
		close.TextYAlignment = Enum.TextYAlignment.Center
		close.TextScaled = true
		task.wait()
		close.Text = "X"
		close.Size = UDim2.new(0,close.AbsoluteSize.Y,0.06,0)
		close.Activated:Connect(function()
			Frame:Destroy()
		end)
		local pfp = Instance.new("ImageLabel", Frame)
		pfp.AnchorPoint = Vector2.new(0,0)
		pfp.Position = UDim2.new(0,0,0.06,0)
		pfp.ScaleType = Enum.ScaleType.Fit
		pfp.Size = UDim2.new(0.3,0,0.3,0)
		pfp.BackgroundTransparency = 1
		pfp.Image = headshot
		local Aspect = Instance.new("UIAspectRatioConstraint", pfp)
		Aspect.AspectRatio = 1
		Aspect.DominantAxis = Enum.DominantAxis.Width
		Aspect.AspectType = Enum.AspectType.FitWithinMaxSize
		local name = Instance.new("TextLabel", Frame)
		name.AnchorPoint = Vector2.new(0,0)
		name.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06,0)
		name.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
		name.Text = user["displayname"]
		while not name.TextFits do
			name.Text = string.sub(name.Text, 1, -4) .. ".."
			if name.Text == ".." then 
				break
			end
		end
		name.TextSize = gts/1.3
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.BackgroundTransparency = 1
		name.BorderSizePixel = 0
		local con = Instance.new("TextLabel", Frame)
		con.AnchorPoint = Vector2.new(0,0)
		con.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06+pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
		con.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
		con.Text = contr
		con.TextSize = gts/1.3
		con.TextXAlignment = Enum.TextXAlignment.Left
		con.BackgroundTransparency = 1
		con.BorderSizePixel = 0
		while not con.TextFits do
			con.Text = string.sub(con.Text, 1, -4) .. ".."
			if con.Text == ".." then 
				break
			end
		end
		local exe = Instance.new("TextLabel", Frame)
		exe.AnchorPoint = Vector2.new(0,0)
		exe.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06+pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3*2,0)
		exe.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
		exe.Text = showexecutor
		exe.TextSize = gts/1.3
		exe.TextXAlignment = Enum.TextXAlignment.Left
		exe.BackgroundTransparency = 1
		exe.BorderSizePixel = 0
		while not exe.TextFits do
			exe.Text = string.sub(exe.Text, 1, -4) .. ".."
			if exe.Text == ".." then 
				break
			end
		end

		local Join = Instance.new("Frame", Frame)
		Join.AnchorPoint = Vector2.new(0,1)
		Join.Position = UDim2.new(0,0,1,0)
		Join.Size = UDim2.new(1,0,0.6,0)
		Join.BackgroundTransparency = 1
		Join.BorderSizePixel = 0

		local btn = Instance.new("TextButton", Join)
		btn.Size = UDim2.new(0.98,0,0.3,0)
		btn.AnchorPoint = Vector2.new(0.5,1)
		btn.Position = UDim2.new(0.5,0,0.98,0)
		btn.BackgroundColor3 = theme
		btn.TextSize = gts
		btn.TextColor3 = Color3.new(1,1,1)
		btn.TextStrokeTransparency = 0
		btn.TextStrokeColor3 = Color3.new(0,0,0)
		btn.BorderSizePixel = 0
		if canjoin or not private then
			btn.Text = "Join"
			btn.Activated:Connect(join)
		else
			btn.Text = "Join (Unavaiable)"
		end
		while not btn.TextFits do
			btn.Text = string.sub(btn.Text, 1, -4) .. ".."
			if btn.Text == ".." then 
				break
			end
		end
		local gamepic = Instance.new("ImageLabel", Join)
		gamepic.AnchorPoint = Vector2.new(0,0)
		gamepic.Position = UDim2.new(0.01,0,0.06,0)
		gamepic.ScaleType = Enum.ScaleType.Fit
		gamepic.Size = UDim2.new(0.3,0,0.6,0)
		gamepic.BackgroundTransparency = 1
		gamepic.BorderSizePixel = 0
		local gamename = Instance.new("TextLabel", Join)
		gamename.AnchorPoint = Vector2.new(0,0)
		gamename.Position = UDim2.new(0.025,gamepic.AbsoluteSize.X,0.06,0)
		gamename.Size = UDim2.new(0.4,0,gamepic.AbsoluteSize.Y/Join.AbsoluteSize.Y/3,0)
		gamename.TextSize = gts/1.3
		gamename.TextXAlignment = Enum.TextXAlignment.Left
		gamename.BackgroundTransparency = 1
		gamename.BorderSizePixel = 0
		while not gamename.TextFits do
			gamename.Text = string.sub(gamename.Text, 1, -4) .. ".."
			if gamename.Text == ".." then 
				break
			end
		end
		local prv = Instance.new("TextLabel", Join)
		prv.AnchorPoint = Vector2.new(0,0)
			prv.Position = UDim2.new(0.025,gamepic.AbsoluteSize.X,0.06+gamepic.AbsoluteSize.Y/Join.AbsoluteSize.Y/3,0)
			prv.Size = UDim2.new(0.4,0,gamepic.AbsoluteSize.Y/Join.AbsoluteSize.Y/3,0)
			prv.TextSize = gts/1.3
		prv.TextXAlignment = Enum.TextXAlignment.Left
		prv.BackgroundTransparency = 1
		prv.BorderSizePixel = 0
		if private or showgame == 76841226351570 then
			prv.Text = "Private server: Yes"
		else
			prv.Text = "Private server: No"
		end
		while not prv.TextFits do
			prv.Text = string.sub(prv.Text, 1, -4) .. ".."
			if prv.Text == ".." then 
				break
			end
		end
		local Aspect2 = Instance.new("UIAspectRatioConstraint", gamepic)
		Aspect2.AspectRatio = 1
		Aspect2.DominantAxis = Enum.DominantAxis.Height
		Aspect2.AspectType = Enum.AspectType.FitWithinMaxSize

		local iconId = gameinfo.IconImageAssetId
		if iconId and iconId > 0 then
			gamepic.Image = "rbxassetid://" .. iconId
		end
		local gameName = gameinfo.Name
		if gameName then
			gamename.Text = "Game: " .. gameName
		end

		thmupd.Event:Connect(function(clr)
			btn.BackgroundColor3 = clr
		end)
		Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			task.wait()
			close.Size = UDim2.new(0,0,0.06,0)
			task.wait()
			close.Size = UDim2.new(0,close.AbsoluteSize.Y,0.06,0)
			prv.Position = UDim2.new(0.025,gamepic.AbsoluteSize.X*2,0.06,0)
			prv.Size = UDim2.new(0.4,0,gamepic.AbsoluteSize.Y/Join.AbsoluteSize.Y/3,0)
			prv.TextSize = gts/1.3
			gamename.TextSize = gts/1.3
			gamename.Position = UDim2.new(0.025,gamepic.AbsoluteSize.X,0.06,0)
			gamename.Size = UDim2.new(0.4,0,gamepic.AbsoluteSize.Y/Join.AbsoluteSize.Y/3,0)
			gts = 24/1440*(Ui.AbsoluteSize.Y)
			name.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06,0)
			name.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
			con.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06+pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
			con.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
			name.TextSize = gts/1.3
			con.TextSize = gts/1.3
			exe.TextSize = gts/1.3
			btn.TextSize = gts
			exe.Position = UDim2.new(0.025,pfp.AbsoluteSize.X,0.06+pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3*2,0)
			exe.Size = UDim2.new(0.4,0,pfp.AbsoluteSize.Y/Frame.AbsoluteSize.Y/3,0)
		end)
	end
	local function settin()
		if Ui:FindFirstChild("Setting") then
			Ui:FindFirstChild("Setting"):Destroy()
		end
		local Frame = Instance.new("Frame", Ui)
		Frame.Name = "Setting"
		Frame.Size = UDim2.new(0.2,0,0.4,0)
		Frame.AnchorPoint = Vector2.new(0.5,0.5)
		Frame.Position = UDim2.new(0.5,0,0.5,0)
		local Move = Instance.new("UIDragDetector", Frame)
		local Aspect = Instance.new("UIAspectRatioConstraint", Frame)
		Aspect.AspectRatio = 4/3
		Aspect.DominantAxis = Enum.DominantAxis.Height
		Aspect.AspectType = Enum.AspectType.FitWithinMaxSize
		local close = Instance.new("TextButton", Frame)
		close.AnchorPoint = Vector2.new(1,0)
		close.Position = UDim2.new(0.995,0,0.005,0)
		close.TextColor3 = Color3.new(1,0.025,0.025)
		close.Size = UDim2.new(0,0,0.06,0)
		close.BorderSizePixel = 0
		close.Font = Enum.Font.BuilderSansExtraBold
		close.TextYAlignment = Enum.TextYAlignment.Center
		close.TextScaled = true
		task.wait()
		close.Text = "X"
		close.Size = UDim2.new(0,close.AbsoluteSize.Y,0.06,0)
		close.Activated:Connect(function()
			Frame:Destroy()
		end)
		local function updjson()
			writefile(".RBXChat/settings.json", HttpService:JSONEncode(settings))
		end
		local function maketoggle(named, setting, par)
			local current = settings[setting]
			local full = Instance.new("Frame", par)
			full.Size = UDim2.new(1,0,1/6,0)
			full.BackgroundTransparency = 1
			full.BorderSizePixel = 0

			local name = Instance.new("TextLabel",full)
			name.Text = named
			name.Size = UDim2.new(0.6,0,0.5,0)
			name.Position = UDim2.new(0.1,0,0.5,0)
			name.AnchorPoint = Vector2.new(0,0.5)
			name.TextSize = gts/1.7
			name.BackgroundTransparency = 1
			name.BorderSizePixel = 0
			name.TextXAlignment = Enum.TextXAlignment.Right

			local tggle = Instance.new("Frame", full)
			tggle.Size = UDim2.new(0.5,0,0.5,0)
			tggle.Position = UDim2.new(0.9,0,0.5,0)
			tggle.AnchorPoint = Vector2.new(1,0.5)
			if current then
				tggle.BackgroundColor3 = Color3.new(0,1,0)
			else
				tggle.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
			end
			local corn = Instance.new("UICorner", tggle)
			corn.CornerRadius = UDim.new(1,0)
			local asp = Instance.new("UIAspectRatioConstraint", tggle)
			asp.AspectRatio = 2/1

			local ball = Instance.new("Frame", tggle)
			ball.Size = UDim2.new(0.85/2,0,0.85,0)
			if current then
				ball.Position = UDim2.new(1-(1-0.85)/4,0,0.5,0)
				ball.AnchorPoint = Vector2.new(1,0.5)
			else
				ball.Position = UDim2.new((1-0.85)/4,0,0.5,0)
				ball.AnchorPoint = Vector2.new(0,0.5)
			end
			ball.BackgroundColor3 = Color3.new(1,1,1)
			local corn2 = Instance.new("UICorner", ball)
			corn2.CornerRadius = UDim.new(1,0)
			local btn = Instance.new("TextButton",tggle)
			btn.Size = UDim2.new(1,0,1,0)
			btn.Text = ""
			btn.BackgroundTransparency = 1
			btn.BorderSizePixel = 0
			btn.Activated:Connect(function()
				current = not current
				settings[setting] = current
				if current then
					tggle.BackgroundColor3 = Color3.new(0,1,0)
				else
					tggle.BackgroundColor3 = Color3.new(0.5,0.5,0.5)
				end
				if current then
					ball.Position = UDim2.new(1-(1-0.85)/4,0,0.5,0)
					ball.AnchorPoint = Vector2.new(1,0.5)
				else
					ball.Position = UDim2.new((1-0.85)/4,0,0.5,0)
					ball.AnchorPoint = Vector2.new(0,0.5)
				end
				updjson()
			end)
			Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				task.wait()
				name.TextSize = gts/1.3
			end)
		end

		local function makec3(named, setting, par)
			local current = Color3.fromHex(settings[setting])
			local full = Instance.new("Frame", par)
			full.Size = UDim2.new(1,0,1/6,0)
			full.BackgroundTransparency = 1
			full.BorderSizePixel = 0

			local name = Instance.new("TextLabel",full)
			name.Text = named
			name.Size = UDim2.new(0.6,0,0.5,0)
			name.Position = UDim2.new(0.1,0,0.5,0)
			name.AnchorPoint = Vector2.new(0,0.5)
			name.TextSize = gts/1.7
			name.BackgroundTransparency = 1
			name.BorderSizePixel = 0
			name.TextXAlignment = Enum.TextXAlignment.Right

			local tggle = Instance.new("TextBox", full)
			tggle.Size = UDim2.new(0.5,0,0.5,0)
			tggle.Position = UDim2.new(0.9,0,0.5,0)
			tggle.AnchorPoint = Vector2.new(1,0.5)
			tggle.Text = "#"..current:ToHex()
			tggle.PlaceholderText = "Hex"
			tggle.TextSize = gts/1.75
			tggle.ClearTextOnFocus = false
			local asp = Instance.new("UIAspectRatioConstraint", tggle)
			asp.AspectRatio = 2/1
			
			tggle.FocusLost:Connect(function()
				local clr = Color3.fromHex(tggle.Text) or nil
				if clr then
					current = clr
					theme = clr
					settings[setting] = tggle.Text
					thmupd:Fire(clr)
				end
				updjson()
			end)

			Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				task.wait()
				name.TextSize = gts/1.7
				tggle.TextSize = gts/1.75
			end)
		end

		local function makenum(named, setting, par)
			local current = settings[setting]
			local full = Instance.new("Frame", par)
			full.Size = UDim2.new(1,0,1/6,0)
			full.BackgroundTransparency = 1
			full.BorderSizePixel = 0

			local name = Instance.new("TextLabel",full)
			name.Text = named
			name.Size = UDim2.new(0.6,0,0.5,0)
			name.Position = UDim2.new(0.1,0,0.5,0)
			name.AnchorPoint = Vector2.new(0,0.5)
			name.TextSize = gts/1.7
			name.BackgroundTransparency = 1
			name.BorderSizePixel = 0
			name.TextXAlignment = Enum.TextXAlignment.Right

			local tggle = Instance.new("TextBox", full)
			tggle.Size = UDim2.new(0.5,0,0.5,0)
			tggle.Position = UDim2.new(0.9,0,0.5,0)
			tggle.AnchorPoint = Vector2.new(1,0.5)
			tggle.Text = tostring(current)
			tggle.PlaceholderText = "Number (float)"
			tggle.TextSize = gts/1.75
			tggle.ClearTextOnFocus = false
			local asp = Instance.new("UIAspectRatioConstraint", tggle)
			asp.AspectRatio = 2/1
			
			tggle.FocusLost:Connect(function()
				local num = tonumber(tggle.Text)
				if num then
					current = num
					settings[setting] = num
				end
				updjson()
			end)

			Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				task.wait()
				name.TextSize = gts/1.7
				tggle.TextSize = gts/1.75
			end)
		end

		local sframe = Instance.new("Frame", Frame)
		sframe.Size = UDim2.new(1,0,1,-close.AbsoluteSize.X)
		sframe.Position = UDim2.new(0,0,1,0)
		sframe.AnchorPoint = Vector2.new(0,1)
		sframe.BackgroundTransparency = 1
		sframe.BorderSizePixel = 0
		local list = Instance.new("UIListLayout", sframe)
		list.FillDirection = Enum.FillDirection.Vertical

		maketoggle("Show Executor","showexecutor",sframe)
		maketoggle("Show Game","showgame",sframe)
		maketoggle("Allow Joining (Needs Show Game)","allowjoining",sframe)
		maketoggle("Show Country","showcountry",sframe)
		makec3("Theme Color", "theme",sframe)
		makenum("Max Messages", "maxmessage",sframe)
	end



	local MainFrame = Instance.new("Frame", Ui)
	MainFrame.AnchorPoint = Vector2.new(0.5,0)
	MainFrame.Position = UDim2.new(0.5,0,0,0)
	MainFrame.Size = UDim2.new(1,0,0.5,0)
	MainFrame.BorderSizePixel = 0
	MainFrame.BackgroundColor3 = Color3.new(1,1,1)

	local grad = Instance.new("UIGradient", MainFrame)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
		ColorSequenceKeypoint.new(0.125, Color3.new(0,0,0)),
		ColorSequenceKeypoint.new(1, theme)
	}
	grad.Rotation = -90

	local Aspect = Instance.new("UIAspectRatioConstraint", MainFrame)
	Aspect.AspectRatio = 5/3
	Aspect.DominantAxis = Enum.DominantAxis.Height
	Aspect.AspectType = Enum.AspectType.FitWithinMaxSize
	local function togglevisibility()
		local newY = 1
		
		if MainFrame.AnchorPoint.Y == 1 then
			newY = 0
		end
		
		local tweenInfo = TweenInfo.new(
			0.5,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		)

		local tween = twin:Create(MainFrame, tweenInfo, {
			AnchorPoint = Vector2.new(MainFrame.AnchorPoint.X, newY)
		})

		tween:Play()
	end
	local shide = Instance.new("TextButton", MainFrame)
	local Aspect2 = Instance.new("UIAspectRatioConstraint", shide)
	Aspect2.AspectRatio = 1
	shide.Text = "<"
	shide.Rotation = 90
	shide.AnchorPoint = Vector2.new(0,0)
	shide.Position = UDim2.new(0,0,1,0)
	shide.Size = UDim2.new(0.05,0,0.05,0)
	shide.TextScaled = true
	shide.TextColor3 = theme
	shide.TextStrokeTransparency = 0
	shide.TextStrokeColor3 = Color3.new(0,0,0)
	shide.BackgroundTransparency = 1
	shide.Activated:Connect(function()
		local tween = twin:Create(shide, TweenInfo.new(
			0.5,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		), {
			Rotation = shide.Rotation + 180
		})

		tween:Play()
		togglevisibility()
	end)

	local sett = Instance.new("ImageButton", MainFrame)
	local Aspect3 = Instance.new("UIAspectRatioConstraint", sett)
	Aspect3.AspectRatio = 1
	sett.Image = getcustomasset(".RBXChat/assets/settings.png")
	sett.AnchorPoint = Vector2.new(1,0)
	sett.Position = UDim2.new(1,0,1,0)
	sett.Size = UDim2.new(0.05,0,0.05,0)
	sett.ImageColor3 = theme
	sett.BackgroundTransparency = 1
	sett.Activated:Connect(settin)

	local input = Instance.new("Frame", MainFrame)
	input.AnchorPoint = Vector2.new(0.5,1)
	input.Position = UDim2.new(0.5,0,0.985,0)
	input.Size = UDim2.new(0.98,0,0.125,0)
	input.BackgroundTransparency = 1
	local text = Instance.new("TextBox", input)
	text.AnchorPoint = Vector2.new(0,0)
	text.Position = UDim2.new(0,0,0,0)
	text.Size = UDim2.new(0.79,0,1,0)
	text.Text = ""
	text.PlaceholderText = "Message Here!"
	text.TextSize = gts
	text.TextColor3 = Color3.new(1,1,1)
	text.BackgroundTransparency = 1
	text.ClearTextOnFocus = false

	local strk = Instance.new("UIStroke", text)
	strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	strk.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	strk.Thickness = 0.01
	strk.Color = Color3.new(0.5,0.5,0.5)

	local submitt = Instance.new("TextButton", input)
	submitt.AnchorPoint = Vector2.new(1,0)
	submitt.Position = UDim2.new(1,0,0,0)
	submitt.Size = UDim2.new(0.19,0,1,0)
	submitt.Text = "Send"
	submitt.TextSize = gts
	submitt.TextColor3 = Color3.new(1,1,1)
	submitt.BackgroundColor3 = theme
	submitt.TextStrokeTransparency = 0
	submitt.TextStrokeColor3 = Color3.new(0,0,0)

	submitt.Activated:Connect(function()
		if text.Text == "" then return end
		Send(text.Text)
		text.Text = ""
	end)

	local scroll = Instance.new("ScrollingFrame", MainFrame)
	scroll.AnchorPoint = Vector2.new(0.5,0)
	scroll.Position = UDim2.new(0.5,0,0.015,0)
	scroll.Size = UDim2.new(0.98,0,0.825,0)
	scroll.BackgroundTransparency = 1
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.ScrollBarThickness = 0


	local RunService = game:GetService("RunService")

	local function getTimeAgo(timestamp)
		local diff = os.time() - timestamp

		if diff < 60 then
			return "just now"
		elseif diff < 3600 then
			return math.floor(diff / 60) .. " min"
		elseif diff < 86400 then
			return math.floor(diff / 3600) .. " hour"
		elseif diff < 604800 then
			return math.floor(diff / 86400) .. " day"
		else
			return math.floor(diff / 604800) .. " week"
		end
	end


	local lo = 0

	local queueteleport =  queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
	game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
		if queueteleport then
			queueteleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/TheFortniteFreak/RBXChat/refs/heads/main/Main.lua"))()(
				{
		showexecutor = ]]..tostring(settings.showexecutor)..[[,
		allowjoining = ]]..tostring(settings.allowjoining)..[[,
		showgame = ]]..tostring(settings.showgame)..[[,
		showcountry = ]]..tostring(settings.showcountry)..[[,
		theme = Color3.fromHex("#]]..settings.theme..[["),	
		maxmessage = ]]..tostring(settings.maxmessage)..[[,		
				}
			)]])
		end
	end)

	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0,gts/2)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.FillDirection = Enum.FillDirection.Vertical
	list.VerticalAlignment = Enum.VerticalAlignment.Bottom
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y)
		scroll.CanvasPosition = Vector2.new(0, math.max(0, list.AbsoluteContentSize.Y - scroll.AbsoluteWindowSize.Y))
	end)
	local msgs = {}
	local function addMessage(header, msg, time)
		lo += 1

		local Message = Instance.new("Frame", scroll)
		msgs[lo] = Message
		if #msgs > settings.maxmessage-1 then
			for i,v in ipairs(msgs) do
				if i < lo - (settings.maxmessage-1) then
					pcall(function()
						v:Destroy()
					end)
				else
					break
				end
			end
		end
		Message.Size = UDim2.new(0.99,0,0,scroll.AbsoluteSize.Y * 0.25)
		Message.BackgroundTransparency = 1

		local imageUrl, isReady = Players:GetUserThumbnailAsync(
			header["user"]["userid"],
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
		local user = Instance.new("Frame", Message)
		user.AnchorPoint = Vector2.new(0,0)
		user.Position = UDim2.new(0,0,0,0)
		user.Size = UDim2.new(0.20,0,1,0)
		user.BackgroundTransparency = 1
		local headshot = Instance.new("ImageLabel", user)
		headshot.AnchorPoint = Vector2.new(0,0)
		headshot.Position = UDim2.new(0,0,0,0)
		headshot.Size = UDim2.new(0.6,0,0.6,0)
		headshot.ScaleType = Enum.ScaleType.Fit
		local Aspect = Instance.new("UIAspectRatioConstraint", headshot)
		Aspect.AspectRatio = 1
		Aspect.DominantAxis = Enum.DominantAxis.Width
		Aspect.AspectType = Enum.AspectType.FitWithinMaxSize
		headshot.BackgroundTransparency = 1
		headshot.Image = imageUrl
		local open = Instance.new("TextButton", user)
		open.Text = ""
		open.Size = UDim2.new(1,0,1,0)
		open.Position = UDim2.new(0,0,0,0)
		open.AnchorPoint = Vector2.new(0,0)
		open.BackgroundTransparency = 1
		open.BorderSizePixel = 0
		open.Activated:Connect(function()
			playerinf(header["user"],header["allowjoining"],header["showgame"],header["showcountry"],header["showexecutor"],header["private"])
		end)
		local name = Instance.new("TextLabel", user)
		name.AnchorPoint = Vector2.new(0,1)
		name.Position = UDim2.new(0,0,1,0)
		name.Size = UDim2.new(1,0,0.4,0)
		name.Text = header["user"]["displayname"]
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextSize = gts
		name.BackgroundTransparency = 1
		name.TextColor3 = Color3.new(1,1,1)
		name.TextStrokeTransparency = 0
		name.TextStrokeColor3 = Color3.new(0,0,0)

		while not name.TextFits do
			name.Text = string.sub(name.Text, 1, -4) .. ".."
			if name.Text == ".." then 
				break
			end
		end
		local mesg = Instance.new("TextLabel", Message)
		mesg.AnchorPoint = Vector2.new(1,0)
		mesg.Position = UDim2.new(1,0,0,0)
		mesg.Size = UDim2.new(0.78,0,1,0)
		mesg.Text = msg
		mesg.TextXAlignment = Enum.TextXAlignment.Left
		mesg.TextSize = gts
		mesg.BackgroundTransparency = 1
		mesg.TextColor3 = Color3.new(1,1,1)
		mesg.TextStrokeTransparency = 0
		mesg.TextStrokeColor3 = Color3.new(0,0,0)

		while not mesg.TextFits do
			mesg.Text = string.sub(mesg.Text, 1, -4) .. ".."
			if mesg.Text == ".." then 
				break
			end
		end
		local copy = Instance.new("ImageButton", mesg)
		copy.AnchorPoint = Vector2.new(0,0)
		copy.Position = UDim2.new(0,0,0,0)
		copy.Size = UDim2.new(0.05,0,0.2,0)
		copy.Image = getcustomasset(".RBXChat/assets/copy.png")
		copy.BackgroundTransparency = 1
		local Aspect3 = Instance.new("UIAspectRatioConstraint", copy)
		Aspect3.AspectRatio = 1
		copy.Activated:Connect(function()
			setclipboard(msg)
		end)
		local tim = Instance.new("TextLabel", Message)
		tim.AnchorPoint = Vector2.new(1,1)
		tim.Position = UDim2.new(0.99,0,1,0)
		tim.Size = UDim2.new(0.2,0,0.1,0)
		tim.Text =  getTimeAgo(time)
		tim.TextColor3 = Color3.new(1,1,1)
		tim.BackgroundTransparency = 1
		tim.TextXAlignment = Enum.TextXAlignment.Right
		tim.TextStrokeTransparency = 0
		tim.TextStrokeColor3 = Color3.new(0,0,0)
		task.spawn(function()
			while wait(10) and tim.Parent do
				local tag = getTimeAgo(time)
				if tag ~= "just now" then
					tim.Text =  tag .. " ago"
				else
					tim.Text =  tag
				end
			end
		end)
		Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			task.wait()
			mesg.TextSize = gts
			name.TextSize = gts
			Message.Size = UDim2.new(0.99,0,0,scroll.AbsoluteSize.Y * 0.25)
		end)
		local strks = Instance.new("UIStroke", Message)
		strks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		strks.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		strks.BorderStrokePosition = Enum.BorderStrokePosition.Outer
		strks.Thickness = 0.02
		strks.Color = Color3.new(0.5,0.5,0.5)
	end

	api.MessageReceived.Event:Connect(addMessage)

	Ui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		gts = 24/1440*(Ui.AbsoluteSize.Y)
		text.TextSize = gts
		submitt.TextSize = gts
		list.Padding = UDim.new(0,gts/2)
	end)
	thmupd.Event:Connect(function(clr)
		grad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
			ColorSequenceKeypoint.new(0.125, Color3.new(0,0,0)),
			ColorSequenceKeypoint.new(1, clr)
		}
		submitt.BackgroundColor3 = clr
		shide.TextColor3 = clr
		sett.ImageColor3 = clr
	end)
end)()
