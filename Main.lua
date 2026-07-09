(function(settings)
	local settings = settings or { -- true for show false to hide
		executor = true, -- your executor
		job = true, -- server you are in needs place id on
		placeid = true, -- game you are in
		country = true, -- country you are in
		theme = Color3.fromRGB(255,0,0) -- theme
	} 

	local Players = game:GetService("Players")

	local get = {
		["executor"] = function()
			if settings.executor then
				local exec, ver = identifyexecutor()
				return exec
			end
			return "Unknown"
		end,
		["job"] = function()
			if settings.job and settings.placeid then
				return game.JobId
			end
			return "0"
		end,
		["placeid"] = function()
			if settings.placeid then
				return game.PlaceId
			end
			return 0
		end
	}


	local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheFortniteFreak/RBXChat/refs/heads/main/API.lua"))()

	if game:HttpGet("https://chat-api-global.momo-momoisreal.workers.dev/") ~= "Chat API Online" then
		error("API IS DOWN", -1)
		return
	end

	local function isInFunction()
		local info = debug.getinfo(3, "f")
		return info ~= nil and info.func ~= nil
	end

	api.Connect("wss://chat-api-global.momo-momoisreal.workers.dev")

	local theme = settings.theme

	local function getcountry()
		local LocalizationService = game:GetService("LocalizationService")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local success, country = pcall(function()
			return LocalizationService:GetCountryRegionForPlayerAsync(player)
		end)
		if success then
			return country
		else
			return "Unknown"
		end
	end

	local function countryToEmoji(countryCode)
		if #countryCode ~= 2 then
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

	get["country"] = function()
		if settings.country then
			return {
		code = getcountry(), 
		flag = countryToEmoji(getcountry()), 
		name = (Countries[getcountry()] or "Unknown")
	}
		end
		return {code = "Unknown",
	flag = countryToEmoji("Unknown"),
	name = "Unknown"}
	end

	local function Send(msg)
		api.Send({
	user = { --basic user info
		username = game:GetService("Players").LocalPlayer.Name, 
		userid = game:GetService("Players").LocalPlayer.UserId,
		displayname = getSuperName(game:GetService("Players").LocalPlayer)
	},
	executor = get.executor(),
	job = game.JobId, 
	placeid = game.PlaceId, 
	country = {
		code = getcountry(), 
		flag = countryToEmoji(getcountry()), 
		name = (Countries[getcountry()] or "Unknown")
	}},
	msg)
	end

	local twin = game:GetService("TweenService")

	local Ui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	local gts = 24/1440*(Ui.AbsoluteSize.Y) -- global text size
	Ui.Name = "RBXChat"
	Ui.ClipToDeviceSafeArea = false
	Ui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	Ui.IgnoreGuiInset = true

	local TeleportService = game:GetService("TeleportService")
	local function playerinf(user, job, placeid, country, executor)
		local canjoin = true
		local contr = country["flag"].." "..country["name"]
		local headshot, isReady = Players:GetUserThumbnailAsync(
			user["userid"],
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
		if job == "0" or placeid == 0 then
			canjoin = false
		end
		local function join()
			if canjoin then
				TeleportService:TeleportToPlaceInstance(placeid,job,game:GetService("Players").LocalPlayer)
			end
		end
		local gameinfo
		if placeid ~= 0 then
			gameinfo = MarketplaceService:GetProductInfo(placeid)
		end
		--ui
		local Frame = Instance.new("Frame", Ui)
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
	end

	local function settings()
		local Frame = Instance.new("Frame", Ui)
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
			queueteleport([[loadstring(game:HttpGet("https://chat-api-global.momo-momoisreal.workers.dev/"))(
				{
		executor = ]]..tostring(settings.executor)..[[,
		job = ]]..tostring(settings.job)..[[,
		placeid = ]]..tostring(settings.placeid)..[[,
		country = ]]..tostring(settings.country)..[[,
		theme = Color3.fromRGB(]]..tostring(settings.theme.R)..[[,]]..tostring(settings.theme.G)..[[,]]..tostring(settings.theme.B)..[[)	
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

	local function addMessage(header, msg, time)
		lo += 1

		local Message = Instance.new("Frame", scroll)
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
		headshot.Size = UDim2.new(0,0,1,0)
		headshot.ScaleType = Enum.ScaleType.Fit
		task.wait()
		headshot.Size = UDim2.new(0,headshot.AbsoluteSize.Y,0.5,0)
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
			playerinf(header["user"],header["job"],header["placeid"],header["country"],header["executor"])
		end)
		local name = Instance.new("TextLabel", user)
		name.AnchorPoint = Vector2.new(0,1)
		name.Position = UDim2.new(0,0,1,0)
		name.Size = UDim2.new(0,headshot.AbsoluteSize.Y,0.5,0)
		name.Text = header["user"]["displayname"]
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextSize = gts
		name.BackgroundTransparency = 1
		name.TextColor3 = Color3.new(1,1,1)
		name.TextStrokeTransparency = 0
		name.TextStrokeColor3 = Color3.new(0,0,0)
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
		local tim = Instance.new("TextLabel", mesg)
		tim.AnchorPoint = Vector2.new(1,1)
		tim.Position = UDim2.new(0.99,0,1,0)
		tim.Size = UDim2.new(0.2,0,0.1,0)
		tim.Text =  getTimeAgo(time)
		tim.TextColor3 = Color3.new(1,1,1)
		tim.BackgroundTransparency = 1
		tim.TextXAlignment = Enum.TextXAlignment.Right
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
			headshot.Size = UDim2.new(0,0,1,0)
			task.wait()
			headshot.Size = UDim2.new(0,headshot.AbsoluteSize.Y,0.5,0)
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
end)({ -- true for show false to hide
		executor = true, -- your executor
		job = true, -- server you are in needs place id on
		placeid = true, -- game you are in
		country = true, -- country you are in
		theme = Color3.fromRGB(255,0,0) -- theme
	})
