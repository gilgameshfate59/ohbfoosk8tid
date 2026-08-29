if getgenv().CitraLoader and getgenv().CitraLoader.Destroy then
	pcall(getgenv().CitraLoader.Destroy)
end

local HUB = "Citra"
local LOGO = "rbxassetid://95077438762744"
local DISCORD = "https://discord.gg/yTUe6JNhCx"
local FOLDER = "Citra"
local ACCEPT_FILE = FOLDER .. "/terms.txt"

local SCRIPT_REPO = "https://raw.githubusercontent.com/gilgameshfate59/ohbfoosk8tid/main/"
local MANIFEST_URL = SCRIPT_REPO .. "scripts.json"

local C = {
	Background = Color3.fromRGB(10, 10, 12),
	Section    = Color3.fromRGB(15, 15, 18),
	Element    = Color3.fromRGB(20, 20, 24),
	Light      = Color3.fromRGB(28, 28, 33),
	Hover      = Color3.fromRGB(38, 36, 40),
	Line       = Color3.fromRGB(26, 26, 30),
	Text       = Color3.fromRGB(245, 245, 247),
	DimText    = Color3.fromRGB(124, 124, 132),
	Accent     = Color3.fromRGB(255, 138, 32),
	Good       = Color3.fromRGB(76, 214, 148),
	Warn       = Color3.fromRGB(255, 186, 60),
	Bad        = Color3.fromRGB(229, 72, 77),
}

local cloneref = cloneref or function(o) return o end

local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local GuiService = cloneref(game:GetService("GuiService"))

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local hasFiles = (isfile and writefile and isfolder and makefolder) and true or false

local FONT = Enum.Font.FredokaOne

local TAP = IsMobile and 44 or 32
local setclip = setclipboard or (syn and syn.setclipboard)

local function Run(fn, ...)
	local ok, err = pcall(fn, ...)
	if not ok then warn("[" .. HUB .. "] " .. tostring(err)) end
	return ok
end

local function GetHui()
	if gethui then
		local ok, h = pcall(gethui)
		if ok and h then return h end
	end
	return cloneref(game:GetService("CoreGui"))
end

local function New(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function Corner(r, parent)
	return New("UICorner", { CornerRadius = UDim.new(0, r) }, parent)
end

local function Stroke(color, thickness, parent)
	return New("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function Text(parent, props)
	local t = New("TextLabel", {
		BackgroundTransparency = 1,
		Font = FONT,
		Text = props.Text or "",
		TextSize = props.Size or 14,
		TextColor3 = props.Color or C.Text,
		TextXAlignment = props.Align or Enum.TextXAlignment.Left,
		TextWrapped = props.Wrap or false,
		TextTruncate = props.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None,
		Position = props.Pos or UDim2.fromOffset(0, 0),
		Size = props.Box or UDim2.new(1, 0, 1, 0),
		AnchorPoint = props.Anchor or Vector2.new(0, 0),
		ZIndex = props.Z or 2,
		BorderSizePixel = 0,
	}, parent)
	return t
end

local function Tween(o, props, time, style)
	local tw = TweenService:Create(o,
		TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		props)
	tw:Play()
	return tw
end

local function Button(parent, props)
	local frame = New("Frame", {
		BackgroundColor3 = props.Fill or C.Element,
		Position = props.Pos or UDim2.fromOffset(0, 0),
		Size = props.Box or UDim2.new(1, 0, 0, 34),
		AnchorPoint = props.Anchor or Vector2.new(0, 0),
		ZIndex = props.Z or 2,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, parent)
	Corner(props.Radius or 8, frame)
	if props.Outline then Stroke(C.Line, 1, frame) end

	local label = Text(frame, {
		Text = props.Text or "",
		Size = props.TextSize or 14,
		Color = props.TextColor or C.Text,
		Align = Enum.TextXAlignment.Center,
		Bold = props.Bold,
		Z = (props.Z or 2) + 1,
	})

	local hit = New("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = (props.Z or 2) + 2,
		BorderSizePixel = 0,
	}, frame)

	local base = frame.BackgroundColor3
	local enabled = true

	hit.MouseEnter:Connect(function()
		if enabled then Tween(frame, { BackgroundColor3 = base:Lerp(Color3.new(1,1,1), 0.10) }, 0.12) end
	end)
	hit.MouseLeave:Connect(function()
		if enabled then Tween(frame, { BackgroundColor3 = base }, 0.12) end
	end)

	local api = { Frame = frame, Label = label, Hit = hit }

	function api:SetEnabled(on)
		enabled = on
		frame.BackgroundTransparency = on and 0 or 0.55
		label.TextTransparency = on and 0 or 0.55
		hit.Active = on
	end

	function api:SetText(s) label.Text = s end
	function api:SetFill(col) base = col frame.BackgroundColor3 = col end

	function api:OnClick(fn)
		hit.MouseButton1Click:Connect(function()
			if enabled then fn() end
		end)
	end

	return api
end

local function EnsureFolder()
	if not hasFiles then return end
	if not isfolder(FOLDER) then Run(makefolder, FOLDER) end
end

local function TermsAccepted()
	if not hasFiles then return false end
	EnsureFolder()
	return isfile(ACCEPT_FILE)
end

local function AcceptTerms()
	if not hasFiles then return end
	EnsureFolder()
	Run(writefile, ACCEPT_FILE, tostring(os.time()))
end

local CATALOGUE = {
	{
		Name = "Redliner",
		File = "RLINER.lua",
		Universe = 7265339759,
		Places = { 94987506187454 },
		Status = "Working",
	},
	{
		Name = "QuickDraw: Legacy",
		File = "QDL_Aim_Citra.lua",
		Universe = 5371687033,
		Places = { 15561786880 },
		Status = "Working",
	},
	{
		Name = "Practical Basketball",
		File = "PRACTICALBASKETBALL.lua",
		Universe = 7529591378,
		Places = { 85576197307056 },
		Status = "Working",
	},
	{
		Name = "Jujutsu: Zero",
		File = "JJZERO.lua",
		Universe = 6760085372,
		Places = { 128451689942376 },
		Status = "Working",
	},
	{
		Name = "Dueling Grounds",
		File = "DUELINGGROUNDS.lua",
		Universe = 9051406594,
		Places = { 94217045453265 },
		Status = "Working",
	},
	{
		Name = "Azure Latch",
		File = "AZURELATCH.lua",
		Universe = 6945584306,
		Places = { 94647229517154 },
		Status = "Working",
	},
}

local function Normalise(raw)
	if type(raw) ~= "table" then return nil end

	local name = raw.Name or raw.name
	if type(name) ~= "string" then return nil end

	local function ids(...)
		local out = {}
		for _, key in ipairs({ ... }) do
			local v = raw[key]
			if type(v) == "number" then
				out[#out + 1] = v
			elseif type(v) == "table" then
				for _, id in ipairs(v) do
					local n = tonumber(id)
					if n then out[#out + 1] = n end
				end
			end
		end
		return out
	end

	local universes = ids("Universe", "universe", "Universes", "universes",
		"GameId", "gameId", "GameIds", "gameIds")

	return {
		Name = name,
		Url = raw.Url or raw.url or (SCRIPT_REPO .. (raw.File or raw.file or "")),
		Places = ids("Places", "places", "PlaceIds", "placeIds", "Place", "place"),
		Universes = universes,
		Universe = universes[1],
		Status = raw.Status or raw.status or "Working",
	}
end

local function ApplyCatalogue(list)
	local out = {}
	for _, raw in ipairs(list or {}) do
		local e = Normalise(raw)
		if e then out[#out + 1] = e end
	end
	if #out > 0 then CATALOGUE = out end
end

ApplyCatalogue(CATALOGUE)

local function EntryForPlace()
	local pid, uid = game.PlaceId, game.GameId

	for _, e in ipairs(CATALOGUE) do
		for _, id in ipairs(e.Universes or {}) do
			if id == uid then return e end
		end
	end

	for _, e in ipairs(CATALOGUE) do
		for _, id in ipairs(e.Places or {}) do
			if id == pid then return e end
		end
	end

	return nil
end

local gui = New("ScreenGui", {
	Name = HttpService:GenerateGUID(false),
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999999,
})

Run(function() gui.Parent = GetHui() end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Backdrop = New("TextButton", {
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 1,
	Size = UDim2.fromScale(1, 1),
	Text = "",
	AutoButtonColor = false,
	Modal = true,
	ZIndex = 1,
}, gui)

local MAX_W, MAX_H = 760, 560
local HEADER_H, FOOTER_H = 58, 52

local function Metrics()
	local vp = Camera.ViewportSize
	local w = math.min(MAX_W, math.floor(vp.X * 0.88))
	local h = math.min(MAX_H, math.floor(vp.Y * 0.80))
	return math.max(300, w), math.max(260, h)
end

local Card = New("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(Metrics()),
	BackgroundColor3 = C.Background,
	BorderSizePixel = 0,
	ZIndex = 2,
	ClipsDescendants = true,
}, gui)
Corner(14, Card)
Stroke(C.Line, 1, Card)

local Header = New("Frame", {
	BackgroundColor3 = C.Section,
	Size = UDim2.new(1, 0, 0, HEADER_H),
	BorderSizePixel = 0,
	ZIndex = 3,
}, Card)

New("ImageLabel", {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 16, 0.5, 0),
	Size = UDim2.fromOffset(30, 30),
	BackgroundTransparency = 1,
	Image = LOGO,
	ScaleType = Enum.ScaleType.Fit,
	ZIndex = 4,
}, Header)

Text(Header, {
	Text = HUB,
	Size = 19,
	Bold = true,
	Anchor = Vector2.new(0, 0.5),
	Pos = UDim2.new(0, 56, 0.5, 0),
	Box = UDim2.fromOffset(160, 24),
	Z = 4,
})

local HeaderNote = Text(Header, {
	Text = "",
	Size = 12,
	Color = C.DimText,
	Anchor = Vector2.new(1, 0.5),
	Pos = UDim2.new(1, -46, 0.5, 0),
	Box = UDim2.fromOffset(300, 20),
	Align = Enum.TextXAlignment.Right,
	Truncate = true,
	Z = 4,
})

local CloseBtn = New("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -14, 0.5, 0),
	Size = UDim2.fromOffset(26, 26),
	BackgroundTransparency = 1,
	Text = "",
	AutoButtonColor = false,
	ZIndex = 5,
}, Header)

for _, rot in ipairs({ 45, -45 }) do
	New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(15, 1.5),
		BackgroundColor3 = C.DimText,
		BorderSizePixel = 0,
		Rotation = rot,
		ZIndex = 5,
	}, CloseBtn)
end

New("Frame", {
	Position = UDim2.fromOffset(0, HEADER_H),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = C.Line,
	BorderSizePixel = 0,
	ZIndex = 4,
}, Card)

local Footer = New("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, FOOTER_H),
	BackgroundColor3 = C.Section,
	BorderSizePixel = 0,
	ZIndex = 3,
}, Card)

New("Frame", {
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = C.Line,
	BorderSizePixel = 0,
	ZIndex = 4,
}, Footer)

local FooterText = Text(Footer, {
	Text = DISCORD,
	Size = 12,
	Color = C.DimText,
	Anchor = Vector2.new(0, 0.5),
	Pos = UDim2.new(0, 16, 0.5, 0),
	Box = UDim2.fromOffset(320, 20),
	Truncate = true,
	Z = 4,
})

local CopyBtn = Button(Footer, {
	Text = "Copy Discord",
	Anchor = Vector2.new(1, 0.5),
	Pos = UDim2.new(1, -108, 0.5, 0),
	Box = UDim2.fromOffset(120, 30),
	TextSize = 13,
	Fill = C.Element,
	Outline = true,
	Z = 4,
})

local TermsBtn = Button(Footer, {
	Text = "Terms",
	Anchor = Vector2.new(1, 0.5),
	Pos = UDim2.new(1, -14, 0.5, 0),
	Box = UDim2.fromOffset(84, 30),
	TextSize = 13,
	Fill = C.Element,
	Outline = true,
	Z = 4,
})

local Body = New("Frame", {
	Position = UDim2.fromOffset(0, HEADER_H + 1),
	Size = UDim2.new(1, 0, 1, -(HEADER_H + FOOTER_H + 1)),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 3,
	ClipsDescendants = true,
}, Card)

local function Resize()
	local w, h = Metrics()
	Card.Size = UDim2.fromOffset(w, h)
	Body.Size = UDim2.new(1, 0, 1, -(HEADER_H + FOOTER_H + 1))

	FooterText.Visible = w > 520
end

Resize()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	task.wait()
	Resize()
end)

local Screens = {}

local function ClearBody()
	for _, c in ipairs(Body:GetChildren()) do c:Destroy() end
end

local function Show(name, ...)
	ClearBody()
	Screens[name](...)
end

local TERMS = [[CITRA - TERMS OF SERVICE

By executing Citra scripts, purchasing Citra products or participating in the
Citra Hub Discord, you agree to these Terms of Service.

1 - LICENSE & ACCESS
Citra products are licensed for personal use only. Keys, licenses, and access
may not be shared, sold, transferred, or used by unauthorized users.

2 - YOUR ACCOUNT, YOUR RISK
Using any executor can get a Roblox account moderated or banned. You accept that
risk yourself. Do not use Citra on an account you are not prepared to lose.

3 - REFUNDS
Refunds may be requested within 24 hours of purchase, provided the purchased
key/license has not been redeemed, activated, or used.

Once a key/license has been redeemed or used, the purchase is non-refundable,
except where required by applicable law.

Please contact Citra support before opening a payment dispute or chargeback.

4 - SECURITY & ABUSE
Attempting to bypass, exploit, or interfere with Citra's licensing or security
systems is prohibited.

5 - SERVICE & UPDATES
Citra does not guarantee uninterrupted or permanent functionality. Roblox and
other third-party updates may affect products.

Citra may update, modify, suspend, replace, or discontinue products or features
when necessary.

6 - COMMUNITY & ENFORCEMENT
Respect members and staff. Harassment, threats, NSFW content, scams, malicious
links/files, impersonation, excessive spam, unauthorized advertising, and
intentional server disruption are prohibited.

Staff may warn, restrict, mute, remove, or terminate users who violate these
terms.

Loading a script means you agree to all of the above.]]

function Screens.Terms(readOnly)

	local cardH = select(2, Metrics())
	local compact = cardH < 420

	local pad = compact and 12 or 16
	local titleH = compact and 34 or 42
	local rowH = readOnly and 0 or (compact and 34 or 40)
	local btnH = compact and 32 or 36
	local gap = compact and 12 or 20

	Text(Body, {
		Text = readOnly and "Terms of Service" or "Before you continue",
		Size = compact and 15 or 17,
		Bold = true,
		Pos = UDim2.fromOffset(pad, compact and 8 or 12),
		Box = UDim2.new(1, -pad * 2, 0, 22),
		Z = 4,
	})

	local scroll = New("ScrollingFrame", {
		Position = UDim2.fromOffset(pad, titleH),
		Size = UDim2.new(1, -pad * 2, 1, -(titleH + rowH + btnH + gap)),
		BackgroundColor3 = C.Section,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ScrollBarThickness = IsMobile and 6 or 3,
		ScrollBarImageColor3 = C.DimText,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = true,

		Active = true,
		ElasticBehavior = Enum.ElasticBehavior.Always,
		ZIndex = 4,
	}, Body)
	Corner(8, scroll)

	New("UIPadding", {
		PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
	}, scroll)

	local body = Text(scroll, {
		Text = TERMS,
		Size = 13,
		Color = C.DimText,
		Wrap = true,
		Box = UDim2.new(1, 0, 0, 0),
		Z = 5,
	})
	body.AutomaticSize = Enum.AutomaticSize.Y

	local function FitCanvas()
		scroll.CanvasSize = UDim2.fromOffset(0, body.AbsoluteSize.Y + 24)
	end

	body:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitCanvas)
	scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(FitCanvas)
	task.defer(FitCanvas)

	if readOnly then
		local back = Button(Body, {
			Text = "Back",
			Anchor = Vector2.new(0.5, 1),
			Pos = UDim2.new(0.5, 0, 1, -10),
			Box = UDim2.fromOffset(160, btnH),
			Fill = C.Element,
			Outline = true,
			Z = 4,
		})
		back:OnClick(function() Show("Catalogue") end)
		return
	end

	local row = New("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, pad, 1, -(btnH + (compact and 8 or 14))),
		Size = UDim2.new(1, -pad * 2, 0, compact and 26 or 32),
		BackgroundTransparency = 1,
		ZIndex = 4,
	}, Body)

	local box = New("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(20, 20),
		BackgroundColor3 = C.Element,
		BorderSizePixel = 0,
		ZIndex = 5,
	}, row)
	Corner(5, box)
	Stroke(C.Line, 1, box)

	local tick = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 6,
	}, box)
	Corner(3, tick)

	Text(row, {
		Text = "I have read and agree to the Terms of Service",
		Size = 13,
		Pos = UDim2.fromOffset(30, 0),
		Box = UDim2.new(1, -30, 1, 0),
		Truncate = true,
		Z = 5,
	})

	local hit = New("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 7,
	}, row)

	local cont = Button(Body, {
		Text = "Continue",
		Anchor = Vector2.new(0, 1),
		Pos = UDim2.new(0, pad, 1, -10),
		Box = UDim2.new(1, -pad * 2, 0, btnH),
		Fill = C.Accent,
		TextColor = Color3.new(1, 1, 1),
		Bold = true,
		Z = 4,
	})
	cont:SetEnabled(false)

	local agreed = false

	hit.MouseButton1Click:Connect(function()
		agreed = not agreed
		tick.Visible = agreed
		Tween(box, { BackgroundColor3 = agreed and C.Accent or C.Element }, 0.12)
		cont:SetEnabled(agreed)
	end)

	cont:OnClick(function()
		if not agreed then return end
		AcceptTerms()
		Show("Catalogue")
	end)

	if not hasFiles then
		HeaderNote.Text = "no file access - terms will be asked again next launch"
	end
end

local Confirm

function Screens.Catalogue()
	local pad = 14
	local here = EntryForPlace()

	local order = {}
	if here then order[#order + 1] = here end
	for _, e in ipairs(CATALOGUE) do
		if e ~= here then order[#order + 1] = e end
	end

	local scroll = New("ScrollingFrame", {
		Position = UDim2.fromOffset(pad, 10),
		Size = UDim2.new(1, -pad * 2, 1, -20),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.DimText,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ZIndex = 4,
	}, Body)

	local grid = New("UIGridLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		CellPadding = UDim2.fromOffset(12, 12),
		CellSize = UDim2.fromOffset(200, 214 + (TAP - 32)),
	}, scroll)

	local function Reflow()
		local avail = scroll.AbsoluteSize.X
		if avail <= 0 then return end

		local want = 200
		local cols = math.max(1, math.floor((avail + 12) / (want + 12)))
		local cell = math.floor((avail - (cols - 1) * 12) / cols)

		grid.CellSize = UDim2.fromOffset(cell, (cell < 170 and 190 or 214) + (TAP - 32))
	end

	scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(Reflow)
	task.defer(Reflow)

	if #order == 0 then
		Text(scroll, {
			Text = "No scripts are listed yet. If this looks wrong, the catalogue could not be reached.",
			Size = 14,
			Color = C.DimText,
			Wrap = true,
			Box = UDim2.new(1, 0, 0, 60),
			Z = 5,
		})
		return
	end

	for index, entry in ipairs(order) do
		local isHere = entry == here

		local card = New("Frame", {
			BackgroundColor3 = C.Section,
			BorderSizePixel = 0,
			LayoutOrder = index,
			ZIndex = 5,
			ClipsDescendants = true,
		}, scroll)
		Corner(10, card)

		if isHere then Stroke(C.Accent, 1.5, card) end

		local art = New("ImageLabel", {
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.new(1, -20, 0, 96),
			BackgroundColor3 = C.Element,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 6,
			Image = entry.Universe
				and ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(entry.Universe)
				or "",
		}, card)
		Corner(8, art)

		local ph = Text(art, {
			Text = string.sub(entry.Name, 1, 1),
			Size = 30,
			Bold = true,
			Color = C.Line,
			Align = Enum.TextXAlignment.Center,
			Z = 6,
		})

		task.spawn(function()
			for _ = 1, 40 do
				if art.IsLoaded then ph.Visible = false return end
				task.wait(0.25)
			end
		end)

		if isHere then
			local chip = New("Frame", {
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -6, 0, 6),
				Size = UDim2.fromOffset(74, 18),
				BackgroundColor3 = C.Accent,
				BorderSizePixel = 0,
				ZIndex = 8,
			}, art)
			Corner(5, chip)
			Text(chip, {
				Text = "THIS GAME",
				Size = 10,
				Bold = true,
				Color = Color3.new(1, 1, 1),
				Align = Enum.TextXAlignment.Center,
				Z = 9,
			})
		end

		Text(card, {
			Text = entry.Name,
			Size = 15,
			Bold = true,
			Pos = UDim2.fromOffset(10, 112),
			Box = UDim2.new(1, -20, 0, 20),
			Truncate = true,
			Z = 6,
		})

		local status = entry.Status or "Working"
		local col = (status == "Working" and C.Good)
			or (status == "Broken" and C.Bad)
			or C.Warn

		local dot = New("Frame", {
			Position = UDim2.fromOffset(10, 138),
			Size = UDim2.fromOffset(7, 7),
			BackgroundColor3 = col,
			BorderSizePixel = 0,
			ZIndex = 6,
		}, card)
		Corner(4, dot)

		Text(card, {
			Text = status,
			Size = 12,
			Color = col,
			Pos = UDim2.fromOffset(23, 133),
			Box = UDim2.new(1, -33, 0, 16),
			Truncate = true,
			Z = 6,
		})

		local load = Button(card, {
			Text = "Load Script",
			Anchor = Vector2.new(0, 1),
			Pos = UDim2.new(0, 10, 1, -10),
			Box = UDim2.new(1, -20, 0, TAP),
			Fill = isHere and C.Accent or C.Element,
			TextColor = isHere and Color3.new(1, 1, 1) or C.Text,
			Outline = not isHere,
			Bold = isHere,
			TextSize = 13,
			Z = 6,
		})

		if not entry.Url or entry.Url == "" or entry.Url:sub(-1) == "/" then
			load:SetText("No script yet")
			load:SetEnabled(false)
		elseif status == "Broken" then
			load:SetText("Currently broken")
			load:SetEnabled(false)
		else
			load:OnClick(function() Confirm(entry, load) end)
		end
	end
end

local ModalLayer

function Confirm(entry, sourceButton)
	if ModalLayer then ModalLayer:Destroy() end

	ModalLayer = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 40,
	}, Card)

	Tween(ModalLayer, { BackgroundTransparency = 0.45 }, 0.16)

	local block = New("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 41,
	}, ModalLayer)

	local w = math.min(360, Card.AbsoluteSize.X - 40)

	local panel = New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(w, 172 + (TAP - 32)),
		BackgroundColor3 = C.Section,
		BorderSizePixel = 0,
		ZIndex = 42,
	}, ModalLayer)
	Corner(12, panel)
	Stroke(C.Line, 1, panel)

	Text(panel, {
		Text = "Load this script?",
		Size = 16,
		Bold = true,
		Pos = UDim2.fromOffset(16, 14),
		Box = UDim2.new(1, -32, 0, 22),
		Z = 43,
	})

	Text(panel, {
		Text = entry.Name,
		Size = 14,
		Color = C.Accent,
		Pos = UDim2.fromOffset(16, 44),
		Box = UDim2.new(1, -32, 0, 20),
		Truncate = true,
		Z = 43,
	})

	local note = Text(panel, {
		Text = "It will run immediately once loaded.",
		Size = 12,
		Color = C.DimText,
		Pos = UDim2.fromOffset(16, 68),
		Box = UDim2.new(1, -32, 0, 34),
		Wrap = true,
		Z = 43,
	})

	local cancel = Button(panel, {
		Text = "Cancel",
		Anchor = Vector2.new(0, 1),
		Pos = UDim2.new(0, 16, 1, -14),
		Box = UDim2.fromOffset(math.floor((w - 42) / 2), math.max(34, TAP)),
		Fill = C.Element,
		Outline = true,
		Z = 43,
	})

	local go = Button(panel, {
		Text = "Load",
		Anchor = Vector2.new(1, 1),
		Pos = UDim2.new(1, -16, 1, -14),
		Box = UDim2.fromOffset(math.floor((w - 42) / 2), math.max(34, TAP)),
		Fill = C.Accent,
		TextColor = Color3.new(1, 1, 1),
		Bold = true,
		Z = 43,
	})

	local function Close()
		if not ModalLayer then return end
		local layer = ModalLayer
		ModalLayer = nil
		Tween(layer, { BackgroundTransparency = 1 }, 0.14)
		task.delay(0.16, function() layer:Destroy() end)
	end

	cancel:OnClick(Close)
	block.MouseButton1Click:Connect(Close)

	local busy = false

	go:OnClick(function()
		if busy then return end
		busy = true

		go:SetText("Loading...")
		go:SetEnabled(false)
		cancel:SetEnabled(false)

		task.spawn(function()
			local ok, body = pcall(game.HttpGet, game, entry.Url)

			if not ok or type(body) ~= "string" or body == "" then
				note.Text = "Could not download the script. GitHub may be down or rate limiting you -- try again in a minute."
				note.TextColor3 = C.Bad
				go:SetText("Retry")
				go:SetEnabled(true)
				cancel:SetEnabled(true)
				busy = false
				return
			end

			if #body < 64 then
				note.Text = "The server returned an empty file. The script may have been moved."
				note.TextColor3 = C.Bad
				go:SetText("Retry")
				go:SetEnabled(true)
				cancel:SetEnabled(true)
				busy = false
				return
			end

			local chunk, err = loadstring(body)
			if not chunk then
				note.Text = "The script failed to compile: " .. tostring(err):sub(1, 90)
				note.TextColor3 = C.Bad
				go:SetText("Retry")
				go:SetEnabled(true)
				cancel:SetEnabled(true)
				busy = false
				return
			end

			go:SetText("Loaded")
			task.wait(0.25)

			local destroy = getgenv().CitraLoader and getgenv().CitraLoader.Destroy
			if destroy then pcall(destroy) end

			task.defer(function()
				local ranOk, runErr = pcall(chunk)
				if not ranOk then
					warn("[" .. HUB .. "] script errored: " .. tostring(runErr))
				end
			end)
		end)
	end)
end

local function Destroy()
	Tween(Backdrop, { BackgroundTransparency = 1 }, 0.16)
	Tween(Card, { Size = UDim2.fromOffset(Card.AbsoluteSize.X, Card.AbsoluteSize.Y) }, 0.16)
	task.delay(0.2, function() Run(function() gui:Destroy() end) end)
	getgenv().CitraLoader = nil
end

CloseBtn.MouseButton1Click:Connect(Destroy)

CopyBtn:OnClick(function()
	local copied = false
	if setclip then copied = pcall(setclip, DISCORD) end
	CopyBtn:SetText(copied and "Copied" or "Copy failed")
	task.delay(1.4, function()
		if CopyBtn.Label.Parent then CopyBtn:SetText("Copy Discord") end
	end)
end)

TermsBtn:OnClick(function() Show("Terms", true) end)

getgenv().CitraLoader = { Destroy = Destroy, Show = Show }

local function FetchManifest()
	local ok, body = pcall(game.HttpGet, game, MANIFEST_URL)
	if not ok or type(body) ~= "string" or body == "" then
		HeaderNote.Text = "offline - showing bundled list"
		return
	end

	local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
	if not ok2 or type(data) ~= "table" then
		HeaderNote.Text = "catalogue unreadable - showing bundled list"
		return
	end

	ApplyCatalogue(data.scripts or data.Scripts)

	local hub = data.hub or data.Hub
	if type(hub) == "table" then
		HeaderNote.Text = tostring(hub.status or hub.STATUS or "")
	end

	if not TermsAccepted() then return end
	if ModalLayer then return end
	Show("Catalogue")
end

Backdrop.BackgroundTransparency = 1
Card.Size = UDim2.fromOffset(select(1, Metrics()), select(2, Metrics()))

Tween(Backdrop, { BackgroundTransparency = 0.5 }, 0.25)

if TermsAccepted() then
	Show("Catalogue")
else
	Show("Terms", false)
end

task.spawn(FetchManifest)
