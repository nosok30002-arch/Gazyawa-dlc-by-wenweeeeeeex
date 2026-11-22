if not game:IsLoaded() then game.Loaded:Wait() end
-- CUSTOM MODELS: paste the Roblox asset ID of your uploaded mesh (and texture).
-- If MeshId is not empty, the character is drawn with this mesh instead of the built-in one.
-- Scale = size multiplier, Offset = shift (studs), Yaw = turn around Y in degrees (use 180 if it faces backwards).
local MESH_MODELS = {
Putin = {MeshId = "", TextureId = "", Scale = 1, Offset = Vector3.new(0, 0, 0), Yaw = 0},
Zelensky = {MeshId = "", TextureId = "", Scale = 1, Offset = Vector3.new(0, 0, 0), Yaw = 0},
}
local function getGuiParent()
local okH, h = pcall(function() return gethui and gethui() end)
if okH and h then return h end
local okC, cg = pcall(function()
local c = game:GetService("CoreGui")
local t = Instance.new("Folder")
t.Parent = c
t:Destroy()
return c
end)
if okC and cg then return cg end
return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
local GUI_PARENT = getGuiParent()
local dbgLines = {}
local dbgHasError = false
local dbgGui, dbgBox
do
local lp = game:GetService("Players").LocalPlayer
local pg = GUI_PARENT
local old = pg:FindFirstChild("GZ_Debug")
if old then old:Destroy() end
dbgGui = Instance.new("ScreenGui")
dbgGui.Name = "GZ_Debug"
dbgGui.ResetOnSpawn = false
dbgGui.IgnoreGuiInset = true
dbgGui.DisplayOrder = 1000
dbgGui.Enabled = false
dbgGui.Parent = pg
dbgBox = Instance.new("TextBox")
dbgBox.Name = "Log"
dbgBox.Size = UDim2.new(0.92, 0, 0, 150)
dbgBox.Position = UDim2.new(0.04, 0, 0, 8)
dbgBox.BackgroundColor3 = Color3.new(0, 0, 0)
dbgBox.BackgroundTransparency = 0.3
dbgBox.BorderSizePixel = 0
dbgBox.TextColor3 = Color3.new(1, 1, 1)
dbgBox.TextSize = 14
dbgBox.Font = Enum.Font.Code
dbgBox.TextXAlignment = Enum.TextXAlignment.Left
dbgBox.TextYAlignment = Enum.TextYAlignment.Top
dbgBox.TextWrapped = true
dbgBox.MultiLine = true
dbgBox.ClearTextOnFocus = false
dbgBox.Text = ""
dbgBox.Parent = dbgGui
end
local function dbg(msg, isErr)
table.insert(dbgLines, (isErr and "\u{2716} " or "\u{2022} ") .. tostring(msg))
while #dbgLines > 8 do table.remove(dbgLines, 1) end
if isErr then
dbgHasError = true
dbgBox.TextColor3 = Color3.fromRGB(255, 130, 130)
end
dbgBox.Text = table.concat(dbgLines, "\n")
if isErr then dbgGui.Enabled = true end
print("[\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}] " .. tostring(msg))
end
local function report(msg)
warn(msg)
dbg(string.sub(tostring(msg), 1, 600), true)
end
local function dbgHide()
if not dbgHasError then dbgGui.Enabled = false end
end
dbg("\u{421}\u{43A}\u{440}\u{438}\u{43F}\u{442} \u{437}\u{430}\u{43F}\u{443}\u{449}\u{435}\u{43D}, GUI \u{432}: " .. GUI_PARENT.Name)
local function main()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local GUI_NAME = "GazyavyudlsGui"
local MENU_KEY = Enum.KeyCode.RightShift
for _, root in ipairs({GUI_PARENT, playerGui}) do
local oldGui = root:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end
end
local Theme = {
Bg = Color3.fromRGB(15, 14, 21),
Sidebar = Color3.fromRGB(11, 10, 17),
Card = Color3.fromRGB(24, 22, 34),
Seg = Color3.fromRGB(34, 31, 48),
Track = Color3.fromRGB(42, 39, 58),
Off = Color3.fromRGB(48, 45, 64),
Accent = Color3.fromRGB(150, 110, 255),
Accent2 = Color3.fromRGB(255, 100, 190),
Text = Color3.fromRGB(236, 232, 255),
Sub = Color3.fromRGB(140, 135, 170),
Stroke = Color3.fromRGB(60, 54, 90),
}
local WHITE = Color3.new(1, 1, 1)
local function new(class, props, parent)
local obj = Instance.new(class)
if obj:IsA("GuiObject") then obj.BorderSizePixel = 0 end
for k, v in pairs(props or {}) do obj[k] = v end
obj.Parent = parent
return obj
end
local function corner(parent, radius)
return new("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end
local function stroke(parent, color, thickness, transparency)
return new("UIStroke", {
Color = color,
Thickness = thickness or 1,
Transparency = transparency or 0,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, parent)
end
local function listLayout(parent, padding)
return new("UIListLayout", {
Padding = UDim.new(0, padding or 0),
SortOrder = Enum.SortOrder.LayoutOrder,
}, parent)
end
local function tween(obj, time, props, style, dir)
local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
t:Play()
return t
end
local function textLabel(parent, props)
local d = {
BackgroundTransparency = 1,
Font = Enum.Font.Gotham,
TextColor3 = Theme.Text,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
}
for k, v in pairs(props) do d[k] = v end
return new("TextLabel", d, parent)
end
local function textButton(parent, props)
local d = {
AutoButtonColor = false,
Text = "",
Font = Enum.Font.GothamMedium,
TextSize = 14,
TextColor3 = Theme.Text,
BackgroundColor3 = Theme.Seg,
}
for k, v in pairs(props) do d[k] = v end
return new("TextButton", d, parent)
end
local function hover(btn, normal, over)
btn.MouseEnter:Connect(function() tween(btn, 0.12, {BackgroundColor3 = over}) end)
btn.MouseLeave:Connect(function() tween(btn, 0.12, {BackgroundColor3 = normal}) end)
end
local function clearList(frame)
for _, c in ipairs(frame:GetChildren()) do
if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
end
end
local function isPress(input)
return input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
end
local lang = "en"
local platform = "pc"
local function tr(en, ru) return {en = en, ru = ru} end
local function T(v)
if type(v) == "table" then return v[lang] or v.en end
return v
end
local S = {
none = tr("None", "\u{41D}\u{435}\u{442}"),
pressKey = tr("Press a key\u{2026}", "\u{41D}\u{430}\u{436}\u{43C}\u{438} \u{43A}\u{43B}\u{430}\u{432}\u{438}\u{448}\u{443}\u{2026}"),
soon = tr("Soon...", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}..."),
back = tr("\u{2039}  Back", "\u{2039}  \u{41D}\u{430}\u{437}\u{430}\u{434}"),
on = tr("ON", "\u{412}\u{41A}\u{41B}"),
off = tr("OFF", "\u{412}\u{42B}\u{41A}\u{41B}"),
enabled = tr(" \u{2014} enabled", " \u{2014} \u{432}\u{43A}\u{43B}\u{44E}\u{447}\u{435}\u{43D}\u{43E}"),
disabled = tr(" \u{2014} disabled", " \u{2014} \u{432}\u{44B}\u{43A}\u{43B}\u{44E}\u{447}\u{435}\u{43D}\u{43E}"),
open = tr("Open", "\u{41E}\u{442}\u{43A}\u{440}\u{44B}\u{442}\u{44C}"),
showButton = tr("Show on-screen button", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{430}\u{442}\u{44C} \u{43A}\u{43D}\u{43E}\u{43F}\u{43A}\u{443} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435}"),
keybind = tr("Keybind (Backspace \u{2014} clear)", "\u{41A}\u{43B}\u{430}\u{432}\u{438}\u{448}\u{430} (Backspace \u{2014} \u{443}\u{431}\u{440}\u{430}\u{442}\u{44C})"),
footerPC = tr("by wenweeeeeeex\nRightShift \u{2014} hide menu", "by wenweeeeeeex\nRightShift \u{2014} \u{441}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{43C}\u{435}\u{43D}\u{44E}"),
footerPhone = tr("by wenweeeeeeex\n\u{2715} \u{2014} hide menu", "by wenweeeeeeex\n\u{2715} \u{2014} \u{441}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{43C}\u{435}\u{43D}\u{44E}"),
}
local CATEGORIES = {
{key = "Visuals", name = tr("\u{433}\u{430}\u{437}\u{44F}\u{432}\u{430} \u{432}\u{438}\u{437}\u{443}\u{430}\u{43B}\u{44B}", "\u{433}\u{430}\u{437}\u{44F}\u{432}\u{430} \u{432}\u{438}\u{437}\u{443}\u{430}\u{43B}\u{44B}")},
{key = "Combat", name = tr("Combat", "\u{411}\u{43E}\u{439}")},
{key = "Movement", name = tr("Movement", "\u{414}\u{432}\u{438}\u{436}\u{435}\u{43D}\u{438}\u{435}")},
{key = "Misc", name = tr("Misc", "\u{420}\u{430}\u{437}\u{43D}\u{43E}\u{435}")},
}
local camera = workspace.CurrentCamera
while not camera do
task.wait()
camera = workspace.CurrentCamera
end
local activeDrag = nil
local activeDragEnd = nil
local listeningBind = nil
local connections = {}
table.insert(connections, UserInputService.InputChanged:Connect(function(input)
if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch) then
activeDrag(input.Position)
end
end))
table.insert(connections, UserInputService.InputEnded:Connect(function(input)
if isPress(input) then
local e = activeDragEnd
activeDrag, activeDragEnd = nil, nil
if e then e() end
end
end))
local function kp(t, v) return NumberSequenceKeypoint.new(t, v) end
local function computeColor(mode, c1, c2, speed, t)
if mode == "Rainbow" then
return Color3.fromHSV((t * speed * 0.15) % 1, 0.8, 1)
elseif mode == "Dual" then
local a = (math.sin(t * speed * 1.5) + 1) / 2
return c1:Lerp(c2, a)
end
return c1
end
local function makeSequence(mode, c1, c2)
if mode == "Rainbow" then
local keys = {}
for i = 0, 6 do
table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 0.85, 1)))
end
return ColorSequence.new(keys)
elseif mode == "Dual" then
return ColorSequence.new(c1, c2)
end
return ColorSequence.new(c1)
end
local function getRoot()
local char = player.Character
return char and char:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
local char = player.Character
return char and char:FindFirstChildOfClass("Humanoid")
end
local noclipUsers = {}
local noclipOrig = {}
local function setNoclip(key, state)
noclipUsers[key] = state or nil
if next(noclipUsers) == nil then
for part in pairs(noclipOrig) do
if part.Parent then part.CanCollide = true end
end
noclipOrig = {}
end
end
table.insert(connections, RunService.Stepped:Connect(function()
if next(noclipUsers) == nil then return end
local char = player.Character
if not char then return end
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("BasePart") and d.CanCollide then
noclipOrig[d] = true
d.CanCollide = false
end
end
end))
local function getMoveVector()
local hum = getHumanoid()
local cam = workspace.CurrentCamera
if not hum or not cam then return Vector3.zero end
local md = hum.MoveDirection
if md.Magnitude < 0.01 then return Vector3.zero end
local lk, rt = cam.CFrame.LookVector, cam.CFrame.RightVector
local look = Vector3.new(lk.X, 0, lk.Z)
local right = Vector3.new(rt.X, 0, rt.Z)
if look.Magnitude < 0.001 or right.Magnitude < 0.001 then return Vector3.zero end
return Vector3.new(md:Dot(right.Unit), 0, -md:Dot(look.Unit))
end
local HttpService = game:GetService("HttpService")
local CFG_DIR = "gazyavyudls"
local fsOK = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
local memCfg = {}
if fsOK then
pcall(function()
if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(CFG_DIR) then
makefolder(CFG_DIR)
end
end)
end
local function cfgPath(name) return CFG_DIR .. "/" .. name .. ".json" end
local function cfgRead(name)
local txt
if fsOK then
local ok, r = pcall(function()
if isfile(cfgPath(name)) then return readfile(cfgPath(name)) end
return nil
end)
if ok then txt = r end
else
txt = memCfg[name]
end
if type(txt) ~= "string" or txt == "" then return nil end
local ok, data = pcall(function() return HttpService:JSONDecode(txt) end)
if ok and type(data) == "table" then return data end
return nil
end
local function cfgWrite(name, data)
local ok, txt = pcall(function() return HttpService:JSONEncode(data) end)
if not ok then return false end
if fsOK then
local okW = pcall(function() writefile(cfgPath(name), txt) end)
return okW
end
memCfg[name] = txt
return true
end
local screenGui = new("ScreenGui", {
Name = GUI_NAME,
ResetOnSpawn = false,
IgnoreGuiInset = true,
DisplayOrder = 100,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, GUI_PARENT)
dbg("1/4 GUI \u{441}\u{43E}\u{437}\u{434}\u{430}\u{43D} (" .. GUI_PARENT.Name .. ")")
pcall(function()
local introText = textLabel(screenGui, {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(400, 60),
Text = "by wenweeeeeeex",
Font = Enum.Font.GothamBlack,
TextSize = 36,
TextColor3 = Theme.Accent,
TextXAlignment = Enum.TextXAlignment.Center,
ZIndex = 5,
})
task.wait(1.6)
introText:Destroy()
end)
dbg("2/4 \u{437}\u{430}\u{441}\u{442}\u{430}\u{432}\u{43A}\u{430} \u{43F}\u{43E}\u{43A}\u{430}\u{437}\u{430}\u{43D}\u{430}")
local selBg
local preCfg = cfgRead("autosave")
local skipSel = false
if preCfg and (preCfg.lang == "en" or preCfg.lang == "ru") and (preCfg.platform == "pc" or preCfg.platform == "phone") then
lang = preCfg.lang
platform = preCfg.platform
skipSel = true
end
local okSel, errSel = true, nil
if not skipSel then
okSel, errSel = pcall(function()
local okLoc, locale = pcall(function()
return game:GetService("LocalizationService").RobloxLocaleId
end)
if okLoc and type(locale) == "string" and locale:sub(1, 2) == "ru" then lang = "ru" end
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then platform = "phone" end
local bg = new("Frame", {
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = Color3.fromRGB(9, 8, 14),
BackgroundTransparency = 0.1,
}, screenGui)
selBg = bg
local vp = camera.ViewportSize
local sc = math.clamp(math.min(vp.X / 440, vp.Y / 410), 0.5, 1)
local card = new("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(400, 372),
BackgroundColor3 = Color3.fromRGB(30, 27, 44),
}, bg)
corner(card, 16)
stroke(card, Theme.Accent, 2, 0)
new("UIScale", {Scale = sc}, card)
textLabel(card, {
Position = UDim2.new(0, 0, 0, 18), Size = UDim2.new(1, 0, 0, 40),
Text = "\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}", Font = Enum.Font.GothamBlack, TextSize = 28,
TextColor3 = WHITE, TextXAlignment = Enum.TextXAlignment.Center,
})
textLabel(card, {
Position = UDim2.new(0, 24, 0, 76), Size = UDim2.new(1, -48, 0, 20),
Text = "Language / \u{42F}\u{437}\u{44B}\u{43A}", TextColor3 = Theme.Sub, TextSize = 13, Font = Enum.Font.GothamMedium,
})
local platLbl = textLabel(card, {
Position = UDim2.new(0, 24, 0, 168), Size = UDim2.new(1, -48, 0, 20),
Text = "Platform / \u{41F}\u{43B}\u{430}\u{442}\u{444}\u{43E}\u{440}\u{43C}\u{430}", TextColor3 = Theme.Sub, TextSize = 13, Font = Enum.Font.GothamMedium,
})
local hintLbl = textLabel(card, {
Position = UDim2.new(0, 24, 0, 248), Size = UDim2.new(1, -48, 0, 34),
Text = "", TextColor3 = Theme.Sub, TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
})
local function choiceRow(y, items, onPick)
local row = new("Frame", {Position = UDim2.new(0, 24, 0, y), Size = UDim2.new(1, -48, 0, 48), BackgroundTransparency = 1}, card)
new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}, row)
local btns = {}
for i, it in ipairs(items) do
local b = textButton(row, {
LayoutOrder = i, Size = UDim2.new(0.5, -6, 1, 0),
Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Sub,
})
corner(b, 12)
btns[it.value] = {btn = b, item = it}
b.MouseButton1Click:Connect(function() onPick(it.value) end)
end
return btns
end
local langBtns, platBtns, cont
local function paint(btns, selected)
for value, e in pairs(btns) do
local on = value == selected
e.btn.BackgroundColor3 = on and Theme.Accent or Theme.Seg
e.btn.TextColor3 = on and WHITE or Theme.Sub
e.btn.Text = type(e.item.text) == "function" and e.item.text() or e.item.text
end
end
local function refresh()
paint(langBtns, lang)
paint(platBtns, platform)
platLbl.Text = lang == "ru" and "\u{41F}\u{43B}\u{430}\u{442}\u{444}\u{43E}\u{440}\u{43C}\u{430}" or "Platform"
hintLbl.Text = platform == "pc"
and T(tr("Per-function keybinds + mouse controls.", "\u{41A}\u{43B}\u{430}\u{432}\u{438}\u{448}\u{438} \u{434}\u{43B}\u{44F} \u{43A}\u{430}\u{436}\u{434}\u{43E}\u{439} \u{444}\u{443}\u{43D}\u{43A}\u{446}\u{438}\u{438} + \u{443}\u{43F}\u{440}\u{430}\u{432}\u{43B}\u{435}\u{43D}\u{438}\u{435} \u{43C}\u{44B}\u{448}\u{44C}\u{44E}."))
or T(tr("On-screen buttons for functions + touch controls.", "\u{41A}\u{43D}\u{43E}\u{43F}\u{43A}\u{438} \u{444}\u{443}\u{43D}\u{43A}\u{446}\u{438}\u{439} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435} + \u{441}\u{435}\u{43D}\u{441}\u{43E}\u{440}\u{43D}\u{43E}\u{435} \u{443}\u{43F}\u{440}\u{430}\u{432}\u{43B}\u{435}\u{43D}\u{438}\u{435}."))
cont.Text = T(tr("Continue", "\u{41F}\u{440}\u{43E}\u{434}\u{43E}\u{43B}\u{436}\u{438}\u{442}\u{44C}"))
end
langBtns = choiceRow(100, {
{value = "en", text = "English"},
{value = "ru", text = "\u{420}\u{443}\u{441}\u{441}\u{43A}\u{438}\u{439}"},
}, function(v) lang = v; refresh() end)
platBtns = choiceRow(192, {
{value = "pc", text = function() return "\u{1F5A5}  " .. T(tr("PC", "\u{41F}\u{41A}")) end},
{value = "phone", text = function() return "\u{1F4F1}  " .. T(tr("Phone", "\u{422}\u{435}\u{43B}\u{435}\u{444}\u{43E}\u{43D}")) end},
}, function(v) platform = v; refresh() end)
cont = textButton(card, {
Position = UDim2.new(0, 24, 0, 304), Size = UDim2.new(1, -48, 0, 48),
BackgroundColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = WHITE,
})
corner(cont, 12)
refresh()
dbg("3/4 \u{44D}\u{43A}\u{440}\u{430}\u{43D} \u{432}\u{44B}\u{431}\u{43E}\u{440}\u{430} \u{433}\u{43E}\u{442}\u{43E}\u{432} \u{2014} \u{432}\u{44B}\u{431}\u{435}\u{440}\u{438} \u{44F}\u{437}\u{44B}\u{43A} \u{438} \u{43F}\u{43B}\u{430}\u{442}\u{444}\u{43E}\u{440}\u{43C}\u{443}")
local done = false
cont.MouseButton1Click:Connect(function() done = true end)
while not done do task.wait() end
end)
end
if not okSel then
report("\u{41E}\u{448}\u{438}\u{431}\u{43A}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{430} \u{432}\u{44B}\u{431}\u{43E}\u{440}\u{430}: " .. tostring(errSel))
end
if selBg then pcall(function() selBg:Destroy() end) end
local allModules = {}
local function registerModule(def)
def.Settings = def.Settings or {}
table.insert(def.Settings, {Key = "ShowButton", Label = S.showButton, Type = "toggle", Default = false})
table.insert(def.Settings, {Key = "Keybind", Label = S.keybind, Type = "keybind", Default = "",
ShowIf = function() return platform == "pc" end})
def.Enabled = false
def.Listeners = {}
def.Values = {}
for _, s in ipairs(def.Settings) do
def.Values[s.Key] = s.Default
end
local function safe(self, fnName)
if type(self[fnName]) ~= "function" then return end
local ok, err = pcall(function() self[fnName](self) end)
if not ok then report("[\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}] " .. tostring(T(self.Name)) .. " / " .. fnName .. ": " .. tostring(err)) end
end
function def:SetEnabled(state)
if self.Enabled == state then return end
self.Enabled = state
safe(self, state and "Apply" or "Remove")
end
function def:Changed()
if self.Enabled then safe(self, "Apply") end
end
table.insert(allModules, def)
return def
end
local MODE_OPTIONS = {
{"Solid", tr("Color", "\u{426}\u{432}\u{435}\u{442}")},
{"Rainbow", tr("Rainbow", "\u{420}\u{430}\u{434}\u{443}\u{433}\u{430}")},
{"Dual", tr("Gradient", "\u{413}\u{440}\u{430}\u{434}\u{438}\u{435}\u{43D}\u{442}")},
}
local LBL_MODE = tr("Color mode", "\u{420}\u{435}\u{436}\u{438}\u{43C} \u{446}\u{432}\u{435}\u{442}\u{430}")
local LBL_C1 = tr("Color 1", "\u{426}\u{432}\u{435}\u{442} 1")
local LBL_C2 = tr("Color 2", "\u{426}\u{432}\u{435}\u{442} 2")
local function showC1(v) return v.Mode ~= "Rainbow" end
local function showC2(v) return v.Mode == "Dual" end
local function showSpeed(v) return v.Mode ~= "Solid" end
local function colorSet(modeDefault, c1, c2)
return {
{Key = "Mode", Label = LBL_MODE, Type = "segmented", Options = MODE_OPTIONS, Default = modeDefault},
{Key = "Color1", Label = LBL_C1, Type = "color", Default = c1, ShowIf = showC1},
{Key = "Color2", Label = LBL_C2, Type = "color", Default = c2, ShowIf = showC2},
{Key = "Speed", Label = tr("Animation speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{430}\u{43D}\u{438}\u{43C}\u{430}\u{446}\u{438}\u{438}"), Type = "slider", Min = 0.1, Max = 5, Step = 0.1, Default = 1, ShowIf = showSpeed},
}
end
local function withSettings(base, extra)
for _, s in ipairs(extra) do table.insert(base, s) end
return base
end
local PURPLE = Color3.fromRGB(160, 100, 255)
local PINK = Color3.fromRGB(255, 80, 180)
do
local SWAP_CHARS = (function()
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local function SP(shape, size, pos, color, o)
o = o or {}
local r = o.rot or {0, 0, 0}
return {
shape = shape,
size = Vector3.new(size[1], size[2], size[3]),
pos = Vector3.new(pos[1], pos[2], pos[3]),
color = color,
mat = o.mat or Enum.Material.SmoothPlastic,
rot = CFrame.Angles(math.rad(r[1]), math.rad(r[2]), math.rad(r[3])),
role = o.role,
pivot = o.pivot and Vector3.new(o.pivot[1], o.pivot[2], o.pivot[3]) or nil,
base = o.base or 0,
amp = o.amp or 1,
trans = o.trans or 0,
}
end
local function newList()
local p = {}
local function add(...) table.insert(p, SP(...)) end
local function cyl(h, d, pos, color, o)
o = o or {}
o.rot = {0, 0, 90}
add("Cyl", {h, d, d}, pos, color, o)
end
return p, add, cyl
end
local function ring(n, radius, fn)
for i = 0, n - 1 do
local a = i / n * math.pi * 2
fn(math.sin(a) * radius, math.cos(a) * radius, math.deg(a))
end
end
local out = {}
do
local p, add, cyl = newList()
local wood = Enum.Material.Wood
local BROWN, DARK, TAN, BLACK = C(140, 92, 52), C(100, 64, 36), C(205, 160, 105), C(20, 20, 20)
local BAT = C(225, 185, 125)
cyl(4.8, 2.4, {0, 0.7, 0}, BROWN, {mat = wood})
for _, y in ipairs({-1.1, 0, 1.1, 2.2}) do
cyl(0.1, 2.46, {0, y, 0}, DARK, {mat = wood})
end
cyl(0.15, 2.3, {0, 3.12, 0}, TAN, {mat = wood})
cyl(0.16, 1.5, {0, 3.14, 0}, C(175, 130, 80), {mat = wood})
cyl(0.17, 0.5, {0, 3.16, 0}, C(130, 90, 55), {mat = wood})
add("Sphere", {0.5, 0.6, 0.15}, {0.9, -0.6, -0.8}, DARK, {rot = {0, 35, 0}})
add("Sphere", {0.45, 0.5, 0.15}, {-0.8, 0.3, -0.9}, DARK, {rot = {0, -30, 0}})
add("Sphere", {0.35, 0.3, 0.3}, {0, 1.4, -1.18}, DARK)
add("Block", {1.1, 0.4, 0.12}, {0, 0.75, -1.15}, C(110, 15, 25))
add("Block", {0.9, 0.14, 0.1}, {0, 0.92, -1.2}, WHITE)
add("Sphere", {0.4, 0.18, 0.1}, {0, 0.6, -1.2}, C(220, 90, 100))
local bp = {1.45, 1.5, 0}
cyl(3.0, 0.28, {1.5, 0.85, -0.25}, TAN, {role = "rarm", pivot = bp, mat = wood})
cyl(1.3, 0.62, {1.5, 1.75, -0.25}, BAT, {role = "rarm", pivot = bp, mat = wood})
add("Sphere", {0.62, 0.3, 0.62}, {1.5, 2.45, -0.25}, BAT, {role = "rarm", pivot = bp})
cyl(0.8, 0.33, {1.5, -0.2, -0.25}, BLACK, {role = "rarm", pivot = bp})
cyl(0.12, 0.64, {1.5, 1.3, -0.25}, C(200, 40, 50), {role = "rarm", pivot = bp})
cyl(0.12, 0.64, {1.5, 2.1, -0.25}, C(200, 40, 50), {role = "rarm", pivot = bp})
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 1.45, 1.5, 0}
local lp = {sx * 0.55, -1.5, 0}
add("Sphere", {0.85, 1.0, 0.3}, {sx * 0.52, 2.1, -1.08}, WHITE)
add("Sphere", {0.4, 0.45, 0.18}, {sx * 0.5, 2.08, -1.24}, BLACK)
add("Sphere", {0.14, 0.14, 0.08}, {sx * 0.42, 2.22, -1.32}, WHITE)
add("Block", {0.8, 0.16, 0.12}, {sx * 0.55, 2.8, -1.0}, BLACK, {rot = {0, 0, sx * 14}})
cyl(1.9, 0.32, {sx * 1.5, 0.55, 0}, DARK, {role = arm, pivot = ap, mat = wood})
add("Sphere", {0.5, 0.5, 0.5}, {sx * 1.5, -0.45, 0}, TAN, {role = arm, pivot = ap})
cyl(1.5, 0.34, {sx * 0.55, -2.25, 0}, DARK, {role = leg, pivot = lp, mat = wood})
add("Block", {0.7, 0.3, 0.8}, {sx * 0.55, -2.85, -0.1}, BLACK, {role = leg, pivot = lp})
add("Sphere", {0.7, 0.32, 0.7}, {sx * 0.55, -2.85, -0.5}, BLACK, {role = leg, pivot = lp})
end
out.Sahur = {parts = p}
end
do
local p, add, cyl = newList()
local PINK, LPINK, SKIN = C(255, 170, 205), C(255, 210, 230), C(255, 224, 200)
local CUP, COFFEE, FOAM, TIGHT = C(250, 248, 245), C(110, 70, 42), C(240, 225, 200), C(255, 200, 215)
local RED = C(235, 70, 110)
cyl(2.1, 2.5, {0, 1.95, 0}, CUP)
cyl(0.3, 2.0, {0, 0.85, 0}, CUP)
cyl(0.12, 2.62, {0, 3.0, 0}, CUP)
cyl(0.1, 2.35, {0, 3.03, 0}, COFFEE)
cyl(0.1, 1.9, {0, 3.07, 0}, FOAM)
add("Sphere", {0.7, 0.1, 1.0}, {0, 3.13, 0}, COFFEE)
add("Sphere", {0.35, 0.1, 0.55}, {0, 3.15, 0}, FOAM)
for i = 0, 5 do
local a = math.rad(-90 + i * 36)
add("Sphere", {0.38, 0.38, 0.38}, {1.25 + math.cos(a) * 0.65, 1.95 + math.sin(a) * 0.65, 0}, CUP)
end
add("Sphere", {0.35, 0.12, 0.1}, {0, 1.55, -1.2}, C(210, 90, 110))
add("Block", {1.15, 1.4, 0.75}, {0, 0.3, 0}, PINK)
add("Block", {1.2, 0.25, 0.8}, {0, 0.9, 0}, LPINK)
add("Sphere", {0.25, 0.25, 0.12}, {0, 0.5, -0.4}, C(255, 120, 170))
add("Sphere", {0.55, 0.4, 0.4}, {-1.3, 3.2, -0.2}, RED)
add("Sphere", {0.55, 0.4, 0.4}, {-0.4, 3.2, -0.2}, RED)
add("Sphere", {0.35, 0.35, 0.35}, {-0.85, 3.2, -0.2}, C(200, 40, 85))
cyl(0.18, 3.5, {0, -0.4, 0}, LPINK, {trans = 0.15})
cyl(0.18, 3.0, {0, -0.55, 0}, PINK, {trans = 0.1})
cyl(0.18, 2.4, {0, -0.7, 0}, LPINK)
cyl(0.25, 1.3, {0, -0.2, 0}, C(255, 130, 175))
ring(14, 1.72, function(x, z) add("Sphere", {0.5, 0.18, 0.5}, {x, -0.4, z}, LPINK) end)
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 0.8, 0.95, 0}
local lp = {sx * 0.4, -1.2, 0}
add("Sphere", {0.55, 0.75, 0.2}, {sx * 0.55, 2.15, -1.1}, WHITE)
add("Sphere", {0.34, 0.5, 0.15}, {sx * 0.55, 2.12, -1.22}, C(40, 25, 20))
add("Sphere", {0.14, 0.14, 0.08}, {sx * 0.46, 2.3, -1.3}, WHITE)
add("Block", {0.5, 0.08, 0.08}, {sx * 0.6, 2.58, -1.08}, C(20, 20, 20), {rot = {0, 0, sx * -15}})
add("Sphere", {0.5, 0.25, 0.1}, {sx * 0.95, 1.65, -0.8}, C(255, 140, 160))
cyl(1.6, 0.3, {sx * 0.8, 0.1, 0}, SKIN, {role = arm, pivot = ap, base = 165, amp = 0.3})
add("Sphere", {0.34, 0.34, 0.34}, {sx * 0.8, -0.75, 0}, SKIN, {role = arm, pivot = ap, base = 165, amp = 0.3})
add("Sphere", {0.55, 0.55, 0.55}, {sx * 0.8, 0.85, 0}, PINK, {role = arm, pivot = ap, base = 165, amp = 0.3})
cyl(1.7, 0.38, {sx * 0.4, -2.15, 0}, TIGHT, {role = leg, pivot = lp})
cyl(0.1, 0.42, {sx * 0.4, -2.55, 0}, WHITE, {role = leg, pivot = lp})
add("Sphere", {0.5, 0.4, 0.9}, {sx * 0.4, -2.9, -0.15}, C(255, 175, 195), {role = leg, pivot = lp})
end
out.Ballerina = {parts = p, spin = true}
end
do
local p, add, cyl = newList()
local HAIR, HAIR2, SKIN = C(255, 140, 195), C(235, 105, 170), C(255, 226, 205)
local NAVY, UNI, RED, BLUSH = C(40, 48, 110), C(245, 245, 255), C(230, 60, 90), C(255, 150, 170)
add("Sphere", {2.5, 2.5, 2.5}, {0, 1.9, 0}, SKIN)
add("Sphere", {2.9, 2.8, 2.9}, {0, 2.1, 0.35}, HAIR)
add("Sphere", {2.2, 3.2, 0.9}, {0, 0.5, 0.9}, HAIR)
add("Sphere", {0.9, 0.8, 0.5}, {-0.7, 2.85, -0.85}, HAIR, {rot = {-15, 0, 15}})
add("Sphere", {0.9, 0.85, 0.5}, {0, 2.95, -0.95}, HAIR, {rot = {-15, 0, 0}})
add("Sphere", {0.9, 0.8, 0.5}, {0.7, 2.85, -0.85}, HAIR, {rot = {-15, 0, -15}})
add("Sphere", {0.25, 0.9, 0.25}, {0.1, 3.65, 0}, HAIR, {rot = {0, 0, 15}})
add("Sphere", {0.3, 0.3, 0.3}, {0, 1.5, -1.19}, C(235, 170, 150))
add("Sphere", {0.3, 0.1, 0.1}, {0, 1.28, -1.1}, C(220, 85, 105))
add("Block", {1.5, 1.5, 0.9}, {0, 0.1, 0}, UNI)
add("Block", {1.7, 0.28, 1.05}, {0, 0.82, 0}, NAVY)
add("Block", {0.5, 0.9, 0.1}, {-0.3, 0.45, -0.5}, NAVY, {rot = {0, 0, 20}})
add("Block", {0.5, 0.9, 0.1}, {0.3, 0.45, -0.5}, NAVY, {rot = {0, 0, -20}})
add("Sphere", {0.35, 0.3, 0.15}, {0, 0.68, -0.55}, RED)
add("Sphere", {0.2, 0.5, 0.1}, {-0.12, 0.4, -0.55}, RED, {rot = {0, 0, 12}})
add("Sphere", {0.2, 0.5, 0.1}, {0.12, 0.4, -0.55}, RED, {rot = {0, 0, -12}})
cyl(0.9, 2.2, {0, -0.95, 0}, NAVY)
ring(12, 1.15, function(x, z, deg)
add("Block", {0.5, 0.55, 0.18}, {x, -1.3, z}, C(60, 70, 150), {rot = {0, deg, 0}})
end)
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 1.1, 0.9, 0}
local lp = {sx * 0.45, -1.55, 0}
add("Sphere", {0.5, 1.5, 0.5}, {sx * 1.15, 1.8, -0.55}, HAIR2)
add("Sphere", {0.9, 2.8, 0.9}, {sx * 1.9, 0.8, 0.35}, HAIR, {rot = {0, 0, sx * 8}})
add("Sphere", {0.6, 0.8, 0.6}, {sx * 1.95, -0.7, 0.35}, HAIR2)
add("Sphere", {0.55, 0.55, 0.55}, {sx * 1.75, 2.0, 0.35}, RED)
add("Sphere", {0.8, 1.0, 0.2}, {sx * 0.56, 1.85, -1.12}, WHITE)
add("Sphere", {0.62, 0.85, 0.2}, {sx * 0.56, 1.82, -1.2}, C(60, 130, 255))
add("Sphere", {0.5, 0.4, 0.15}, {sx * 0.56, 1.62, -1.27}, C(130, 200, 255))
add("Sphere", {0.28, 0.45, 0.15}, {sx * 0.56, 1.85, -1.29}, C(15, 25, 70))
add("Sphere", {0.22, 0.22, 0.1}, {sx * 0.45, 2.05, -1.34}, WHITE)
add("Sphere", {0.1, 0.1, 0.06}, {sx * 0.68, 1.6, -1.34}, WHITE)
add("Block", {0.85, 0.1, 0.1}, {sx * 0.56, 2.32, -1.1}, C(20, 20, 30), {rot = {0, 0, sx * 8}})
add("Block", {0.6, 0.1, 0.1}, {sx * 0.58, 2.6, -1.0}, HAIR2)
add("Sphere", {0.45, 0.22, 0.1}, {sx * 0.95, 1.45, -0.7}, BLUSH)
cyl(0.6, 0.5, {sx * 1.1, 0.65, 0}, UNI, {role = arm, pivot = ap})
cyl(1.2, 0.36, {sx * 1.1, 0.0, 0}, SKIN, {role = arm, pivot = ap})
cyl(0.12, 0.45, {sx * 1.1, 0.4, 0}, NAVY, {role = arm, pivot = ap})
add("Sphere", {0.38, 0.38, 0.38}, {sx * 1.1, -0.65, 0}, SKIN, {role = arm, pivot = ap})
cyl(0.6, 0.46, {sx * 0.45, -1.55, 0}, SKIN, {role = leg, pivot = lp})
cyl(1.4, 0.5, {sx * 0.45, -2.3, 0}, C(245, 245, 250), {role = leg, pivot = lp})
cyl(0.12, 0.52, {sx * 0.45, -1.9, 0}, NAVY, {role = leg, pivot = lp})
add("Sphere", {0.62, 0.35, 0.95}, {sx * 0.45, -2.85, -0.15}, C(80, 50, 50), {role = leg, pivot = lp})
end
out.Anime = {parts = p}
end
do
local p, add, cyl = newList()
local BLUE, DBLUE, BELLY, LEG = C(60, 120, 205), C(40, 85, 160), C(220, 232, 245), C(255, 215, 185)
local SHOE = C(40, 110, 230)
add("Sphere", {2.9, 4.3, 2.9}, {0, 0.4, 0}, BLUE)
add("Sphere", {2.1, 3.5, 1.4}, {0, 0.2, -0.85}, BELLY)
add("Sphere", {1.9, 1.6, 2.6}, {0, 2.0, -1.05}, BLUE)
add("Sphere", {1.5, 0.7, 2.0}, {0, 1.55, -1.15}, BELLY)
add("Block", {1.0, 0.12, 0.4}, {0, 1.65, -2.15}, C(50, 20, 35))
add("Block", {0.25, 1.8, 1.1}, {0, 2.5, 1.0}, DBLUE, {rot = {-28, 0, 0}})
add("Block", {0.25, 1.4, 0.9}, {0, -0.4, 1.5}, DBLUE, {rot = {30, 0, 0}})
for i = -3, 3 do
add("Block", {0.14, 0.24, 0.1}, {i * 0.15, 1.55, -2.17}, WHITE)
end
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
add("Sphere", {0.12, 0.12, 0.12}, {sx * 0.3, 2.3, -2.2}, DBLUE)
add("Sphere", {0.8, 0.8, 0.3}, {sx * 0.7, 2.45, -1.5}, WHITE)
add("Sphere", {0.36, 0.36, 0.18}, {sx * 0.7, 2.43, -1.68}, C(20, 20, 20))
add("Sphere", {0.14, 0.14, 0.08}, {sx * 0.6, 2.55, -1.78}, WHITE)
add("Block", {0.7, 0.14, 0.1}, {sx * 0.7, 2.95, -1.5}, DBLUE, {rot = {0, 0, sx * -18}})
for i = 0, 2 do
add("Block", {0.08, 0.5, 0.15}, {sx * 1.38, 1.1 - i * 0.35, -0.3}, DBLUE, {rot = {0, 0, sx * 10}})
end
add("Block", {0.3, 1.3, 0.55}, {sx * 1.55, 0.6, 0}, DBLUE, {role = arm, pivot = {sx * 1.45, 1.2, 0}})
end
local legs = {{-0.85, -0.2, "lleg"}, {0.85, -0.2, "rleg"}, {0, 0.8, "lleg"}}
for _, l in ipairs(legs) do
local x, z, role = l[1], l[2], l[3]
local lp = {x, -1.65, z}
cyl(1.3, 0.42, {x, -2.3, z}, LEG, {role = role, pivot = lp})
add("Block", {0.95, 0.5, 1.5}, {x, -2.75, z - 0.25}, SHOE, {role = role, pivot = lp})
add("Block", {1.0, 0.15, 1.55}, {x, -2.98, z - 0.25}, WHITE, {role = role, pivot = lp})
add("Sphere", {0.95, 0.5, 0.6}, {x, -2.75, z - 0.8}, SHOE, {role = role, pivot = lp})
add("Block", {0.5, 0.06, 0.5}, {x, -2.48, z - 0.4}, WHITE, {role = role, pivot = lp})
add("Block", {0.05, 0.12, 0.55}, {x + 0.49, -2.72, z - 0.2}, WHITE, {role = role, pivot = lp})
add("Block", {0.05, 0.12, 0.55}, {x - 0.49, -2.72, z - 0.2}, WHITE, {role = role, pivot = lp})
end
out.Shark = {parts = p}
end
do
local p, add, cyl = newList()
local SKIN, HAIR, JERSEY, TRIM = C(205, 150, 110), C(25, 18, 15), C(200, 30, 40), C(250, 250, 250)
local BOOT = C(25, 25, 25)
add("Sphere", {1.75, 2.0, 1.75}, {0, 2.15, 0}, SKIN)
add("Sphere", {1.9, 1.2, 1.9}, {0, 2.8, 0.12}, HAIR)
add("Sphere", {1.4, 0.5, 0.7}, {0, 3.15, -0.45}, HAIR)
add("Sphere", {0.2, 0.2, 0.2}, {0, 1.95, -0.9}, C(190, 135, 100))
add("Block", {0.35, 0.07, 0.08}, {0, 1.65, -0.83}, C(150, 70, 70))
cyl(0.4, 0.5, {0, 1.1, 0}, SKIN)
add("Block", {1.85, 1.8, 1.0}, {0, 0.4, 0}, JERSEY)
add("Block", {0.7, 0.25, 0.12}, {0, 1.25, -0.5}, TRIM)
add("Block", {1.86, 0.18, 1.02}, {0, 0.1, 0}, TRIM)
add("Sphere", {0.3, 0.3, 0.1}, {-0.5, 0.9, -0.52}, TRIM)
add("Block", {1.9, 0.95, 1.05}, {0, -0.9, 0}, TRIM)
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 1.25, 1.3, 0}
local lp = {sx * 0.5, -1.3, 0}
add("Sphere", {0.3, 0.45, 0.3}, {sx * 0.88, 2.1, 0}, SKIN)
add("Sphere", {0.3, 0.22, 0.1}, {sx * 0.35, 2.2, -0.8}, WHITE)
add("Sphere", {0.16, 0.16, 0.08}, {sx * 0.35, 2.2, -0.86}, C(20, 20, 20))
add("Block", {0.4, 0.08, 0.08}, {sx * 0.35, 2.45, -0.8}, HAIR)
add("Block", {0.08, 0.95, 1.06}, {sx * 0.96, -0.9, 0}, JERSEY)
add("Block", {0.62, 0.8, 0.62}, {sx * 1.25, 1.05, 0}, JERSEY, {role = arm, pivot = ap})
add("Block", {0.64, 0.15, 0.64}, {sx * 1.25, 0.7, 0}, TRIM, {role = arm, pivot = ap})
cyl(1.3, 0.46, {sx * 1.25, 0.15, 0}, SKIN, {role = arm, pivot = ap})
add("Sphere", {0.46, 0.46, 0.46}, {sx * 1.25, -0.55, 0}, SKIN, {role = arm, pivot = ap})
cyl(2.0, 0.6, {sx * 0.5, -2.0, 0}, SKIN, {role = leg, pivot = lp})
cyl(1.1, 0.66, {sx * 0.5, -2.45, 0}, JERSEY, {role = leg, pivot = lp})
cyl(0.15, 0.68, {sx * 0.5, -2.1, 0}, TRIM, {role = leg, pivot = lp})
add("Block", {0.72, 0.35, 1.15}, {sx * 0.5, -2.85, -0.15}, BOOT, {role = leg, pivot = lp})
add("Sphere", {0.72, 0.35, 0.7}, {sx * 0.5, -2.85, -0.6}, BOOT, {role = leg, pivot = lp})
add("Block", {0.74, 0.1, 0.5}, {sx * 0.5, -2.75, -0.2}, C(250, 210, 40), {role = leg, pivot = lp})
end
out.Player = {parts = p}
end
do
local p, add, cyl = newList()
local SKIN, SKIN2 = C(238, 204, 180), C(214, 170, 146)
local HAIR = C(176, 152, 118)
local SUIT, SUIT2, PANTS = C(38, 44, 66), C(28, 33, 52), C(32, 36, 54)
local TIE, BLACK = C(40, 72, 150), C(20, 20, 20)
add("Sphere", {1.7, 2.0, 1.7}, {0, 2.15, 0}, SKIN)
add("Sphere", {1.75, 1.0, 1.8}, {0, 2.75, 0.28}, HAIR)
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 1.25, 1.3, 0}
local lp = {sx * 0.5, -1.3, 0}
add("Sphere", {0.3, 0.5, 0.5}, {sx * 0.78, 2.6, 0.1}, HAIR)
add("Sphere", {0.25, 0.42, 0.22}, {sx * 0.86, 2.05, 0.05}, SKIN)
add("Sphere", {0.3, 0.18, 0.1}, {sx * 0.36, 2.22, -0.8}, WHITE)
add("Sphere", {0.14, 0.14, 0.08}, {sx * 0.36, 2.22, -0.86}, C(95, 140, 190))
add("Block", {0.42, 0.07, 0.08}, {sx * 0.36, 2.45, -0.8}, HAIR, {rot = {0, 0, sx * -6}})
add("Block", {0.25, 1.15, 0.06}, {sx * 0.4, 0.75, -0.52}, SUIT2, {rot = {0, 0, sx * -10}})
add("Block", {0.64, 1.5, 0.64}, {sx * 1.25, 0.6, 0}, SUIT, {role = arm, pivot = ap})
add("Block", {0.66, 0.12, 0.66}, {sx * 1.25, -0.12, 0}, WHITE, {role = arm, pivot = ap})
add("Sphere", {0.46, 0.46, 0.46}, {sx * 1.25, -0.45, 0}, SKIN, {role = arm, pivot = ap})
cyl(2.0, 0.62, {sx * 0.5, -2.0, 0}, PANTS, {role = leg, pivot = lp})
add("Block", {0.72, 0.32, 1.15}, {sx * 0.5, -2.85, -0.15}, BLACK, {role = leg, pivot = lp})
add("Sphere", {0.72, 0.32, 0.7}, {sx * 0.5, -2.85, -0.6}, BLACK, {role = leg, pivot = lp})
end
add("Sphere", {0.22, 0.3, 0.25}, {0, 1.98, -0.86}, SKIN2)
add("Block", {0.46, 0.06, 0.08}, {0, 1.68, -0.82}, C(170, 105, 105))
cyl(0.4, 0.5, {0, 1.1, 0}, SKIN)
cyl(0.15, 0.62, {0, 1.28, 0}, WHITE)
add("Block", {1.85, 1.8, 1.0}, {0, 0.4, 0}, SUIT)
add("Block", {0.5, 1.2, 0.06}, {0, 0.75, -0.51}, WHITE)
add("Block", {0.2, 1.05, 0.06}, {0, 0.6, -0.54}, TIE)
add("Sphere", {0.27, 0.2, 0.1}, {0, 1.2, -0.54}, TIE)
add("Block", {1.9, 0.95, 1.05}, {0, -0.9, 0}, PANTS)
add("Block", {1.9, 0.12, 1.06}, {0, -0.45, 0}, BLACK)
out.Putin = {parts = p}
end
do
local p, add, cyl = newList()
local SKIN, SKIN2 = C(232, 196, 170), C(206, 160, 135)
local HAIR = C(52, 38, 30)
local OLIVE, OLIVE2, PANTS = C(84, 90, 60), C(70, 76, 50), C(62, 66, 48)
local BOOT = C(30, 24, 20)
add("Sphere", {1.7, 2.0, 1.7}, {0, 2.15, 0}, SKIN)
add("Sphere", {1.78, 0.75, 1.8}, {0, 2.85, 0.12}, HAIR)
add("Sphere", {1.62, 0.95, 1.55}, {0, 1.72, -0.1}, C(96, 80, 72), {trans = 0.55})
for _, sx in ipairs({-1, 1}) do
local arm = sx < 0 and "larm" or "rarm"
local leg = sx < 0 and "lleg" or "rleg"
local ap = {sx * 1.25, 1.3, 0}
local lp = {sx * 0.5, -1.3, 0}
add("Sphere", {0.25, 0.42, 0.22}, {sx * 0.86, 2.05, 0.05}, SKIN)
add("Sphere", {0.3, 0.18, 0.1}, {sx * 0.36, 2.22, -0.8}, WHITE)
add("Sphere", {0.14, 0.14, 0.08}, {sx * 0.36, 2.22, -0.86}, C(60, 40, 28))
add("Block", {0.44, 0.09, 0.08}, {sx * 0.36, 2.45, -0.8}, HAIR, {rot = {0, 0, sx * -4}})
add("Block", {0.66, 1.75, 0.66}, {sx * 1.25, 0.45, 0}, OLIVE, {role = arm, pivot = ap})
add("Sphere", {0.46, 0.46, 0.46}, {sx * 1.25, -0.45, 0}, SKIN, {role = arm, pivot = ap})
cyl(2.0, 0.62, {sx * 0.5, -2.0, 0}, PANTS, {role = leg, pivot = lp})
add("Block", {0.72, 0.32, 1.15}, {sx * 0.5, -2.85, -0.15}, BOOT, {role = leg, pivot = lp})
add("Sphere", {0.72, 0.32, 0.7}, {sx * 0.5, -2.85, -0.6}, BOOT, {role = leg, pivot = lp})
end
add("Sphere", {0.22, 0.3, 0.25}, {0, 1.98, -0.86}, SKIN2)
add("Block", {0.5, 0.06, 0.08}, {0, 1.66, -0.82}, C(165, 100, 100))
cyl(0.4, 0.5, {0, 1.1, 0}, SKIN)
cyl(0.2, 0.74, {0, 1.25, 0}, OLIVE2)
add("Block", {1.85, 1.8, 1.0}, {0, 0.4, 0}, OLIVE)
add("Block", {1.9, 0.95, 1.05}, {0, -0.9, 0}, PANTS)
add("Block", {1.9, 0.12, 1.06}, {0, -0.45, 0}, C(40, 36, 30))
out.Zelensky = {parts = p}
end
return out
end)()
local SWAP_DIR = {larm = 1, rarm = -1, lleg = -1, rleg = 1}
local swap = registerModule({
Name = tr("Character Swap", "\u{417}\u{430}\u{43C}\u{435}\u{43D}\u{430} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430}"),
Desc = tr("Turns you into a meme character (only on your screen)", "\u{41F}\u{440}\u{435}\u{432}\u{440}\u{430}\u{449}\u{430}\u{435}\u{442} \u{442}\u{435}\u{431}\u{44F} \u{432} \u{43C}\u{435}\u{43C}-\u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430} (\u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Character", Label = tr("Character", "\u{41F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}"), Type = "segmented", Default = "Sahur",
Options = {
{"Sahur", tr("Sahur", "\u{421}\u{430}\u{445}\u{443}\u{440}")},
{"Ballerina", tr("Ballerina", "\u{411}\u{430}\u{43B}\u{435}\u{440}\u{438}\u{43D}\u{430}")},
{"Anime", tr("Anime", "\u{410}\u{43D}\u{438}\u{43C}\u{435}")},
{"Shark", tr("Tralalero", "\u{422}\u{440}\u{430}\u{43B}\u{430}\u{43B}\u{435}\u{440}\u{43E}")},
{"Player", tr("Player", "\u{418}\u{433}\u{440}\u{43E}\u{43A}")},
{"Putin", tr("Putin", "\u{41F}\u{443}\u{442}\u{438}\u{43D}")},
{"Zelensky", tr("Zelensky", "\u{417}\u{435}\u{43B}\u{435}\u{43D}\u{441}\u{43A}\u{438}\u{439}")},
}},
{Key = "Scale", Label = tr("Size", "\u{420}\u{430}\u{437}\u{43C}\u{435}\u{440}"), Type = "slider", Min = 0.5, Max = 2.5, Step = 0.1, Default = 1},
{Key = "Animate", Label = tr("Animation (walking, spinning)", "\u{410}\u{43D}\u{438}\u{43C}\u{430}\u{446}\u{438}\u{44F} (\u{445}\u{43E}\u{434}\u{44C}\u{431}\u{430}, \u{432}\u{440}\u{430}\u{449}\u{435}\u{43D}\u{438}\u{435})"), Type = "toggle", Default = true},
{Key = "HideReal", Label = tr("Hide my real character", "\u{421}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{43C}\u{43E}\u{435}\u{433}\u{43E} \u{43D}\u{430}\u{441}\u{442}\u{43E}\u{44F}\u{449}\u{435}\u{433}\u{43E} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430}"), Type = "toggle", Default = true},
},
})
swap.items = {}
swap.limbs = {}
swap.rParts, swap.rDecals, swap.origDecal = {}, {}, {}
swap.nextScan = 0
swap.t, swap.phase, swap.spinAng = 0, 0, 0
swap.bound = false
function swap:Wipe()
if self.folder then self.folder:Destroy() end
self.folder = nil
self.rigWeld = nil
self.heading = nil
self.items = {}
self.limbs = {}
end
function swap:Build()
self:Wipe()
local root = getRoot()
if not root then return end
local v = self.Values
local def = SWAP_CHARS[v.Character]
if not def then return end
local s = v.Scale
local folder = new("Folder", {Name = "GZ_Swap"}, workspace)
self.folder = folder
self.spin = def.spin
local rig = new("Part", {
Name = "Rig",
Size = Vector3.new(0.2, 0.2, 0.2),
Transparency = 1,
Anchored = false,
CanCollide = false,
CanQuery = false,
CanTouch = false,
Massless = true,
CastShadow = false,
Locked = true,
}, folder)
rig.CFrame = root.CFrame
self.rigWeld = new("Weld", {Part0 = root, Part1 = rig}, rig)
local function sc(p) return Vector3.new(p.X * s, (p.Y + 3) * s - 3, p.Z * s) end
local mm = MESH_MODELS[v.Character]
local useMesh = mm and tostring(mm.MeshId or "") ~= ""
for _, d in ipairs(useMesh and {} or def.parts) do
local props = {
Size = d.size * s,
Color = d.color,
Material = d.mat,
Transparency = d.trans,
Anchored = false,
CanCollide = false,
CanQuery = false,
CanTouch = false,
Massless = true,
CastShadow = false,
Locked = true,
}
if d.shape == "Cyl" then props.Shape = Enum.PartType.Cylinder end
local part = new(d.shape == "Wedge" and "WedgePart" or "Part", props, folder)
if d.shape == "Sphere" then
new("SpecialMesh", {MeshType = Enum.MeshType.Sphere}, part)
end
local pos = sc(d.pos)
local pivot = d.pivot and sc(d.pivot) or nil
part.CFrame = root.CFrame * CFrame.new(pos) * d.rot
local weld = new("Weld", {Part0 = rig, Part1 = part}, part)
weld.C0 = CFrame.new(pos) * d.rot
if d.role and pivot then
table.insert(self.limbs, {weld = weld, d = d, pos = pos, pivot = pivot})
end
end
if useMesh then
local function aid(x)
x = tostring(x or "")
if x:match("^%d+$") then return "rbxassetid://" .. x end
return x
end
local mp = new("Part", {
Name = "Model", Size = Vector3.new(1, 1, 1),
Anchored = false, CanCollide = false, CanQuery = false, CanTouch = false,
Massless = true, CastShadow = false, Locked = true,
}, folder)
new("SpecialMesh", {
MeshType = Enum.MeshType.FileMesh,
MeshId = aid(mm.MeshId), TextureId = aid(mm.TextureId),
Scale = Vector3.new(1, 1, 1) * (mm.Scale or 1) * s,
}, mp)
local c0 = CFrame.new((mm.Offset or Vector3.zero) * s) * CFrame.Angles(0, math.rad(mm.Yaw or 0), 0)
mp.CFrame = root.CFrame * c0
new("Weld", {Part0 = rig, Part1 = mp, C0 = c0}, mp)
end
self:Pose(0, 0, 0)
end
function swap:Pose(swing, yaw, bob)
if self.rigWeld then
self.rigWeld.C0 = CFrame.new(0, bob, 0) * CFrame.Angles(0, yaw, 0)
end
for _, it in ipairs(self.limbs) do
local d = it.d
local ang = math.rad(d.base) + swing * d.amp * (SWAP_DIR[d.role] or 1)
it.weld.C0 = CFrame.new(it.pivot) * CFrame.Angles(ang, 0, 0) * CFrame.new(it.pos - it.pivot) * d.rot
end
end
function swap:Update(dt)
local root = getRoot()
if not root then return end
if not self.folder or not self.folder.Parent or not self.rigWeld or self.rigWeld.Part0 ~= root then
self:Build()
if not self.folder then return end
end
local v = self.Values
local vel = root.AssemblyLinearVelocity
local flat = Vector3.new(vel.X, 0, vel.Z)
local speed = flat.Magnitude
local look = root.CFrame.LookVector
local rootYaw = math.atan2(-look.X, -look.Z)
if not self.heading then self.heading = rootYaw end
local target = rootYaw
if speed > 1.5 then target = math.atan2(-flat.X, -flat.Z) end
local diff = (target - self.heading + math.pi) % (math.pi * 2) - math.pi
self.heading = self.heading + diff * math.clamp(dt * 12, 0, 1)
self.t = self.t + dt
local swing, bob, spinYaw = 0, 0, 0
if v.Animate then
self.phase = self.phase + dt * (3 + speed * 0.45)
swing = math.sin(self.phase) * 0.9 * math.clamp(speed / 14, 0, 1)
bob = math.sin(self.t * 2.2) * 0.06
if self.spin then
if speed < 1 then
self.spinAng = self.spinAng + dt * 6
else
local y = (self.spinAng + math.pi) % (math.pi * 2) - math.pi
self.spinAng = y * (1 - math.clamp(dt * 8, 0, 1))
end
spinYaw = self.spinAng
end
else
self.spinAng = 0
end
self:Pose(swing, self.heading - rootYaw + spinYaw, bob)
end
function swap:Scan()
self.rParts, self.rDecals = {}, {}
local char = player.Character
if not char then return end
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" and not d:FindFirstAncestorOfClass("Tool") then
table.insert(self.rParts, d)
elseif d:IsA("Decal") and not d:FindFirstAncestorOfClass("Tool") then
if self.origDecal[d] == nil then self.origDecal[d] = d.Transparency end
table.insert(self.rDecals, d)
end
end
end
function swap:Paint()
local now = os.clock()
if now >= self.nextScan then
self.nextScan = now + 0.5
self:Scan()
end
for _, p in ipairs(self.rParts) do
if p.Parent then p.LocalTransparencyModifier = 1 end
end
for _, d in ipairs(self.rDecals) do
if d.Parent then d.Transparency = 1 end
end
end
function swap:Unhide()
if self.bound then
RunService:UnbindFromRenderStep("GZ_SwapHide")
self.bound = false
end
for _, p in ipairs(self.rParts) do
if p.Parent then p.LocalTransparencyModifier = 0 end
end
for d, o in pairs(self.origDecal) do
if d.Parent then d.Transparency = o end
end
self.rParts, self.rDecals, self.origDecal = {}, {}, {}
self.nextScan = 0
end
function swap:Apply()
self:Build()
if self.Values.HideReal then
if not self.bound then
self.bound = true
RunService:BindToRenderStep("GZ_SwapHide", Enum.RenderPriority.Camera.Value + 1, function()
self:Paint()
end)
end
else
self:Unhide()
end
end
function swap:Remove()
self:Wipe()
self:Unhide()
end
function swap:Reset()
self:Wipe()
self.rParts, self.rDecals, self.origDecal = {}, {}, {}
self.nextScan = 0
end
local FX = {}
FX.shakes = {}
FX.shakeBound = false

function FX.Part(props, parent)
local d = {
Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false,
CastShadow = false, Locked = true, Massless = true, Material = Enum.Material.SmoothPlastic,
}
for k, v in pairs(props) do d[k] = v end
return new("Part", d, parent)
end

function FX.Ball(props, parent)
local p = FX.Part(props, parent)
new("SpecialMesh", {MeshType = Enum.MeshType.Sphere}, p)
return p
end

function FX.Anchor(fx, pos, life)
local p = FX.Part({Size = Vector3.new(1, 1, 1), Transparency = 1, Position = pos}, fx)
game:GetService("Debris"):AddItem(p, life)
return p
end

function FX.Emit(part, n, props)
props.Rate = 0
local pe = new("ParticleEmitter", props, part)
pe:Emit(n)
return pe
end

function FX.Disc(fx, base, d, th, color, trans, mat, lift)
local p = FX.Part({Size = Vector3.new(th, d, d), Color = color, Transparency = trans, Material = mat or Enum.Material.SmoothPlastic}, fx)
p.CFrame = base * CFrame.new(0, lift or 0, 0) * CFrame.Angles(0, 0, math.pi / 2)
return p
end

function FX.Place(list, cf, spin)
for _, e in ipairs(list) do
if e.rotor then
e.part.CFrame = cf * e.off * CFrame.Angles(0, spin * e.rotor, 0)
else
e.part.CFrame = cf * e.off
end
end
end

function FX.Shake(pos, strength, dur, maxDist)
table.insert(FX.shakes, {t0 = os.clock(), dur = dur, s = strength, pos = pos, max = maxDist})
if FX.shakeBound then return end
FX.shakeBound = true
RunService:BindToRenderStep("GZ_FXShake", Enum.RenderPriority.Camera.Value + 2, function()
local cam = workspace.CurrentCamera
if not cam then return end
local now = os.clock()
local amp = 0
for i = #FX.shakes, 1, -1 do
local s = FX.shakes[i]
local t = (now - s.t0) / s.dur
if t >= 1 then
table.remove(FX.shakes, i)
else
local d = (cam.CFrame.Position - s.pos).Magnitude
amp = amp + math.clamp(1 - d / s.max, 0, 1) * (1 - t) ^ 2 * s.s
end
end
if amp > 0 then
cam.CFrame = cam.CFrame * CFrame.Angles(
math.rad((math.random() - 0.5) * amp),
math.rad((math.random() - 0.5) * amp),
math.rad((math.random() - 0.5) * amp * 0.5))
elseif #FX.shakes == 0 then
RunService:UnbindFromRenderStep("GZ_FXShake")
FX.shakeBound = false
end
end)
end

function FX.Clear()
FX.shakes = {}
if FX.shakeBound then
RunService:UnbindFromRenderStep("GZ_FXShake")
FX.shakeBound = false
end
end

function FX.BuildDrone(fx)
local list = {}
local V = Vector3.new
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local function add(size, off, color, mat, o)
o = o or {}
local props = {Size = size, Color = color, Material = mat or Enum.Material.SmoothPlastic, Transparency = o.trans or 0}
if o.ball then props.Shape = Enum.PartType.Ball end
if o.cyl then props.Shape = Enum.PartType.Cylinder end
local p = FX.Part(props, fx)
table.insert(list, {part = p, off = off, rotor = o.rotor})
return p
end
add(V(1.5, 0.5, 2.2), CFrame.new(0, 0, 0), C(38, 40, 48), Enum.Material.Metal)
add(V(1.1, 0.55, 1.1), CFrame.new(0, 0.28, 0.25), C(70, 75, 88), Enum.Material.Metal, {ball = true})
add(V(0.8, 0.5, 1.0), CFrame.new(0, -0.45, -0.2), C(200, 40, 40))
local eye = add(V(0.45, 0.45, 0.45), CFrame.new(0, 0, -1.15), C(255, 40, 40), Enum.Material.Neon, {ball = true})
new("PointLight", {Color = C(255, 40, 40), Range = 14, Brightness = 3}, eye)
add(V(3.6, 0.12, 0.22), CFrame.Angles(0, math.rad(45), 0), C(30, 30, 34))
add(V(3.6, 0.12, 0.22), CFrame.Angles(0, math.rad(-45), 0), C(30, 30, 34))
local n = 0
for _, x in ipairs({-1.27, 1.27}) do
for _, z in ipairs({-1.27, 1.27}) do
n = n + 1
add(V(0.05, 1.9, 1.9), CFrame.new(x, 0.22, z) * CFrame.Angles(0, 0, math.pi / 2), C(90, 95, 110), nil, {cyl = true, trans = 0.75})
add(V(1.9, 0.04, 0.2), CFrame.new(x, 0.26, z), C(15, 15, 18), nil, {rotor = (n % 2 == 0) and 1 or -1})
end
end
return list
end

function FX.BuildBomb(fx, sc, nuke)
local list = {}
local V = Vector3.new
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local function cf(x, y, z) return CFrame.new(x * sc, y * sc, z * sc) end
local function add(size, off, color, mat, ball)
local props = {Size = size * sc, Color = color, Material = mat or Enum.Material.Metal}
local p = ball and FX.Ball(props, fx) or FX.Part(props, fx)
table.insert(list, {part = p, off = off})
return p
end
local body = nuke and C(190, 192, 198) or C(62, 68, 52)
add(V(1.0, 1.0, 3.0), cf(0, 0, 0), body, nil, true)
add(V(0.9, 0.9, 1.1), cf(0, 0, -1.3), nuke and C(60, 60, 64) or C(40, 44, 34), nil, true)
add(V(1.06, 1.06, 0.4), cf(0, 0, -0.2), nuke and C(240, 200, 40) or C(210, 60, 40), Enum.Material.SmoothPlastic, true)
add(V(0.1, 1.9, 0.8), cf(0, 0, 1.3), C(40, 42, 46))
add(V(1.9, 0.1, 0.8), cf(0, 0, 1.3), C(40, 42, 46))
local tail = FX.Part({Size = V(0.2, 0.2, 0.2) * sc, Transparency = 1}, fx)
table.insert(list, {part = tail, off = cf(0, 0, 1.9)})
new("ParticleEmitter", {
Rate = nuke and 90 or 55, Lifetime = NumberRange.new(0.5, 0.9), Speed = NumberRange.new(0, 1),
Size = NumberSequence.new(2 * sc, 0.2), Transparency = NumberSequence.new(0.2, 1),
Color = ColorSequence.new(C(255, 170, 60), C(90, 85, 82)), LightEmission = 0.6,
Texture = "rbxasset://textures/particles/smoke_main.dds",
}, tail)
return list
end

function FX.Crater(fx, base, sc, lite)
local C = Color3.fromRGB
local V = Vector3.new
local Debris = game:GetService("Debris")
local list = {}
local function d(dia, th, color, trans, mat, lift)
local p = FX.Disc(fx, base, dia * sc, th, color, trans, mat, lift)
table.insert(list, p)
return p
end
d(14, 0.06, C(50, 42, 38), 0.35, nil, 0.04)
d(8.5, 0.08, C(18, 15, 14), 0, nil, 0.07)
d(5.5, 0.09, C(34, 28, 26), 0, nil, 0.09)
if not lite then
local glow = d(4, 0.1, C(255, 110, 30), 0.35, Enum.Material.Neon, 0.11)
tween(glow, 4, {Transparency = 1})
for i = 1, 12 do
local a = (i / 12) * math.pi * 2 + math.random() * 0.3
local r = (4.5 + math.random() * 0.8) * sc
local sz = V(1.0 + math.random() * 0.8, 0.5 + math.random() * 0.5, 0.8 + math.random() * 0.6) * sc
local p = FX.Part({Size = sz, Color = C(70, 60, 52), Material = Enum.Material.Slate}, fx)
p.CFrame = base * CFrame.new(math.cos(a) * r, sz.Y * 0.35, math.sin(a) * r)
* CFrame.Angles(math.rad(math.random(-20, 20)), a + math.random(), math.rad(math.random(-20, 20)))
table.insert(list, p)
end
end
task.delay(lite and 8 or 22, function()
for _, p in ipairs(list) do
pcall(function()
tween(p, 3, {Transparency = 1})
Debris:AddItem(p, 3.2)
end)
end
end)
end

function FX.Boom(fx, ground, up, sc, crater)
sc = sc or 1
local V = Vector3.new
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local Debris = game:GetService("Debris")
local cam = workspace.CurrentCamera
local dist = cam and (cam.CFrame.Position - ground).Magnitude or 0
local lite = dist > 350
local ctr = ground + up * (2.2 * sc)
local base = CFrame.lookAt(ground, ground + up) * CFrame.Angles(-math.pi / 2, 0, 0)
if not lite then
new("Explosion", {
Position = ctr, BlastRadius = 8 * sc, BlastPressure = 0, DestroyJointRadiusPercent = 0,
ExplosionType = Enum.ExplosionType.NoCraters,
}, workspace)
end
local function ball(color, s0, s1, t, trans0)
local p = FX.Ball({Color = color, Material = Enum.Material.Neon, Size = V(s0, s0, s0) * sc, Position = ctr, Transparency = trans0 or 0.05}, fx)
tween(p, t, {Size = V(s1, s1, s1) * sc, Transparency = 1}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
Debris:AddItem(p, t + 0.1)
end
ball(C(255, 255, 235), 4, 20, 0.22)
ball(C(255, 215, 110), 3, 24, 0.4)
ball(C(255, 130, 30), 3, 30, 0.6)
ball(C(210, 50, 20), 2, 24, 0.85)
ball(C(255, 235, 200), 6, 38, 0.35, 0.8)
local col = FX.Ball({Color = C(255, 150, 40), Material = Enum.Material.Neon, Size = V(6, 6, 6) * sc, Position = ctr, Transparency = 0.1}, fx)
tween(col, 0.75, {Size = V(15, 30, 15) * sc, Position = ctr + up * 10 * sc, Transparency = 1}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
Debris:AddItem(col, 0.85)
local ring = FX.Disc(fx, base, 3, 0.35, C(255, 220, 170), 0.3, Enum.Material.Neon, 0.3)
tween(ring, 0.6, {Size = V(0.35, 46 * sc, 46 * sc), Transparency = 1})
Debris:AddItem(ring, 0.7)
local la = FX.Anchor(fx, ctr + up * 3, 1)
local light = new("PointLight", {Color = C(255, 170, 80), Range = 45, Brightness = 10}, la)
tween(light, 0.8, {Brightness = 0})
if not lite then
local a = FX.Anchor(fx, ctr, 3)
local fade = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
FX.Emit(a, math.floor(50 * sc), {
Texture = "rbxasset://textures/particles/fire_main.dds", Lifetime = NumberRange.new(0.5, 1.1),
Speed = NumberRange.new(18 * sc, 40 * sc), SpreadAngle = Vector2.new(70, 70),
Size = NumberSequence.new(4 * sc, 0), Transparency = fade,
Color = ColorSequence.new(C(255, 200, 90), C(220, 60, 20)), LightEmission = 1,
Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-90, 90), Acceleration = V(0, 10, 0),
})
FX.Emit(a, 40, {
Lifetime = NumberRange.new(0.6, 1.4), Speed = NumberRange.new(35, 85), SpreadAngle = Vector2.new(80, 80),
Size = NumberSequence.new(0.7, 0), Transparency = fade,
Color = ColorSequence.new(C(255, 230, 120), C(255, 120, 30)), LightEmission = 1, Acceleration = V(0, -55, 0),
})
local sm = FX.Anchor(fx, ground + up * 1.5, 7)
local pe = FX.Emit(sm, 30, {
Texture = "rbxasset://textures/particles/smoke_main.dds", Lifetime = NumberRange.new(2.5, 4.5),
Speed = NumberRange.new(8 * sc, 20 * sc), SpreadAngle = Vector2.new(35, 35),
Size = NumberSequence.new(6 * sc, 20 * sc),
Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 1)}),
Color = ColorSequence.new(C(60, 56, 54), C(110, 104, 100)), Acceleration = V(0, 5, 0),
Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-40, 40), LightInfluence = 0.6,
})
pe.Rate = 18
task.delay(1.8, function() pcall(function() pe.Rate = 0 end) end)
local dust = FX.Anchor(fx, ground + up * 0.5, 4)
FX.Emit(dust, math.floor(30 * sc), {
Texture = "rbxasset://textures/particles/smoke_main.dds", Lifetime = NumberRange.new(1, 1.8),
Speed = NumberRange.new(25, 45), SpreadAngle = Vector2.new(88, 88),
Size = NumberSequence.new(4 * sc, 10 * sc),
Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1)}),
Color = ColorSequence.new(C(150, 135, 110)), LightInfluence = 0.6,
})
local fire = FX.Anchor(fx, ground + up * 1, 6.5)
new("ParticleEmitter", {
Rate = 10, Texture = "rbxasset://textures/particles/fire_main.dds", Lifetime = NumberRange.new(0.5, 1),
Speed = NumberRange.new(3, 8), SpreadAngle = Vector2.new(25, 25), Size = NumberSequence.new(3 * sc, 0),
Transparency = fade, Color = ColorSequence.new(C(255, 170, 60), C(200, 50, 20)), LightEmission = 1,
}, fire)
local fl = new("PointLight", {Color = C(255, 140, 50), Range = 20, Brightness = 2}, fire)
tween(fl, 6, {Brightness = 0})
local bits = {}
for i = 1, 26 do
local streak = i > 10
local p
if streak then
p = FX.Part({Size = V(0.14, 0.14, 1.4), Color = C(255, 200, 80), Material = Enum.Material.Neon, Position = ctr}, fx)
else
local sz = 0.3 + math.random() * 0.5
local hot = i % 3 == 0
p = FX.Part({
Size = V(sz, sz, sz), Color = hot and C(255, 140, 40) or C(50, 44, 40),
Material = hot and Enum.Material.Neon or Enum.Material.Slate, Position = ctr,
}, fx)
end
local ang = math.random() * math.pi * 2
local sp = (12 + math.random() * 22) * sc
bits[i] = {part = p, streak = streak, vel = V(math.cos(ang) * sp, (25 + math.random() * 30) * sc, math.sin(ang) * sp),
rot = V(math.random() * 6, math.random() * 6, math.random() * 6)}
end
task.spawn(function()
local t0 = os.clock()
while os.clock() - t0 < 1.5 do
local dt = RunService.Heartbeat:Wait()
for _, b in ipairs(bits) do
if b.part.Parent and b.part.Position.Y > ground.Y - 1 then
b.vel = b.vel + V(0, -70 * dt, 0)
local np = b.part.Position + b.vel * dt
if b.streak then
b.part.CFrame = CFrame.lookAt(np, np + b.vel)
else
b.part.CFrame = (b.part.CFrame * CFrame.Angles(b.rot.X * dt, b.rot.Y * dt, b.rot.Z * dt)).Rotation + np
end
end
end
end
for _, b in ipairs(bits) do b.part:Destroy() end
end)
FX.Shake(ground, 4 * sc, 0.6 + 0.3 * sc, 110 * sc)
end
if crater ~= false then FX.Crater(fx, base, sc, lite) end
end

function FX.Nuke(fx, ground, up)
local V = Vector3.new
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local dist = cam and (cam.CFrame.Position - ground).Magnitude or 500
local base = CFrame.lookAt(ground, ground + up) * CFrame.Angles(-math.pi / 2, 0, 0)
local parts = {}
local QO = Enum.EasingStyle.Quad
local OUT = Enum.EasingDirection.Out
local function ell(color, size, pos, trans)
local p = FX.Ball({Color = color, Material = Enum.Material.Neon, Size = size, Position = pos, Transparency = trans or 0}, fx)
table.insert(parts, p)
return p
end
local sg = new("ScreenGui", {Name = "GZ_NukeFlash", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 950}, GUI_PARENT)
local fr = new("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1),
BackgroundTransparency = 0.1 + 0.8 * math.clamp(dist / 1500, 0, 1),
}, sg)
tween(fr, 3, {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
Debris:AddItem(sg, 3.3)
local ex0 = Lighting.ExposureCompensation
tween(Lighting, 0.15, {ExposureCompensation = ex0 + 3})
task.delay(0.6, function() tween(Lighting, 3.5, {ExposureCompensation = ex0}) end)
local flash = ell(C(255, 255, 255), V(10, 10, 10), ground + up * 6)
tween(flash, 0.7, {Size = V(300, 300, 300), Transparency = 1}, QO, OUT)
local dome = ell(C(255, 235, 200), V(10, 10, 10), ground + up * 2, 0.7)
tween(dome, 2.4, {Size = V(900, 900, 900), Transparency = 1}, QO, OUT)
local ring = FX.Disc(fx, base, 20, 0.5, C(255, 235, 200), 0.4, Enum.Material.Neon, 0.4)
table.insert(parts, ring)
tween(ring, 2.6, {Size = V(0.5, 1100, 1100), Transparency = 1}, QO, OUT)
local fb = ell(C(255, 150, 40), V(8, 8, 8), ground + up * 4, 0.05)
tween(fb, 1.6, {Size = V(120, 100, 120), Position = ground + up * 48}, QO, OUT)
task.delay(1.6, function()
pcall(function()
tween(fb, 5, {Size = V(125, 62, 125), Position = ground + up * 108, Color = C(95, 70, 60), Transparency = 0.35}, QO, OUT)
end)
end)
local core = ell(C(255, 200, 90), V(6, 6, 6), ground + up * 40, 0.2)
tween(core, 2.2, {Size = V(80, 50, 80), Position = ground + up * 95}, QO, OUT)
task.delay(2.2, function() pcall(function() tween(core, 4, {Transparency = 1, Color = C(200, 70, 30)}) end) end)
local stem = FX.Part({
Shape = Enum.PartType.Cylinder, Size = V(2, 14, 14), Color = C(255, 130, 40), Material = Enum.Material.Neon,
Transparency = 0.15, CFrame = base * CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, math.pi / 2),
}, fx)
table.insert(parts, stem)
task.delay(0.5, function()
pcall(function()
tween(stem, 5, {
Size = V(95, 24, 24), CFrame = base * CFrame.new(0, 47.5, 0) * CFrame.Angles(0, 0, math.pi / 2),
Color = C(70, 60, 56), Transparency = 0.35,
}, QO, OUT)
end)
end)
local sk = ell(C(235, 225, 215), V(10, 4, 10), ground + up * 30, 0.7)
task.delay(1.2, function()
pcall(function()
tween(sk, 2.5, {Size = V(140, 10, 140), Position = ground + up * 72}, QO, OUT)
end)
end)
local lp = FX.Anchor(fx, ground + up * 30, 6)
local light = new("PointLight", {Color = C(255, 190, 110), Range = 60, Brightness = 12}, lp)
tween(light, 4, {Brightness = 0})
local fade = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
local a = FX.Anchor(fx, ground + up * 3, 8)
FX.Emit(a, 160, {
Texture = "rbxasset://textures/particles/fire_main.dds", Lifetime = NumberRange.new(1.2, 2.4),
Speed = NumberRange.new(40, 110), SpreadAngle = Vector2.new(80, 80), Size = NumberSequence.new(14, 0),
Transparency = fade, Color = ColorSequence.new(C(255, 210, 100), C(220, 60, 20)), LightEmission = 1,
Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-60, 60),
})
FX.Emit(a, 150, {
Texture = "rbxasset://textures/particles/smoke_main.dds", Lifetime = NumberRange.new(3, 5),
Speed = NumberRange.new(80, 160), SpreadAngle = Vector2.new(88, 88), Size = NumberSequence.new(10, 34),
Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)}),
Color = ColorSequence.new(C(140, 125, 105)), LightInfluence = 0.6,
})
local col = FX.Anchor(fx, ground + up * 4, 12)
local pe = new("ParticleEmitter", {
Rate = 60, Texture = "rbxasset://textures/particles/smoke_main.dds", Lifetime = NumberRange.new(4, 7),
Speed = NumberRange.new(30, 50), SpreadAngle = Vector2.new(10, 10), Size = NumberSequence.new(16, 40),
Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)}),
Color = ColorSequence.new(C(50, 45, 44), C(90, 84, 80)), LightInfluence = 0.5,
}, col)
task.delay(4, function() pcall(function() pe.Rate = 0 end) end)
FX.Shake(ground, 12, 5, 3000)
FX.Crater(fx, base, 6, false)
task.delay(8.5, function()
for _, p in ipairs(parts) do
pcall(function()
tween(p, 4, {Transparency = 1})
Debris:AddItem(p, 4.3)
end)
end
end)
end

do
local banHammer = registerModule({
Name = tr("Ban Hammer", "\u{411}\u{430}\u{43D}-\u{43C}\u{43E}\u{43B}\u{43E}\u{442}"),
Desc = tr("Gives you a hammer. On hit: knock the player back, or call a ban drone (visual, only on your screen)", "\u{414}\u{430}\u{451}\u{442} \u{43C}\u{43E}\u{43B}\u{43E}\u{442}. \u{41F}\u{440}\u{438} \u{443}\u{434}\u{430}\u{440}\u{435}: \u{43E}\u{442}\u{43A}\u{438}\u{434}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{430} \u{438}\u{43B}\u{438} \u{432}\u{44B}\u{437}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{431}\u{430}\u{43D}-\u{434}\u{440}\u{43E}\u{43D} (\u{432}\u{438}\u{437}\u{443}\u{430}\u{43B}, \u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Mode", Label = tr("On hit", "\u{41F}\u{440}\u{438} \u{443}\u{434}\u{430}\u{440}\u{435}"), Type = "segmented", Default = "Ban",
Options = {
{"Knock", tr("Knockback", "\u{41E}\u{442}\u{43A}\u{438}\u{434}\u{44B}\u{432}\u{430}\u{43D}\u{438}\u{435}")},
{"Ban", tr("Ban drone", "\u{411}\u{430}\u{43D} \u{434}\u{440}\u{43E}\u{43D}\u{43E}\u{43C}")},
}},
{Key = "Power", Label = tr("Knockback power", "\u{421}\u{438}\u{43B}\u{430} \u{43E}\u{442}\u{43A}\u{438}\u{434}\u{44B}\u{432}\u{430}\u{43D}\u{438}\u{44F}"), Type = "slider", Min = 50, Max = 500, Step = 10, Default = 160,
ShowIf = function(v) return v.Mode == "Knock" end},
{Key = "BackAfter", Label = tr("Player comes back after (sec)", "\u{418}\u{433}\u{440}\u{43E}\u{43A} \u{432}\u{435}\u{440}\u{43D}\u{451}\u{442}\u{441}\u{44F} \u{447}\u{435}\u{440}\u{435}\u{437} (\u{441}\u{435}\u{43A})"), Type = "slider", Min = 3, Max = 60, Step = 1, Default = 10,
ShowIf = function(v) return v.Mode == "Ban" end},
{Key = "Reach", Label = tr("Hit distance", "\u{414}\u{430}\u{43B}\u{44C}\u{43D}\u{43E}\u{441}\u{442}\u{44C} \u{443}\u{434}\u{430}\u{440}\u{430}"), Type = "slider", Min = 5, Max = 20, Step = 1, Default = 9},
},
})
banHammer.SIGN = 1
banHammer.gen = 0
banHammer.tool = nil
banHammer.fx = nil
banHammer.swinging = false
banHammer.banned = {}
banHammer.vanished = {}
banHammer.bound = false

function banHammer:Folder()
if not self.fx or not self.fx.Parent then
self.fx = new("Folder", {Name = "GZ_BanFX"}, workspace)
end
return self.fx
end

function banHammer:Burst(pos, color, s0, s1, t)
local p = FX.Ball({
Size = Vector3.new(s0, s0, s0), Position = pos, Material = Enum.Material.Neon, Color = color, Transparency = 0.1,
}, self:Folder())
tween(p, t, {Size = Vector3.new(s1, s1, s1), Transparency = 1})
game:GetService("Debris"):AddItem(p, t + 0.1)
end

function banHammer:Give()
local backpack = player:FindFirstChildOfClass("Backpack")
if not backpack then return end
local char = player.Character
if self.tool and self.tool.Parent and (self.tool.Parent == backpack or self.tool.Parent == char) then return end
if self.tool then self.tool:Destroy() end
local tool = new("Tool", {Name = "BanHammer", ToolTip = "Ban Hammer", RequiresHandle = true, CanBeDropped = false})
local function part(name, size, color, mat)
return new("Part", {
Name = name, Size = size, Color = color, Material = mat or Enum.Material.SmoothPlastic,
Anchored = false, CanCollide = false, CanQuery = false, CanTouch = false, Massless = true, CastShadow = false,
}, tool)
end
local GOLD = Color3.fromRGB(255, 200, 60)
local handle = part("Handle", Vector3.new(0.45, 4.2, 0.45), Color3.fromRGB(122, 82, 46), Enum.Material.Wood)
local function attach(p, off)
new("Weld", {Part0 = handle, Part1 = p, C0 = off}, p)
end
local head = part("Head", Vector3.new(2.8, 1.5, 1.5), Color3.fromRGB(150, 155, 168), Enum.Material.Metal)
attach(head, CFrame.new(0, 1.9, 0))
for _, sx in ipairs({-1, 1}) do
local cap = part("Cap", Vector3.new(0.25, 1.6, 1.6), GOLD, Enum.Material.Metal)
attach(cap, CFrame.new(sx * 1.4, 1.9, 0))
end
local pommel = part("Pommel", Vector3.new(0.7, 0.45, 0.7), GOLD, Enum.Material.Metal)
attach(pommel, CFrame.new(0, -2.2, 0))
for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back}) do
local sg = new("SurfaceGui", {Face = face, CanvasSize = Vector2.new(280, 150), LightInfluence = 0}, head)
new("TextLabel", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "BAN", TextScaled = true,
Font = Enum.Font.GothamBlack, TextColor3 = Color3.fromRGB(200, 30, 30),
}, sg)
end
tool.GripPos = Vector3.new(0, -1.4, 0)
tool.Activated:Connect(function() self:Swing() end)
tool.Parent = backpack
self.tool = tool
local hum = getHumanoid()
if hum then pcall(function() hum:EquipTool(tool) end) end
end

function banHammer:Swing()
local tool = self.tool
if self.swinging or not tool or not tool.Parent then return end
self.swinging = true
task.spawn(function()
local base = CFrame.new(0, -1.4, 0)
local t0 = os.clock()
local hit = false
while true do
local t = os.clock() - t0
if t > 0.7 or not tool.Parent then break end
local a
if t < 0.22 then
a = -1.0 * (t / 0.22)
elseif t < 0.34 then
a = -1.0 + (t - 0.22) / 0.12 * 2.4
else
a = 1.4 * (1 - (t - 0.34) / 0.36)
end
tool.Grip = base * CFrame.Angles(a * self.SIGN, 0, 0)
if not hit and t >= 0.32 then
hit = true
local ok, err = pcall(function() self:Hit() end)
if not ok then report("[Ban Hammer] " .. tostring(err)) end
end
RunService.Heartbeat:Wait()
end
if tool.Parent then tool.Grip = base end
self.swinging = false
end)
end

function banHammer:Hit()
local root = getRoot()
if not root then return end
local v = self.Values
local look = root.CFrame.LookVector
local best, bestD, bestHrp
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= player and not self.banned[pl] and pl.Character then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
if hrp then
local rel = hrp.Position - root.Position
local d = rel.Magnitude
if d <= v.Reach and (d < 2 or rel.Unit:Dot(look) > 0.2) and (not bestD or d < bestD) then
best, bestD, bestHrp = pl, d, hrp
end
end
end
end
if not best then return end
self:Burst(bestHrp.Position, Color3.fromRGB(255, 230, 150), 1.5, 6, 0.25)
if v.Mode == "Knock" then
self:Knock(best, bestHrp, root)
else
self:Ban(best)
end
end

function banHammer:Knock(pl, hrp, root)
local flat = Vector3.new(hrp.Position.X - root.Position.X, 0, hrp.Position.Z - root.Position.Z)
if flat.Magnitude < 0.1 then flat = root.CFrame.LookVector end
local dir = (flat.Unit + Vector3.new(0, 0.55, 0)).Unit
local power = self.Values.Power
pcall(function() hrp:ApplyImpulse(dir * power * hrp.AssemblyMass) end)
task.spawn(function()
for _ = 1, 8 do
if not hrp.Parent then break end
hrp.AssemblyLinearVelocity = dir * power
RunService.Heartbeat:Wait()
end
end)
end

function banHammer:Vanish(pl, char)
local hum = char:FindFirstChildOfClass("Humanoid")
self.vanished[pl] = {
char = char, t0 = os.clock(), parts = {}, decals = {}, origDecal = {}, nextScan = 0,
hum = hum, ddt = hum and hum.DisplayDistanceType,
}
if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
if not self.bound then
self.bound = true
RunService:BindToRenderStep("GZ_BanHide", Enum.RenderPriority.Camera.Value + 1, function() self:Paint() end)
end
end

function banHammer:Paint()
local now = os.clock()
for pl, e in pairs(self.vanished) do
if not e.char.Parent then
self.vanished[pl] = nil
else
if now >= e.nextScan then
e.nextScan = now + 0.5
e.parts, e.decals = {}, {}
for _, d in ipairs(e.char:GetDescendants()) do
if d:IsA("BasePart") then
table.insert(e.parts, d)
elseif d:IsA("Decal") then
if e.origDecal[d] == nil then e.origDecal[d] = d.Transparency end
table.insert(e.decals, d)
end
end
end
local a = math.clamp((now - e.t0) / 0.4, 0, 1)
for _, p in ipairs(e.parts) do
if p.Parent then p.LocalTransparencyModifier = a end
end
for _, d in ipairs(e.decals) do
if d.Parent then d.Transparency = math.max(e.origDecal[d] or 0, a) end
end
end
end
end

function banHammer:Unvanish(pl)
local e = self.vanished[pl]
if e then
for _, p in ipairs(e.parts) do
if p.Parent then p.LocalTransparencyModifier = 0 end
end
for d, o in pairs(e.origDecal) do
if d.Parent then d.Transparency = o end
end
if e.hum and e.hum.Parent and e.ddt then e.hum.DisplayDistanceType = e.ddt end
self.vanished[pl] = nil
end
if self.bound and next(self.vanished) == nil then
RunService:UnbindFromRenderStep("GZ_BanHide")
self.bound = false
end
end

function banHammer:Ban(pl)
local char = pl.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
self.banned[pl] = true
local gen = self.gen
local back = self.Values.BackAfter
task.spawn(function()
local ok, err = pcall(function() self:BanRun(pl, char, hrp, gen, back) end)
if not ok then report("[Ban Hammer] " .. tostring(err)) end
if self.gen == gen then
self:Unvanish(pl)
self.banned[pl] = nil
end
end)
end

function banHammer:BanRun(pl, char, hrp, gen, back)
local V = Vector3.new
local fx = self:Folder()
local drone = FX.BuildDrone(fx)
local function killDrone()
for _, e in ipairs(drone) do e.part:Destroy() end
end
local ang = math.random() * math.pi * 2
local startPos = hrp.Position + V(math.cos(ang) * 42, 48, math.sin(ang) * 42)
local dur, t0, spin = 1.15, os.clock(), 0
while true do
local dt = RunService.Heartbeat:Wait()
if self.gen ~= gen then return end
if not hrp.Parent then killDrone() return end
local t = (os.clock() - t0) / dur
if t >= 1 then break end
local tgt = hrp.Position + V(0, 0.5, 0)
local pos = startPos:Lerp(tgt, t ^ 1.7)
spin = spin + dt * 60
FX.Place(drone, CFrame.lookAt(pos, tgt) * CFrame.Angles(math.rad(15 * (1 - t)), 0, 0), spin)
end
killDrone()
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
local skip = {fx, char}
if player.Character then table.insert(skip, player.Character) end
rp.FilterDescendantsInstances = skip
local res = workspace:Raycast(hrp.Position, V(0, -40, 0), rp)
local ground = res and res.Position or (hrp.Position - V(0, 3, 0))
local up = res and res.Normal or V(0, 1, 0)
FX.Boom(fx, ground, up, 1.25, true)
local hl = new("Highlight", {
Adornee = char, FillColor = Color3.fromRGB(255, 30, 30), OutlineColor = Color3.fromRGB(255, 0, 0),
FillTransparency = 0.05, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
}, fx)
local bb = new("BillboardGui", {
Adornee = hrp, Size = UDim2.fromOffset(60, 24), StudsOffset = V(0, 5, 0),
AlwaysOnTop = true, LightInfluence = 0, ResetOnSpawn = false,
}, fx)
local lbl = new("TextLabel", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "BAN", TextScaled = true,
Font = Enum.Font.GothamBlack, TextColor3 = Color3.fromRGB(255, 40, 40),
}, bb)
local st = new("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 3}, lbl)
tween(bb, 0.35, {Size = UDim2.fromOffset(240, 100)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
task.wait(1.3)
if self.gen ~= gen then return end
self:Vanish(pl, char)
tween(hl, 0.4, {FillTransparency = 1, OutlineTransparency = 1})
task.wait(1.0)
if self.gen ~= gen then return end
tween(lbl, 0.4, {TextTransparency = 1})
tween(st, 0.4, {Transparency = 1})
task.wait(0.5)
bb:Destroy()
hl:Destroy()
task.wait(math.max(0, back - 1.5))
end

function banHammer:Apply()
self:Give()
end

function banHammer:Remove()
self.gen = self.gen + 1
if self.tool then self.tool:Destroy() end
self.tool = nil
for pl in pairs(self.vanished) do self:Unvanish(pl) end
if self.fx then self.fx:Destroy() end
self.fx = nil
self.banned = {}
self.swinging = false
FX.Clear()
end

function banHammer:Reset()
self.tool = nil
self.swinging = false
end
end

do
local bomb = registerModule({
Name = tr("Bombardment", "\u{411}\u{43E}\u{43C}\u{431}\u{430}\u{440}\u{434}\u{438}\u{440}\u{43E}\u{432}\u{43A}\u{430}"),
Desc = tr("Visual: bombs, drones, explosions and fire all over the map. Sometimes a nuke (only on your screen)", "\u{412}\u{438}\u{437}\u{443}\u{430}\u{43B}: \u{43F}\u{43E} \u{432}\u{441}\u{435}\u{439} \u{43A}\u{430}\u{440}\u{442}\u{435} \u{43B}\u{435}\u{442}\u{44F}\u{442} \u{431}\u{43E}\u{43C}\u{431}\u{44B} \u{438} \u{434}\u{440}\u{43E}\u{43D}\u{44B}, \u{432}\u{437}\u{440}\u{44B}\u{432}\u{44B}, \u{43E}\u{433}\u{43E}\u{43D}\u{44C}. \u{418}\u{43D}\u{43E}\u{433}\u{434}\u{430} \u{44F}\u{434}\u{435}\u{440}\u{43A}\u{430} (\u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Rate", Label = tr("Strikes per second", "\u{423}\u{434}\u{430}\u{440}\u{43E}\u{432} \u{432} \u{441}\u{435}\u{43A}\u{443}\u{43D}\u{434}\u{443}"), Type = "slider", Min = 0.2, Max = 6, Step = 0.1, Default = 1.5},
{Key = "Radius", Label = tr("Area radius (studs)", "\u{420}\u{430}\u{434}\u{438}\u{443}\u{441} \u{437}\u{43E}\u{43D}\u{44B} (\u{441}\u{442}\u{443}\u{434}\u{43E}\u{432})"), Type = "slider", Min = 100, Max = 3000, Step = 100, Default = 600},
{Key = "NukeChance", Label = tr("Nuke chance (%)", "\u{428}\u{430}\u{43D}\u{441} \u{44F}\u{434}\u{435}\u{440}\u{43A}\u{438} (%)"), Type = "slider", Min = 0, Max = 100, Step = 1, Default = 15},
{Key = "Drones", Label = tr("Drones", "\u{414}\u{440}\u{43E}\u{43D}\u{44B}"), Type = "toggle", Default = true},
},
})
bomb.gen = 0
bomb.fx = nil
bomb.acc = 0
bomb.active = 0
bomb.nukeReady = 0
bomb.exp0 = nil

function bomb:Folder()
if not self.fx or not self.fx.Parent then
self.fx = new("Folder", {Name = "GZ_BombFX"}, workspace)
end
return self.fx
end

function bomb:Strike(nuke)
local fx = self:Folder()
local gen = self.gen
local V = Vector3.new
local root = getRoot()
local cam = workspace.CurrentCamera
local center = root and root.Position or (cam and cam.CFrame.Position) or V(0, 0, 0)
local R = self.Values.Radius
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
local skip = {fx}
for _, pl in ipairs(Players:GetPlayers()) do
if pl.Character then table.insert(skip, pl.Character) end
end
rp.FilterDescendantsInstances = skip
local ground, up
for _ = 1, 3 do
local a = math.random() * math.pi * 2
local r = R * math.sqrt(math.random())
local res = workspace:Raycast(V(center.X + math.cos(a) * r, center.Y + 700, center.Z + math.sin(a) * r), V(0, -2500, 0), rp)
if res then
ground, up = res.Position, res.Normal
break
end
end
if not ground then return false end
local kind = "bomb"
local sc, height, off, dur = 1, 320, 40 + math.random() * 80, 1.7 + math.random() * 0.8
if nuke then
kind, sc, height, off, dur = "nuke", 3.2, 700, 120, 4.2
elseif self.Values.Drones and math.random() < 0.4 then
kind, height, off, dur = "drone", 140, 160 + math.random() * 100, 1.8 + math.random() * 0.8
end
self.active = self.active + 1
task.spawn(function()
local ok, err = pcall(function()
local list = (kind == "drone") and FX.BuildDrone(fx) or FX.BuildBomb(fx, sc, kind == "nuke")
local a = math.random() * math.pi * 2
local startPos = ground + V(math.cos(a) * off, height, math.sin(a) * off)
local dir = (ground - startPos).Unit
local t0, spin = os.clock(), 0
while true do
local dt = RunService.Heartbeat:Wait()
if self.gen ~= gen then return end
local t = (os.clock() - t0) / dur
if t >= 1 then break end
spin = spin + dt * 60
FX.Place(list, CFrame.lookAt(startPos:Lerp(ground, t ^ 1.3), startPos:Lerp(ground, t ^ 1.3) + dir), spin)
end
for _, e in ipairs(list) do e.part:Destroy() end
if kind == "nuke" then
FX.Nuke(fx, ground, up)
else
FX.Boom(fx, ground, up, kind == "bomb" and 1.15 or 1, true)
end
end)
if not ok then report("[Bombardment] " .. tostring(err)) end
if self.gen == gen then self.active = math.max(0, self.active - 1) end
end)
return true
end

function bomb:Update(dt)
local v = self.Values
self.acc = self.acc + dt * v.Rate
local n = 0
while self.acc >= 1 and n < 4 do
self.acc = self.acc - 1
n = n + 1
if self.active < 28 then
local nuke = false
if os.clock() >= self.nukeReady and math.random() * 100 < v.NukeChance then
nuke = true
self.nukeReady = os.clock() + 14
end
if not self:Strike(nuke) and nuke then self.nukeReady = 0 end
end
end
if self.acc > 4 then self.acc = 0 end
end

function bomb:Apply()
if self.exp0 == nil then self.exp0 = Lighting.ExposureCompensation end
end

function bomb:Remove()
self.gen = self.gen + 1
self.active = 0
self.acc = 0
self.nukeReady = 0
if self.fx then self.fx:Destroy() end
self.fx = nil
FX.Clear()
if self.exp0 ~= nil then
Lighting.ExposureCompensation = self.exp0
self.exp0 = nil
end
local g = GUI_PARENT:FindFirstChild("GZ_NukeFlash")
if g then g:Destroy() end
end

function bomb:Reset() end
end
do
local dn = registerModule({
Name = tr("Death Note", "\u{422}\u{435}\u{442}\u{440}\u{430}\u{434}\u{44C} \u{441}\u{43C}\u{435}\u{440}\u{442}\u{438}"),
Desc = tr("A black notebook in your hands. Write a player's name: after the delay you laugh, the camera cuts to them and they clutch their heart and fall (visual, only on your screen)", "\u{427}\u{451}\u{440}\u{43D}\u{430}\u{44F} \u{442}\u{435}\u{442}\u{440}\u{430}\u{434}\u{44C} \u{432} \u{440}\u{443}\u{43A}\u{430}\u{445}. \u{412}\u{43F}\u{438}\u{448}\u{438} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{430}: \u{447}\u{435}\u{440}\u{435}\u{437} \u{432}\u{440}\u{435}\u{43C}\u{44F} \u{442}\u{44B} \u{441}\u{43C}\u{435}\u{451}\u{448}\u{44C}\u{441}\u{44F}, \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{430} \u{43F}\u{435}\u{440}\u{435}\u{445}\u{43E}\u{434}\u{438}\u{442} \u{43D}\u{430} \u{43D}\u{435}\u{433}\u{43E}, \u{43E}\u{43D} \u{445}\u{432}\u{430}\u{442}\u{430}\u{435}\u{442}\u{441}\u{44F} \u{437}\u{430} \u{441}\u{435}\u{440}\u{434}\u{446}\u{435} \u{438} \u{43F}\u{430}\u{434}\u{430}\u{435}\u{442} (\u{432}\u{438}\u{437}\u{443}\u{430}\u{43B}, \u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Delay", Label = tr("Delay before death (sec)", "\u{412}\u{440}\u{435}\u{43C}\u{44F} \u{434}\u{43E} \u{441}\u{43C}\u{435}\u{440}\u{442}\u{438} (\u{441}\u{435}\u{43A})"), Type = "slider", Min = 5, Max = 120, Step = 1, Default = 40},
{Key = "Stay", Label = tr("Body stays for (sec)", "\u{422}\u{435}\u{43B}\u{43E} \u{43B}\u{435}\u{436}\u{438}\u{442} (\u{441}\u{435}\u{43A})"), Type = "slider", Min = 3, Max = 60, Step = 1, Default = 10},
{Key = "ShowTimer", Label = tr("Show countdown", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{442}\u{430}\u{439}\u{43C}\u{435}\u{440}"), Type = "toggle", Default = true},
{Key = "Bars", Label = tr("Cinematic black bars", "\u{41A}\u{438}\u{43D}\u{43E}-\u{43F}\u{43E}\u{43B}\u{43E}\u{441}\u{44B}"), Type = "toggle", Default = true},
},
})
dn.gen = 0
dn.busy = false
dn.tool = nil
dn.fx = nil
dn.gui = nil
dn.selected = nil
dn.conns = {}
dn.st = nil
dn.body = nil
dn.hide = nil

dn.P0 = {lean = 0, neck = 0, lsz = 0, lsx = 0, lel = 0, rsz = 0, rsx = 0, rel = 0, hip = 0, knee = 0}
dn.CLUTCH15 = {lean = -0.4, neck = -0.35, lsz = 0.3, lsx = 0.45, lel = 1.9, rsz = -0.3, rsx = 0.45, rel = 1.9, hip = 0.3, knee = -0.6}
dn.CLUTCH6 = {lean = -0.4, neck = -0.35, lsz = 0.55, lsx = 1.0, lel = 0, rsz = -0.5, rsx = 0.9, rel = 0, hip = 0, knee = 0}
dn.LIMP15 = {lean = -0.05, neck = 0.1, lsz = -0.5, lsx = -0.2, lel = 0.3, rsz = 0.5, rsx = -0.2, rel = 0.3, hip = 0, knee = 0}
dn.LIMP6 = {lean = 0, neck = 0.1, lsz = -0.5, lsx = -0.25, lel = 0, rsz = 0.5, rsx = -0.25, rel = 0, hip = 0, knee = 0}
dn.LAUGH15 = {lean = 0.25, neck = 0.7, lsz = -0.9, lsx = 0.2, lel = 0.4, rsz = -0.25, rsx = 1.2, rel = 1.7, hip = 0, knee = 0}
dn.LAUGH6 = {lean = 0.25, neck = 0.7, lsz = -0.9, lsx = 0.2, lel = 0, rsz = -0.25, rsx = 2.4, rel = 0, hip = 0, knee = 0}

function dn.LerpP(a, b, t)
local r = {}
for k, v in pairs(a) do r[k] = v + (b[k] - v) * t end
return r
end

function dn.Rig(model)
local m = {}
for _, d in ipairs(model:GetDescendants()) do
if d:IsA("Motor6D") then m[d.Name] = d end
end
m.r15 = m.Waist ~= nil
return m
end

-- rotates a joint by `rot` given in the space of its Part0 (works for R6 and R15)
function dn.Pose(mo, rot)
if not mo or not mo.Parent then return end
local p = mo.C0.Position
mo.Transform = mo.C0:Inverse() * (CFrame.new(p) * rot * CFrame.new(-p)) * mo.C0
end

function dn.PoseRig(rig, P)
local function Rx(a) return CFrame.Angles(a, 0, 0) end
local function Rz(a) return CFrame.Angles(0, 0, a) end
local pose = dn.Pose
if rig.r15 then
pose(rig.Waist, Rx(P.lean))
pose(rig.Neck, Rx(P.neck))
pose(rig.LeftShoulder, Rz(P.lsz) * Rx(P.lsx))
pose(rig.RightShoulder, Rz(P.rsz) * Rx(P.rsx))
pose(rig.LeftElbow, Rx(P.lel))
pose(rig.RightElbow, Rx(P.rel))
pose(rig.LeftHip, Rx(P.hip))
pose(rig.RightHip, Rx(P.hip))
pose(rig.LeftKnee, Rx(P.knee))
pose(rig.RightKnee, Rx(P.knee))
else
pose(rig.RootJoint, Rx(P.lean))
pose(rig.Neck, Rx(P.neck))
pose(rig["Left Shoulder"], Rz(P.lsz) * Rx(P.lsx))
pose(rig["Right Shoulder"], Rz(P.rsz) * Rx(P.rsx))
pose(rig["Left Hip"], Rx(-P.lean))
pose(rig["Right Hip"], Rx(-P.lean))
end
end

function dn:Folder()
if not self.fx or not self.fx.Parent then
self.fx = new("Folder", {Name = "GZ_DeathNoteFX"}, workspace)
end
return self.fx
end

-- ===== notebook tool =====
function dn:Give()
local backpack = player:FindFirstChildOfClass("Backpack")
if not backpack then return end
local char = player.Character
if self.tool and self.tool.Parent and (self.tool.Parent == backpack or self.tool.Parent == char) then return end
if self.tool then self.tool:Destroy() end
local tool = new("Tool", {Name = "DeathNote", ToolTip = "Death Note", RequiresHandle = true, CanBeDropped = false})
local handle = new("Part", {
Name = "Handle", Size = Vector3.new(1.1, 1.5, 0.28), Color = Color3.fromRGB(14, 14, 17),
Material = Enum.Material.Leather, Anchored = false, CanCollide = false, CanQuery = false, CanTouch = false,
Massless = true, CastShadow = false,
}, tool)
local pages = new("Part", {
Name = "Pages", Size = Vector3.new(1.0, 1.4, 0.2), Color = Color3.fromRGB(240, 236, 225),
Anchored = false, CanCollide = false, CanQuery = false, CanTouch = false, Massless = true, CastShadow = false,
}, tool)
new("Weld", {Part0 = handle, Part1 = pages, C0 = CFrame.new(0.07, 0, 0)}, pages)
for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back}) do
local sg = new("SurfaceGui", {Face = face, CanvasSize = Vector2.new(220, 300), LightInfluence = 0}, handle)
local frame = new("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.84, 0.88),
BackgroundTransparency = 1,
}, sg)
new("UIStroke", {Color = Color3.new(1, 1, 1), Thickness = 2}, frame)
new("TextLabel", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "DEATH\nNOTE", TextScaled = true,
Font = Enum.Font.GothamBlack, TextColor3 = Color3.new(1, 1, 1),
}, sg)
end
tool.GripPos = Vector3.new(0, -0.2, 0)
tool.Equipped:Connect(function() self:ShowPanel(true) end)
tool.Unequipped:Connect(function() self:ShowPanel(false) end)
tool.Activated:Connect(function()
if self.panel then self:ShowPanel(not self.panel.Visible) end
end)
tool.Parent = backpack
self.tool = tool
local hum = getHumanoid()
if hum then pcall(function() hum:EquipTool(tool) end) end
end

-- ===== GUI =====
function dn:BuildGui()
if self.gui and self.gui.Parent then return end
local RED = Color3.fromRGB(190, 20, 30)
local sg = new("ScreenGui", {Name = "GZ_DeathNote", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 500}, GUI_PARENT)
self.gui = sg
local panel = new("Frame", {
Name = "Panel", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(340, 410), BackgroundColor3 = Color3.fromRGB(10, 10, 12), Visible = false,
}, sg)
corner(panel, 10)
stroke(panel, RED, 1.5)
self.panel = panel
textLabel(panel, {
Position = UDim2.fromOffset(16, 10), Size = UDim2.new(1, -60, 0, 28), Text = "DEATH NOTE",
Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = WHITE,
})
textLabel(panel, {
Position = UDim2.fromOffset(16, 40), Size = UDim2.new(1, -32, 0, 22),
Text = T(tr("Choose whose name to write", "\u{412}\u{44B}\u{431}\u{435}\u{440}\u{438}, \u{447}\u{44C}\u{451} \u{438}\u{43C}\u{44F} \u{432}\u{43F}\u{438}\u{441}\u{430}\u{442}\u{44C}")), TextSize = 13, TextColor3 = Theme.Sub,
})
local closeBtn = textButton(panel, {
Position = UDim2.new(1, -42, 0, 10), Size = UDim2.fromOffset(30, 30), Text = "X",
BackgroundColor3 = Color3.fromRGB(30, 30, 36), TextColor3 = WHITE, TextSize = 14,
})
corner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function() panel.Visible = false end)
local list = new("ScrollingFrame", {
Position = UDim2.fromOffset(12, 70), Size = UDim2.new(1, -24, 1, -140), BackgroundColor3 = Color3.fromRGB(18, 18, 22),
ScrollBarThickness = 4, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, panel)
corner(list, 8)
listLayout(list, 6)
new("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}, list)
self.list = list
local write = textButton(panel, {
Position = UDim2.new(0, 12, 1, -58), Size = UDim2.new(1, -24, 0, 46), Text = "",
BackgroundColor3 = Color3.fromRGB(40, 40, 46), TextColor3 = WHITE, TextSize = 16, Font = Enum.Font.GothamBold,
})
corner(write, 10)
self.writeBtn = write
write.MouseButton1Click:Connect(function()
if self.busy then return end
local pl = self.selected
if not pl or not pl.Parent then return end
self:Write(pl)
end)
local hud = new("Frame", {
Name = "Hud", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 70), Size = UDim2.fromOffset(280, 34),
BackgroundColor3 = Color3.fromRGB(10, 10, 12), BackgroundTransparency = 0.2, Visible = false,
}, sg)
corner(hud, 8)
stroke(hud, RED, 1.2)
self.hud = hud
self.hudLbl = textLabel(hud, {
Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBold, TextSize = 14,
})
local top = new("Frame", {Name = "BarTop", Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 50}, sg)
local bot = new("Frame", {Name = "BarBot", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 50}, sg)
self.barTop, self.barBot = top, bot
table.insert(self.conns, Players.PlayerAdded:Connect(function() self:RefreshList() end))
table.insert(self.conns, Players.PlayerRemoving:Connect(function() task.defer(function() self:RefreshList() end) end))
self:RefreshList()
end

function dn:RefreshSel()
local sel = self.selected
for p, b in pairs(self.rows or {}) do
if b.Parent then
b.BackgroundColor3 = (p == sel) and Color3.fromRGB(150, 20, 30) or Color3.fromRGB(28, 28, 34)
end
end
if self.writeBtn then
local on = sel ~= nil and sel.Parent ~= nil
self.writeBtn.BackgroundColor3 = on and Color3.fromRGB(190, 20, 30) or Color3.fromRGB(40, 40, 46)
self.writeBtn.Text = T(tr("Write name", "\u{412}\u{43F}\u{438}\u{441}\u{430}\u{442}\u{44C}")) .. (on and ("  -  " .. sel.DisplayName) or "")
end
end

function dn:RefreshList()
local list = self.list
if not list or not list.Parent then return end
clearList(list)
local players = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player then table.insert(players, p) end
end
table.sort(players, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end)
if self.selected and not self.selected.Parent then self.selected = nil end
self.rows = {}
if #players == 0 then
textLabel(list, {
Size = UDim2.new(1, 0, 0, 40), Text = T(tr("No other players", "\u{414}\u{440}\u{443}\u{433}\u{438}\u{445} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{43E}\u{432} \u{43D}\u{435}\u{442}")),
TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Center,
})
end
for i, p in ipairs(players) do
local label = p.DisplayName
if p.DisplayName ~= p.Name then label = label .. "  (@" .. p.Name .. ")" end
local b = textButton(list, {
LayoutOrder = i, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(28, 28, 34),
Text = label, TextColor3 = WHITE, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
})
corner(b, 8)
new("UIPadding", {PaddingLeft = UDim.new(0, 12)}, b)
self.rows[p] = b
b.MouseButton1Click:Connect(function()
self.selected = p
self:RefreshSel()
end)
end
self:RefreshSel()
end

function dn:ShowPanel(show)
self:BuildGui()
if show then self:RefreshList() end
self.panel.Visible = show and not self.busy
end

-- ===== write + countdown =====
function dn:Write(pl)
self.busy = true
self.panel.Visible = false
local gen = self.gen
local delay = self.Values.Delay
local name = pl.DisplayName
local t0 = os.clock()
task.spawn(function()
while os.clock() - t0 < delay do
if self.gen ~= gen then return end
if not pl.Parent then break end
if self.Values.ShowTimer and self.hud then
self.hud.Visible = true
self.hudLbl.Text = T(tr("Death Note", "\u{422}\u{435}\u{442}\u{440}\u{430}\u{434}\u{44C} \u{441}\u{43C}\u{435}\u{440}\u{442}\u{438}")) .. ": " .. name .. " - " .. math.ceil(delay - (os.clock() - t0)) .. "s"
end
task.wait(0.1)
end
if self.gen ~= gen then return end
if self.hud then self.hud.Visible = false end
if not pl.Parent then
self.busy = false
return
end
local ok, err = pcall(function() self:Scene(pl, gen) end)
if not ok then report("[Death Note] " .. tostring(err)) end
if self.gen == gen then
self:EndScene()
self.busy = false
end
end)
end

-- ===== hiding the real victim while the clone lies there =====
function dn:BindHide(char)
local hum = char:FindFirstChildOfClass("Humanoid")
self.hide = {char = char, parts = {}, decals = {}, orig = {}, next = 0, hum = hum, ddt = hum and hum.DisplayDistanceType}
if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
RunService:BindToRenderStep("GZ_DNHide", Enum.RenderPriority.Camera.Value + 1, function()
local h = self.hide
if not h or not h.char.Parent then return end
local now = os.clock()
if now >= h.next then
h.next = now + 0.5
h.parts, h.decals = {}, {}
for _, d in ipairs(h.char:GetDescendants()) do
if d:IsA("BasePart") then
table.insert(h.parts, d)
elseif d:IsA("Decal") then
if h.orig[d] == nil then h.orig[d] = d.Transparency end
table.insert(h.decals, d)
end
end
end
for _, p in ipairs(h.parts) do
if p.Parent then p.LocalTransparencyModifier = 1 end
end
for _, d in ipairs(h.decals) do
if d.Parent then d.Transparency = 1 end
end
end)
end

function dn:Unhide()
local h = self.hide
if not h then return end
self.hide = nil
pcall(function() RunService:UnbindFromRenderStep("GZ_DNHide") end)
for _, p in ipairs(h.parts) do
if p.Parent then p.LocalTransparencyModifier = 0 end
end
for d, o in pairs(h.orig) do
if d.Parent then d.Transparency = o end
end
if h.hum and h.hum.Parent and h.ddt then h.hum.DisplayDistanceType = h.ddt end
end

function dn:ClearBody(fade)
local b = self.body
self.body = nil
self:Unhide()
if not b or not b.Parent then return end
if fade then
for _, d in ipairs(b:GetDescendants()) do
if d:IsA("BasePart") or d:IsA("Decal") then
pcall(function() tween(d, 1, {Transparency = 1}) end)
end
end
game:GetService("Debris"):AddItem(b, 1.2)
else
b:Destroy()
end
end

-- ===== per-frame scene driver =====
function dn:Render()
local st = self.st
if not st then return end
local now = os.clock()
local cam = workspace.CurrentCamera
local e = st.emoji
if e and e.gui.Parent then
local t = now - e.t0
local pop = math.clamp(t / 0.25, 0, 1)
local sz = 130 * (1 - (1 - pop) ^ 3)
e.gui.Size = UDim2.fromOffset(sz, sz)
e.gui.StudsOffset = Vector3.new(0, 3.2 + math.sin(t * 6) * 0.25, 0)
e.label.Rotation = math.sin(t * 28) * 12
end
local v = st.victim
if v and v.clone and v.clone.Parent and v.root.Parent then
local th = 0
if v.fallT0 then
local ft = now - v.fallT0
if ft < 0.8 then
th = (math.pi / 2) * (ft / 0.8) ^ 2
else
th = math.pi / 2 - 0.07 * math.sin(math.clamp((ft - 0.8) / 0.3, 0, 1) * math.pi)
end
end
local cf = v.base * CFrame.new(v.pivot) * CFrame.Angles(th, 0, 0) * CFrame.new(-v.pivot)
v.root.CFrame = cf + Vector3.new(0, 0.7 * math.sin(th), 0)
end
if cam and st.mode == "victim" and st.camBase then
cam.CameraType = Enum.CameraType.Scriptable
local prog = math.clamp((now - st.camT0) / 4, 0, 1)
local b = st.camBase
local from = b.Position + Vector3.new(0, 1.6, 0) + b.LookVector * (9 - 2.5 * prog)
cam.CFrame = CFrame.lookAt(from, b.Position + Vector3.new(0, 1.2, 0))
end
end

function dn:EndScene()
pcall(function() RunService:UnbindFromRenderStep("GZ_DNScene") end)
local st = self.st
self.st = nil
if not st then return end
if st.emoji and st.emoji.gui then pcall(function() st.emoji.gui:Destroy() end) end
local cam = workspace.CurrentCamera
if cam then
cam.CameraType = st.camType or Enum.CameraType.Custom
cam.FieldOfView = st.fov or 70
local hum = getHumanoid()
if hum then cam.CameraSubject = hum end
end
if self.barTop then
tween(self.barTop, 0.5, {Size = UDim2.new(1, 0, 0, 0)})
tween(self.barBot, 0.5, {Size = UDim2.new(1, 0, 0, 0)})
end
end

function dn:Scene(pl, gen)
local cam = workspace.CurrentCamera
local char = player.Character
local head = char and char:FindFirstChild("Head")
if not cam or not head then
report("[Death Note] my character or camera not found")
return
end
if self.panel then self.panel.Visible = false end
local st = {mode = "me", camType = cam.CameraType, fov = cam.FieldOfView}
self.st = st
-- emoji above my head
local gui = new("BillboardGui", {
Name = "GZ_DNEmoji", Adornee = head, AlwaysOnTop = true, LightInfluence = 0,
Size = UDim2.fromOffset(0, 0), StudsOffset = Vector3.new(0, 3.2, 0),
}, head)
local label = new("TextLabel", {
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1, Text = "\u{1F602}", TextScaled = true, Font = Enum.Font.Gotham, TextColor3 = WHITE,
}, gui)
st.emoji = {gui = gui, label = label, t0 = os.clock()}
if self.Values.Bars and self.barTop then
tween(self.barTop, 0.6, {Size = UDim2.new(1, 0, 0.12, 0)})
tween(self.barBot, 0.6, {Size = UDim2.new(1, 0, 0.12, 0)})
end
RunService:BindToRenderStep("GZ_DNScene", Enum.RenderPriority.Last.Value, function()
local ok, err = pcall(function() self:Render() end)
if not ok and not self.warned then
self.warned = true
report("[Death Note] Render: " .. tostring(err))
end
end)
dbg("Death Note: emoji")
task.wait(3)
if self.gen ~= gen then return end
if st.emoji then
pcall(function() st.emoji.gui:Destroy() end)
st.emoji = nil
end
-- cut to the victim
local vchar = pl.Character
local vroot = vchar and vchar:FindFirstChild("HumanoidRootPart")
if not vroot then
report("[Death Note] victim character not loaded (too far / streaming)")
return
end
local base = vroot.CFrame
st.camBase = base
st.camT0 = os.clock()
st.mode = "victim"
cam.CameraType = Enum.CameraType.Scriptable
pcall(function() tween(cam, 1.2, {FieldOfView = 55}) end)
dbg("Death Note: camera on victim")
-- a fake body that falls (the real one is hidden on my screen only)
local okc, errc = pcall(function()
local old = vchar.Archivable
vchar.Archivable = true
local clone = vchar:Clone()
vchar.Archivable = old
if not clone then error("clone failed") end
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("LuaSourceContainer") or d:IsA("ForceField") then d:Destroy() end
end
local chum = clone:FindFirstChildOfClass("Humanoid")
if chum then
chum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
pcall(function() chum.EvaluateStateMachine = false end)
pcall(function() chum.PlatformStand = true end)
end
local croot = clone:FindFirstChild("HumanoidRootPart")
if not croot then
clone:Destroy()
error("clone has no root")
end
for _, d in ipairs(clone:GetDescendants()) do
if d:IsA("BasePart") then
d.CanCollide = false
d.CanQuery = false
d.CanTouch = false
d.Anchored = (d == croot)
end
end
local bcf, bsz = clone:GetBoundingBox()
local pivotWorld = Vector3.new(base.Position.X, bcf.Position.Y - bsz.Y / 2, base.Position.Z)
clone.Parent = self:Folder()
self:ClearBody(false)
self.body = clone
self:BindHide(vchar)
st.victim = {clone = clone, root = croot, base = croot.CFrame, pivot = croot.CFrame:PointToObjectSpace(pivotWorld)}
end)
if not okc then report("[Death Note] fake body: " .. tostring(errc)) end
task.wait(1.4)
if self.gen ~= gen then return end
if st.victim then st.victim.fallT0 = os.clock() end
task.wait(3.4)
if self.gen ~= gen then return end
local clone = st.victim and st.victim.clone
if clone then
task.delay(self.Values.Stay, function()
if self.gen == gen and self.body == clone then self:ClearBody(true) end
end)
end
end

function dn:Apply()
self:BuildGui()
self:Give()
end

function dn:Remove()
self.gen = self.gen + 1
self.busy = false
self:EndScene()
self:ClearBody(false)
if self.tool then self.tool:Destroy() end
self.tool = nil
for _, c in ipairs(self.conns) do c:Disconnect() end
self.conns = {}
if self.gui then self.gui:Destroy() end
self.gui, self.panel, self.list, self.writeBtn, self.hud, self.hudLbl, self.barTop, self.barBot = nil, nil, nil, nil, nil, nil, nil, nil
self.rows = {}
self.selected = nil
if self.fx then self.fx:Destroy() end
self.fx = nil
end

function dn:Reset()
self.tool = nil
end
end
local skin = registerModule({
Name = tr("Colorize Skin", "\u{426}\u{432}\u{435}\u{442} \u{441}\u{43A}\u{438}\u{43D}\u{430}"),
Desc = tr("Recolors your skin: solid, rainbow or smooth gradient", "\u{41F}\u{435}\u{440}\u{435}\u{43A}\u{440}\u{430}\u{448}\u{438}\u{432}\u{430}\u{435}\u{442} \u{441}\u{43A}\u{438}\u{43D}: \u{446}\u{432}\u{435}\u{442}, \u{440}\u{430}\u{434}\u{443}\u{433}\u{430} \u{438}\u{43B}\u{438} \u{43F}\u{43B}\u{430}\u{432}\u{43D}\u{44B}\u{439} \u{433}\u{440}\u{430}\u{434}\u{438}\u{435}\u{43D}\u{442}"),
Category = "Visuals",
Settings = {
{Key = "Mode", Label = tr("Mode", "\u{420}\u{435}\u{436}\u{438}\u{43C}"), Type = "segmented", Options = MODE_OPTIONS, Default = "Solid"},
{Key = "Color1", Label = LBL_C1, Type = "color", Default = Color3.fromRGB(160, 100, 255), ShowIf = showC1},
{Key = "Color2", Label = LBL_C2, Type = "color", Default = Color3.fromRGB(255, 80, 180), ShowIf = showC2},
{Key = "Speed", Label = tr("Animation speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{430}\u{43D}\u{438}\u{43C}\u{430}\u{446}\u{438}\u{438}"), Type = "slider", Min = 0.1, Max = 5, Step = 0.1, Default = 1,
ShowIf = showSpeed},
{Key = "Material", Label = tr("Material", "\u{41C}\u{430}\u{442}\u{435}\u{440}\u{438}\u{430}\u{43B}"), Type = "segmented", Default = "SmoothPlastic",
Options = {{"Plastic", "Plastic"}, {"SmoothPlastic", "Smooth"}, {"Neon", "Neon"}, {"ForceField", "Force"}}},
{Key = "Transparency", Label = tr("Transparency", "\u{41F}\u{440}\u{43E}\u{437}\u{440}\u{430}\u{447}\u{43D}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 0, Max = 0.9, Step = 0.05, Default = 0},
{Key = "HideClothes", Label = tr("Hide clothes (so the color is visible)", "\u{421}\u{43A}\u{440}\u{44B}\u{442}\u{44C} \u{43E}\u{434}\u{435}\u{436}\u{434}\u{443} (\u{447}\u{442}\u{43E}\u{431}\u{44B} \u{431}\u{44B}\u{43B} \u{432}\u{438}\u{434}\u{435}\u{43D} \u{446}\u{432}\u{435}\u{442})"), Type = "toggle", Default = true},
},
})
skin.orig = {}
skin.hidden = {}
skin.hiddenChar = nil
skin.nextScan = 0
function skin:Scan()
local char = player.Character
if not char then return false end
local added = false
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart"
and not d:FindFirstAncestorOfClass("Accessory")
and not d:FindFirstAncestorOfClass("Tool") then
if not self.orig[d] then
self.orig[d] = {Color = d.Color, Material = d.Material, Transparency = d.Transparency}
added = true
end
end
end
return added
end
function skin:SyncClothes()
local char = player.Character
if not char then return end
if self.Values.HideClothes then
for _, d in ipairs(char:GetChildren()) do
if d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
table.insert(self.hidden, d)
d.Parent = nil
end
end
self.hiddenChar = char
else
self:RestoreClothes()
end
end
function skin:RestoreClothes()
if self.hiddenChar and self.hiddenChar == player.Character and self.hiddenChar.Parent then
for _, d in ipairs(self.hidden) do d.Parent = self.hiddenChar end
end
self.hidden = {}
self.hiddenChar = nil
end
function skin:Tick(full)
local v = self.Values
local color = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
local mat = Enum.Material[v.Material]
for part in pairs(self.orig) do
if part.Parent then
part.Color = color
if full then
part.Material = mat
part.Transparency = v.Transparency
end
end
end
end
function skin:Apply()
self:Scan()
self:SyncClothes()
self:Tick(true)
end
function skin:Update()
local now = os.clock()
local full = false
if now >= self.nextScan then
self.nextScan = now + 1
if self:Scan() then full = true end
if self.Values.HideClothes then self:SyncClothes() end
end
if full or self.Values.Mode ~= "Solid" then self:Tick(full) end
end
function skin:Remove()
for part, o in pairs(self.orig) do
if part.Parent then
part.Color = o.Color
part.Material = o.Material
part.Transparency = o.Transparency
end
end
self.orig = {}
self:RestoreClothes()
end
function skin:Reset()
self.orig = {}
self.hidden = {}
self.hiddenChar = nil
end
local AURA_TEXTURES = {
Sparkles = "rbxasset://textures/particles/sparkles_main.dds",
Fire = "rbxasset://textures/particles/fire_main.dds",
Smoke = "rbxasset://textures/particles/smoke_main.dds",
}
local aura = registerModule({
Name = tr("Particle Aura", "\u{410}\u{443}\u{440}\u{430} \u{447}\u{430}\u{441}\u{442}\u{438}\u{446}"),
Desc = tr("Pretty particles around your character", "\u{41A}\u{440}\u{430}\u{441}\u{438}\u{432}\u{44B}\u{435} \u{447}\u{430}\u{441}\u{442}\u{438}\u{446}\u{44B} \u{432}\u{43E}\u{43A}\u{440}\u{443}\u{433} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430}"),
Category = "Visuals",
Settings = {
{Key = "Mode", Label = LBL_MODE, Type = "segmented", Options = MODE_OPTIONS, Default = "Rainbow"},
{Key = "Color1", Label = LBL_C1, Type = "color", Default = Color3.fromRGB(100, 200, 255), ShowIf = showC1},
{Key = "Color2", Label = LBL_C2, Type = "color", Default = Color3.fromRGB(255, 120, 255), ShowIf = showC2},
{Key = "Style", Label = tr("Particle style", "\u{421}\u{442}\u{438}\u{43B}\u{44C} \u{447}\u{430}\u{441}\u{442}\u{438}\u{446}"), Type = "segmented", Default = "Sparkles",
Options = {{"Sparkles", tr("Sparkles", "\u{418}\u{441}\u{43A}\u{440}\u{44B}")}, {"Fire", tr("Fire", "\u{41E}\u{433}\u{43E}\u{43D}\u{44C}")}, {"Smoke", tr("Smoke", "\u{414}\u{44B}\u{43C}")}}},
{Key = "Rate", Label = tr("Amount", "\u{41A}\u{43E}\u{43B}\u{438}\u{447}\u{435}\u{441}\u{442}\u{432}\u{43E}"), Type = "slider", Min = 5, Max = 100, Step = 1, Default = 30},
{Key = "Size", Label = tr("Size", "\u{420}\u{430}\u{437}\u{43C}\u{435}\u{440}"), Type = "slider", Min = 0.2, Max = 3, Step = 0.1, Default = 1},
{Key = "Speed", Label = tr("Speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 0, Max = 10, Step = 0.5, Default = 2},
{Key = "Glow", Label = tr("Glow", "\u{421}\u{432}\u{435}\u{447}\u{435}\u{43D}\u{438}\u{435}"), Type = "slider", Min = 0, Max = 1, Step = 0.05, Default = 0.7},
},
})
function aura:Apply()
local root = getRoot()
if not root then return end
local e = self.emitter
if not e or e.Parent ~= root then
if e then e:Destroy() end
e = new("ParticleEmitter", {Name = "GZ_Aura"}, root)
self.emitter = e
end
local v = self.Values
e.Texture = AURA_TEXTURES[v.Style]
e.Color = makeSequence(v.Mode, v.Color1, v.Color2)
e.Rate = v.Rate
e.Lifetime = NumberRange.new(0.8, 1.6)
e.Speed = NumberRange.new(v.Speed * 0.5, v.Speed)
e.SpreadAngle = Vector2.new(180, 180)
e.Acceleration = Vector3.new(0, 2, 0)
e.Rotation = NumberRange.new(0, 360)
e.RotSpeed = NumberRange.new(-80, 80)
e.LightEmission = v.Glow
e.Size = NumberSequence.new({kp(0, 0), kp(0.25, v.Size), kp(1, 0)})
e.Transparency = NumberSequence.new({kp(0, 1), kp(0.2, 0.15), kp(1, 1)})
e.Enabled = true
end
function aura:Remove()
if self.emitter then self.emitter:Destroy() end
self.emitter = nil
end
local trail = registerModule({
Name = tr("Trail", "\u{421}\u{43B}\u{435}\u{434}"),
Desc = tr("Glowing trail behind your character", "\u{421}\u{432}\u{435}\u{442}\u{44F}\u{449}\u{438}\u{439}\u{441}\u{44F} \u{441}\u{43B}\u{435}\u{434} \u{437}\u{430} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{435}\u{43C}"),
Category = "Visuals",
Settings = {
{Key = "Mode", Label = LBL_MODE, Type = "segmented", Options = MODE_OPTIONS, Default = "Dual"},
{Key = "Color1", Label = LBL_C1, Type = "color", Default = Color3.fromRGB(160, 100, 255), ShowIf = showC1},
{Key = "Color2", Label = LBL_C2, Type = "color", Default = Color3.fromRGB(255, 80, 180), ShowIf = showC2},
{Key = "Lifetime", Label = tr("Trail length (sec)", "\u{414}\u{43B}\u{438}\u{43D}\u{430} \u{441}\u{43B}\u{435}\u{434}\u{430} (\u{441}\u{435}\u{43A})"), Type = "slider", Min = 0.2, Max = 2, Step = 0.1, Default = 0.6},
{Key = "Width", Label = tr("Width", "\u{428}\u{438}\u{440}\u{438}\u{43D}\u{430}"), Type = "slider", Min = 0.3, Max = 2, Step = 0.1, Default = 1},
{Key = "Glow", Label = tr("Glow", "\u{421}\u{432}\u{435}\u{447}\u{435}\u{43D}\u{438}\u{435}"), Type = "slider", Min = 0, Max = 1, Step = 0.05, Default = 0.6},
},
})
function trail:Apply()
local root = getRoot()
if not root then return end
local t = self.trail
if not t or t.Parent ~= root then
self:Remove()
local a0 = new("Attachment", {Name = "GZ_TrailA0", Position = Vector3.new(0, 1, 0)}, root)
local a1 = new("Attachment", {Name = "GZ_TrailA1", Position = Vector3.new(0, -1, 0)}, root)
t = new("Trail", {Name = "GZ_Trail", Attachment0 = a0, Attachment1 = a1, FaceCamera = true, MinLength = 0.05}, root)
self.trail, self.a0, self.a1 = t, a0, a1
end
local v = self.Values
t.Color = makeSequence(v.Mode, v.Color1, v.Color2)
t.Lifetime = v.Lifetime
t.LightEmission = v.Glow
t.WidthScale = NumberSequence.new({kp(0, v.Width), kp(1, 0)})
t.Transparency = NumberSequence.new({kp(0, 0.1), kp(1, 1)})
t.Enabled = true
end
function trail:Remove()
if self.trail then self.trail:Destroy() end
if self.a0 then self.a0:Destroy() end
if self.a1 then self.a1:Destroy() end
self.trail, self.a0, self.a1 = nil, nil, nil
end
local glow = registerModule({
Name = tr("Character Glow", "\u{421}\u{432}\u{435}\u{447}\u{435}\u{43D}\u{438}\u{435} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430}"),
Desc = tr("Glowing outline and fill around you", "\u{421}\u{432}\u{435}\u{442}\u{44F}\u{449}\u{438}\u{439}\u{441}\u{44F} \u{43A}\u{43E}\u{43D}\u{442}\u{443}\u{440} \u{438} \u{437}\u{430}\u{43B}\u{438}\u{432}\u{43A}\u{430} \u{432}\u{43E}\u{43A}\u{440}\u{443}\u{433} \u{442}\u{435}\u{431}\u{44F}"),
Category = "Visuals",
Settings = withSettings(colorSet("Rainbow", PURPLE, PINK), {
{Key = "Fill", Label = tr("Fill transparency", "\u{41F}\u{440}\u{43E}\u{437}\u{440}\u{430}\u{447}\u{43D}\u{43E}\u{441}\u{442}\u{44C} \u{437}\u{430}\u{43B}\u{438}\u{432}\u{43A}\u{438}"), Type = "slider", Min = 0, Max = 1, Step = 0.05, Default = 0.6},
}),
})
function glow:Update()
local h = self.hl
if not h then return end
local v = self.Values
local c = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
h.FillColor = c
h.OutlineColor = c
end
function glow:Apply()
local char = player.Character
if not char then return end
local h = self.hl
if not h or h.Parent ~= char then
if h then h:Destroy() end
h = new("Highlight", {
Name = "GZ_Glow",
Adornee = char,
DepthMode = Enum.HighlightDepthMode.Occluded,
OutlineTransparency = 0,
}, char)
self.hl = h
end
h.FillTransparency = self.Values.Fill
self:Update()
end
function glow:Remove()
if self.hl then self.hl:Destroy() end
self.hl = nil
end
local esp = registerModule({
Name = tr("Player ESP", "ESP \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{43E}\u{432}"),
Desc = tr("Highlights other players through walls, with names and distance", "\u{41F}\u{43E}\u{434}\u{441}\u{432}\u{435}\u{447}\u{438}\u{432}\u{430}\u{435}\u{442} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{43E}\u{432} \u{441}\u{43A}\u{432}\u{43E}\u{437}\u{44C} \u{441}\u{442}\u{435}\u{43D}\u{44B}, \u{441} \u{438}\u{43C}\u{435}\u{43D}\u{430}\u{43C}\u{438} \u{438} \u{434}\u{438}\u{441}\u{442}\u{430}\u{43D}\u{446}\u{438}\u{435}\u{439}"),
Category = "Visuals",
Settings = withSettings(colorSet("Solid", Color3.fromRGB(255, 90, 90), PINK), {
{Key = "Fill", Label = tr("Fill transparency", "\u{41F}\u{440}\u{43E}\u{437}\u{440}\u{430}\u{447}\u{43D}\u{43E}\u{441}\u{442}\u{44C} \u{437}\u{430}\u{43B}\u{438}\u{432}\u{43A}\u{438}"), Type = "slider", Min = 0, Max = 1, Step = 0.05, Default = 0.7},
{Key = "Names", Label = tr("Show names", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{438}\u{43C}\u{435}\u{43D}\u{430}"), Type = "toggle", Default = true},
{Key = "Distance", Label = tr("Show distance", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{434}\u{438}\u{441}\u{442}\u{430}\u{43D}\u{446}\u{438}\u{44E}"), Type = "toggle", Default = true},
}),
})
esp.items = {}
function esp:Clear(p)
local it = self.items[p]
if it then
if it.hl then it.hl:Destroy() end
if it.bb then it.bb:Destroy() end
self.items[p] = nil
end
end
function esp:Make(p, char)
local hl = new("Highlight", {
Name = "GZ_ESP",
Adornee = char,
DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
}, char)
local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
local bb, lbl
if head then
bb = new("BillboardGui", {
Name = "GZ_ESPName",
Adornee = head,
AlwaysOnTop = true,
Size = UDim2.fromOffset(160, 34),
StudsOffset = Vector3.new(0, 2.6, 0),
}, char)
lbl = textLabel(bb, {
Size = UDim2.fromScale(1, 1),
Font = Enum.Font.GothamBold,
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Center,
TextStrokeTransparency = 0.4,
})
end
self.items[p] = {char = char, hl = hl, bb = bb, lbl = lbl}
end
function esp:Update()
local v = self.Values
local color = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
local myRoot = getRoot()
local seen = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player then
seen[p] = true
local char = p.Character
local it = self.items[p]
if char and char.Parent then
if it and it.char ~= char then
self:Clear(p)
it = nil
end
if not it then
self:Make(p, char)
it = self.items[p]
end
it.hl.FillColor = color
it.hl.OutlineColor = color
it.hl.FillTransparency = v.Fill
if it.bb then
it.bb.Enabled = v.Names or v.Distance
local txt = ""
if v.Names then txt = p.DisplayName end
if v.Distance and myRoot then
local r = char:FindFirstChild("HumanoidRootPart")
if r then
local d = math.floor((r.Position - myRoot.Position).Magnitude)
txt = txt .. (txt ~= "" and "\n" or "") .. d .. " m"
end
end
it.lbl.Text = txt
it.lbl.TextColor3 = color
end
elseif it then
self:Clear(p)
end
end
end
for p in pairs(self.items) do
if not seen[p] then self:Clear(p) end
end
end
function esp:Apply() self:Update() end
function esp:Remove()
for p in pairs(self.items) do self:Clear(p) end
end
local orbs = registerModule({
Name = tr("Orbiting Orbs", "\u{41E}\u{440}\u{431}\u{438}\u{442}\u{44B}"),
Desc = tr("Glowing orbs circling around you", "\u{421}\u{432}\u{435}\u{442}\u{44F}\u{449}\u{438}\u{435}\u{441}\u{44F} \u{448}\u{430}\u{440}\u{44B}, \u{43B}\u{435}\u{442}\u{430}\u{44E}\u{449}\u{438}\u{435} \u{432}\u{43E}\u{43A}\u{440}\u{443}\u{433} \u{442}\u{435}\u{431}\u{44F}"),
Category = "Visuals",
Settings = withSettings(colorSet("Rainbow", PURPLE, PINK), {
{Key = "Count", Label = tr("Orb count", "\u{41A}\u{43E}\u{43B}\u{438}\u{447}\u{435}\u{441}\u{442}\u{432}\u{43E} \u{448}\u{430}\u{440}\u{43E}\u{432}"), Type = "slider", Min = 1, Max = 12, Step = 1, Default = 5},
{Key = "Radius", Label = tr("Radius", "\u{420}\u{430}\u{434}\u{438}\u{443}\u{441}"), Type = "slider", Min = 2, Max = 10, Step = 0.5, Default = 4},
{Key = "OrbSpeed", Label = tr("Orbit speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{432}\u{440}\u{430}\u{449}\u{435}\u{43D}\u{438}\u{44F}"), Type = "slider", Min = 0.5, Max = 8, Step = 0.5, Default = 2},
{Key = "Size", Label = tr("Orb size", "\u{420}\u{430}\u{437}\u{43C}\u{435}\u{440} \u{448}\u{430}\u{440}\u{43E}\u{432}"), Type = "slider", Min = 0.3, Max = 2, Step = 0.1, Default = 0.7},
}),
})
orbs.parts = {}
orbs.folder = nil
function orbs:Wipe()
if self.folder then self.folder:Destroy() end
self.folder = nil
self.parts = {}
end
function orbs:Apply()
self:Wipe()
local v = self.Values
self.folder = new("Folder", {Name = "GZ_Orbs"}, workspace)
for _ = 1, v.Count do
local p = new("Part", {
Shape = Enum.PartType.Ball,
Size = Vector3.new(v.Size, v.Size, v.Size),
Anchored = true,
CanCollide = false,
CanQuery = false,
CanTouch = false,
CastShadow = false,
Material = Enum.Material.Neon,
Locked = true,
}, self.folder)
table.insert(self.parts, p)
end
end
function orbs:Update()
local root = getRoot()
if not root then return end
local v = self.Values
local n = #self.parts
local t = os.clock()
for i, p in ipairs(self.parts) do
if p.Parent then
local ang = t * v.OrbSpeed + (i / n) * math.pi * 2
local y = math.sin(t * 1.3 + i) * 0.8
p.Position = root.Position + Vector3.new(math.cos(ang) * v.Radius, y, math.sin(ang) * v.Radius)
p.Color = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, t + i * 0.7)
end
end
end
function orbs:Remove() self:Wipe() end
local charLight = registerModule({
Name = tr("Character Light", "\u{421}\u{432}\u{435}\u{442} \u{43E}\u{442} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430}"),
Desc = tr("A glowing light that follows you", "\u{421}\u{432}\u{435}\u{442}\u{44F}\u{449}\u{438}\u{439}\u{441}\u{44F} \u{438}\u{441}\u{442}\u{43E}\u{447}\u{43D}\u{438}\u{43A} \u{441}\u{432}\u{435}\u{442}\u{430}, \u{43A}\u{43E}\u{442}\u{43E}\u{440}\u{44B}\u{439} \u{441}\u{43B}\u{435}\u{434}\u{443}\u{435}\u{442} \u{437}\u{430} \u{442}\u{43E}\u{431}\u{43E}\u{439}"),
Category = "Visuals",
Settings = withSettings(colorSet("Solid", Color3.fromRGB(255, 240, 200), PINK), {
{Key = "Range", Label = tr("Range", "\u{414}\u{430}\u{43B}\u{44C}\u{43D}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 8, Max = 60, Step = 1, Default = 24},
{Key = "Brightness", Label = tr("Brightness", "\u{42F}\u{440}\u{43A}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 0.5, Max = 10, Step = 0.5, Default = 3},
}),
})
function charLight:Apply()
local root = getRoot()
if not root then return end
local l = self.light
if not l or l.Parent ~= root then
if l then l:Destroy() end
l = new("PointLight", {Name = "GZ_Light", Shadows = false}, root)
self.light = l
end
l.Range = self.Values.Range
l.Brightness = self.Values.Brightness
self:Update()
end
function charLight:Update()
local l = self.light
if not l then return end
local v = self.Values
l.Color = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
end
function charLight:Remove()
if self.light then self.light:Destroy() end
self.light = nil
end
local fov = registerModule({
Name = tr("FOV Changer", "\u{423}\u{433}\u{43E}\u{43B} \u{43E}\u{431}\u{437}\u{43E}\u{440}\u{430}"),
Desc = tr("Changes camera field of view", "\u{41C}\u{435}\u{43D}\u{44F}\u{435}\u{442} \u{443}\u{433}\u{43E}\u{43B} \u{43E}\u{431}\u{437}\u{43E}\u{440}\u{430} \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{44B}"),
Category = "Visuals",
Settings = {
{Key = "FOV", Label = tr("Field of view", "\u{423}\u{433}\u{43E}\u{43B} \u{43E}\u{431}\u{437}\u{43E}\u{440}\u{430}"), Type = "slider", Min = 40, Max = 120, Step = 1, Default = 90},
},
})
function fov:Apply()
local cam = workspace.CurrentCamera
if not cam then return end
if not self.orig then self.orig = cam.FieldOfView end
cam.FieldOfView = self.Values.FOV
end
function fov:Update()
local cam = workspace.CurrentCamera
if cam then cam.FieldOfView = self.Values.FOV end
end
function fov:Remove()
local cam = workspace.CurrentCamera
if cam then cam.FieldOfView = self.orig or 70 end
self.orig = nil
end
local zoom = registerModule({
Name = tr("Camera Zoom", "\u{417}\u{443}\u{43C} \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{44B}"),
Desc = tr("Lets you zoom the camera out much farther", "\u{41F}\u{43E}\u{437}\u{432}\u{43E}\u{43B}\u{44F}\u{435}\u{442} \u{43E}\u{442}\u{434}\u{430}\u{43B}\u{44F}\u{442}\u{44C} \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{443} \u{433}\u{43E}\u{440}\u{430}\u{437}\u{434}\u{43E} \u{434}\u{430}\u{43B}\u{44C}\u{448}\u{435}"),
Category = "Visuals",
Settings = {
{Key = "Max", Label = tr("Max zoom distance", "\u{41C}\u{430}\u{43A}\u{441}. \u{434}\u{438}\u{441}\u{442}\u{430}\u{43D}\u{446}\u{438}\u{44F} \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{44B}"), Type = "slider", Min = 30, Max = 2000, Step = 10, Default = 400},
},
})
function zoom:Apply()
if not self.orig then self.orig = player.CameraMaxZoomDistance end
player.CameraMaxZoomDistance = self.Values.Max
end
function zoom:Remove()
player.CameraMaxZoomDistance = self.orig or 128
self.orig = nil
end
local timeMod = registerModule({
Name = tr("Time Changer", "\u{412}\u{440}\u{435}\u{43C}\u{44F} \u{441}\u{443}\u{442}\u{43E}\u{43A}"),
Desc = tr("Changes time of day (only on your screen)", "\u{41C}\u{435}\u{43D}\u{44F}\u{435}\u{442} \u{432}\u{440}\u{435}\u{43C}\u{44F} \u{441}\u{443}\u{442}\u{43E}\u{43A} (\u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Time", Label = tr("Time (hours)", "\u{412}\u{440}\u{435}\u{43C}\u{44F} (\u{447}\u{430}\u{441}\u{44B})"), Type = "slider", Min = 0, Max = 24, Step = 0.25, Default = 12},
},
})
function timeMod:Apply()
if self.orig == nil then self.orig = Lighting.ClockTime end
Lighting.ClockTime = self.Values.Time
end
function timeMod:Update()
Lighting.ClockTime = self.Values.Time
end
function timeMod:Remove()
if self.orig ~= nil then Lighting.ClockTime = self.orig end
self.orig = nil
end
local cycle = registerModule({
Name = tr("Day/Night Cycle", "\u{421}\u{43C}\u{435}\u{43D}\u{430} \u{434}\u{43D}\u{44F} \u{438} \u{43D}\u{43E}\u{447}\u{438}"),
Desc = tr("Fast looping day and night (only on your screen)", "\u{411}\u{44B}\u{441}\u{442}\u{440}\u{430}\u{44F} \u{441}\u{43C}\u{435}\u{43D}\u{430} \u{434}\u{43D}\u{44F} \u{438} \u{43D}\u{43E}\u{447}\u{438} (\u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = {
{Key = "Speed", Label = tr("Hours per second", "\u{427}\u{430}\u{441}\u{43E}\u{432} \u{432} \u{441}\u{435}\u{43A}\u{443}\u{43D}\u{434}\u{443}"), Type = "slider", Min = 0.1, Max = 6, Step = 0.1, Default = 1},
},
})
cycle.t = 12
function cycle:Apply()
if self.orig == nil then self.orig = Lighting.ClockTime end
self.t = Lighting.ClockTime
end
function cycle:Update(dt)
self.t = (self.t + dt * self.Values.Speed) % 24
Lighting.ClockTime = self.t
end
function cycle:Remove()
if self.orig ~= nil then Lighting.ClockTime = self.orig end
self.orig = nil
end
local fullbright = registerModule({
Name = tr("Full Bright", "\u{41F}\u{43E}\u{43B}\u{43D}\u{430}\u{44F} \u{44F}\u{440}\u{43A}\u{43E}\u{441}\u{442}\u{44C}"),
Desc = tr("Removes darkness and shadows", "\u{423}\u{431}\u{438}\u{440}\u{430}\u{435}\u{442} \u{442}\u{435}\u{43C}\u{43D}\u{43E}\u{442}\u{443} \u{438} \u{442}\u{435}\u{43D}\u{438}"),
Category = "Visuals",
Settings = {
{Key = "Level", Label = tr("Brightness", "\u{42F}\u{440}\u{43A}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 0.5, Max = 3, Step = 0.1, Default = 1.5},
},
})
function fullbright:Update()
local lvl = self.Values.Level
local a = math.clamp(lvl * 0.5, 0, 1)
Lighting.Brightness = lvl
Lighting.Ambient = Color3.new(a, a, a)
Lighting.OutdoorAmbient = Color3.new(a, a, a)
Lighting.GlobalShadows = false
end
function fullbright:Apply()
if not self.orig then
self.orig = {
Brightness = Lighting.Brightness,
Ambient = Lighting.Ambient,
OutdoorAmbient = Lighting.OutdoorAmbient,
GlobalShadows = Lighting.GlobalShadows,
}
end
self:Update()
end
function fullbright:Remove()
local o = self.orig
if o then
Lighting.Brightness = o.Brightness
Lighting.Ambient = o.Ambient
Lighting.OutdoorAmbient = o.OutdoorAmbient
Lighting.GlobalShadows = o.GlobalShadows
end
self.orig = nil
end
local world = registerModule({
Name = tr("World Colors", "\u{426}\u{432}\u{435}\u{442}\u{430} \u{43C}\u{438}\u{440}\u{430}"),
Desc = tr("Tints the world's ambient light: solid, rainbow or gradient", "\u{41E}\u{43A}\u{440}\u{430}\u{448}\u{438}\u{432}\u{430}\u{435}\u{442} \u{43E}\u{441}\u{432}\u{435}\u{449}\u{435}\u{43D}\u{438}\u{435} \u{43C}\u{438}\u{440}\u{430}: \u{446}\u{432}\u{435}\u{442}, \u{440}\u{430}\u{434}\u{443}\u{433}\u{430} \u{438}\u{43B}\u{438} \u{433}\u{440}\u{430}\u{434}\u{438}\u{435}\u{43D}\u{442}"),
Category = "Visuals",
Settings = colorSet("Rainbow", PURPLE, PINK),
})
function world:Update()
local v = self.Values
local c = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
Lighting.Ambient = c
Lighting.OutdoorAmbient = c
end
function world:Apply()
if not self.orig then
self.orig = {Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
end
self:Update()
end
function world:Remove()
local o = self.orig
if o then
Lighting.Ambient = o.Ambient
Lighting.OutdoorAmbient = o.OutdoorAmbient
end
self.orig = nil
end
local fog = registerModule({
Name = tr("Fog", "\u{422}\u{443}\u{43C}\u{430}\u{43D}"),
Desc = tr("Adds colored fog (only on your screen)", "\u{414}\u{43E}\u{431}\u{430}\u{432}\u{43B}\u{44F}\u{435}\u{442} \u{446}\u{432}\u{435}\u{442}\u{43D}\u{43E}\u{439} \u{442}\u{443}\u{43C}\u{430}\u{43D} (\u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Visuals",
Settings = withSettings(colorSet("Solid", Color3.fromRGB(120, 90, 200), PINK), {
{Key = "Start", Label = tr("Fog start", "\u{41D}\u{430}\u{447}\u{430}\u{43B}\u{43E} \u{442}\u{443}\u{43C}\u{430}\u{43D}\u{430}"), Type = "slider", Min = 0, Max = 500, Step = 10, Default = 0},
{Key = "End", Label = tr("Fog end", "\u{41A}\u{43E}\u{43D}\u{435}\u{446} \u{442}\u{443}\u{43C}\u{430}\u{43D}\u{430}"), Type = "slider", Min = 50, Max = 2000, Step = 10, Default = 300},
}),
})
function fog:Update()
local v = self.Values
Lighting.FogStart = v.Start
Lighting.FogEnd = math.max(v.End, v.Start + 1)
Lighting.FogColor = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
end
function fog:Apply()
if not self.orig then
self.orig = {FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor}
end
self:Update()
end
function fog:Remove()
local o = self.orig
if o then
Lighting.FogStart = o.FogStart
Lighting.FogEnd = o.FogEnd
Lighting.FogColor = o.FogColor
end
self.orig = nil
end
local cc = registerModule({
Name = tr("Color Filter", "\u{426}\u{432}\u{435}\u{442}\u{43E}\u{43A}\u{43E}\u{440}\u{440}\u{435}\u{43A}\u{446}\u{438}\u{44F}"),
Desc = tr("Saturation, contrast, brightness and tint of the whole screen", "\u{41D}\u{430}\u{441}\u{44B}\u{449}\u{435}\u{43D}\u{43D}\u{43E}\u{441}\u{442}\u{44C}, \u{43A}\u{43E}\u{43D}\u{442}\u{440}\u{430}\u{441}\u{442}, \u{44F}\u{440}\u{43A}\u{43E}\u{441}\u{442}\u{44C} \u{438} \u{43E}\u{442}\u{442}\u{435}\u{43D}\u{43E}\u{43A} \u{432}\u{441}\u{435}\u{433}\u{43E} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{430}"),
Category = "Visuals",
Settings = {
{Key = "Saturation", Label = tr("Saturation", "\u{41D}\u{430}\u{441}\u{44B}\u{449}\u{435}\u{43D}\u{43D}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = -1, Max = 2, Step = 0.05, Default = 0.4},
{Key = "Contrast", Label = tr("Contrast", "\u{41A}\u{43E}\u{43D}\u{442}\u{440}\u{430}\u{441}\u{442}"), Type = "slider", Min = -0.5, Max = 1, Step = 0.05, Default = 0.15},
{Key = "Brightness", Label = tr("Brightness", "\u{42F}\u{440}\u{43A}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = -0.3, Max = 0.3, Step = 0.02, Default = 0},
{Key = "Tint", Label = tr("Tint", "\u{41E}\u{442}\u{442}\u{435}\u{43D}\u{43E}\u{43A}"), Type = "color", Default = WHITE},
},
})
function cc:Apply()
local e = self.fx
if not e or e.Parent ~= Lighting then
if e then e:Destroy() end
e = new("ColorCorrectionEffect", {Name = "GZ_ColorFilter"}, Lighting)
self.fx = e
end
local v = self.Values
e.Saturation = v.Saturation
e.Contrast = v.Contrast
e.Brightness = v.Brightness
e.TintColor = v.Tint
end
function cc:Remove()
if self.fx then self.fx:Destroy() end
self.fx = nil
end
local bloom = registerModule({
Name = tr("Bloom", "\u{421}\u{432}\u{435}\u{447}\u{435}\u{43D}\u{438}\u{435} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{430}"),
Desc = tr("Soft glow around bright objects", "\u{41C}\u{44F}\u{433}\u{43A}\u{43E}\u{435} \u{441}\u{432}\u{435}\u{447}\u{435}\u{43D}\u{438}\u{435} \u{432}\u{43E}\u{43A}\u{440}\u{443}\u{433} \u{44F}\u{440}\u{43A}\u{438}\u{445} \u{43E}\u{431}\u{44A}\u{435}\u{43A}\u{442}\u{43E}\u{432}"),
Category = "Visuals",
Settings = {
{Key = "Intensity", Label = tr("Intensity", "\u{418}\u{43D}\u{442}\u{435}\u{43D}\u{441}\u{438}\u{432}\u{43D}\u{43E}\u{441}\u{442}\u{44C}"), Type = "slider", Min = 0, Max = 3, Step = 0.1, Default = 1},
{Key = "Size", Label = tr("Size", "\u{420}\u{430}\u{437}\u{43C}\u{435}\u{440}"), Type = "slider", Min = 0, Max = 56, Step = 1, Default = 24},
{Key = "Threshold", Label = tr("Threshold", "\u{41F}\u{43E}\u{440}\u{43E}\u{433}"), Type = "slider", Min = 0, Max = 4, Step = 0.1, Default = 1},
},
})
function bloom:Apply()
local e = self.fx
if not e or e.Parent ~= Lighting then
if e then e:Destroy() end
e = new("BloomEffect", {Name = "GZ_Bloom"}, Lighting)
self.fx = e
end
local v = self.Values
e.Intensity = v.Intensity
e.Size = v.Size
e.Threshold = v.Threshold
end
function bloom:Remove()
if self.fx then self.fx:Destroy() end
self.fx = nil
end
local cross = registerModule({
Name = tr("Crosshair", "\u{41F}\u{440}\u{438}\u{446}\u{435}\u{43B}"),
Desc = tr("Custom crosshair in the center of the screen", "\u{421}\u{432}\u{43E}\u{439} \u{43F}\u{440}\u{438}\u{446}\u{435}\u{43B} \u{432} \u{446}\u{435}\u{43D}\u{442}\u{440}\u{435} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{430}"),
Category = "Combat",
Settings = withSettings(colorSet("Dual", PURPLE, PINK), {
{Key = "Size", Label = tr("Line length", "\u{414}\u{43B}\u{438}\u{43D}\u{430} \u{43B}\u{438}\u{43D}\u{438}\u{439}"), Type = "slider", Min = 3, Max = 40, Step = 1, Default = 12},
{Key = "Thickness", Label = tr("Thickness", "\u{422}\u{43E}\u{43B}\u{449}\u{438}\u{43D}\u{430}"), Type = "slider", Min = 1, Max = 6, Step = 1, Default = 2},
{Key = "Gap", Label = tr("Gap", "\u{41E}\u{442}\u{441}\u{442}\u{443}\u{43F} \u{43E}\u{442} \u{446}\u{435}\u{43D}\u{442}\u{440}\u{430}"), Type = "slider", Min = 0, Max = 24, Step = 1, Default = 5},
{Key = "Dot", Label = tr("Center dot", "\u{422}\u{43E}\u{447}\u{43A}\u{430} \u{432} \u{446}\u{435}\u{43D}\u{442}\u{440}\u{435}"), Type = "toggle", Default = true},
}),
})
cross.bars = {}
function cross:Wipe()
if self.root then self.root:Destroy() end
self.root = nil
self.bars = {}
end
function cross:Apply()
self:Wipe()
local v = self.Values
local root = new("Frame", {
Name = "GZ_Crosshair",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(0, 0),
BackgroundTransparency = 1,
ZIndex = 1,
}, screenGui)
local th, len, gap = v.Thickness, v.Size, v.Gap
local half = math.floor(th / 2)
local function bar(x, y, w, h)
local f = new("Frame", {
Position = UDim2.fromOffset(x, y),
Size = UDim2.fromOffset(w, h),
BackgroundColor3 = WHITE,
ZIndex = 1,
}, root)
table.insert(self.bars, f)
end
bar(-half, -(gap + len), th, len)
bar(-half, gap, th, len)
bar(-(gap + len), -half, len, th)
bar(gap, -half, len, th)
if v.Dot then bar(-half, -half, th, th) end
self.root = root
self:Update()
end
function cross:Update()
local v = self.Values
local c = computeColor(v.Mode, v.Color1, v.Color2, v.Speed, os.clock())
for _, f in ipairs(self.bars) do f.BackgroundColor3 = c end
end
function cross:Remove() self:Wipe() end
local targetInfo = registerModule({
Name = tr("Target Info", "\u{418}\u{43D}\u{444}\u{43E} \u{43E} \u{446}\u{435}\u{43B}\u{438}"),
Desc = tr("Panel with the nearest player's name, health and distance", "\u{41F}\u{430}\u{43D}\u{435}\u{43B}\u{44C}: \u{438}\u{43C}\u{44F}, \u{437}\u{434}\u{43E}\u{440}\u{43E}\u{432}\u{44C}\u{435} \u{438} \u{434}\u{438}\u{441}\u{442}\u{430}\u{43D}\u{446}\u{438}\u{44F} \u{431}\u{43B}\u{438}\u{436}\u{430}\u{439}\u{448}\u{435}\u{433}\u{43E} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{430}"),
Category = "Combat",
Settings = {
{Key = "Range", Label = tr("Max distance", "\u{41C}\u{430}\u{43A}\u{441}. \u{434}\u{438}\u{441}\u{442}\u{430}\u{43D}\u{446}\u{438}\u{44F}"), Type = "slider", Min = 20, Max = 500, Step = 10, Default = 150},
},
})
function targetInfo:Wipe()
if self.panel then self.panel:Destroy() end
self.panel, self.nameLbl, self.hpLbl, self.hpFill = nil, nil, nil, nil
end
function targetInfo:Apply()
if self.panel then return end
local p = new("Frame", {
Name = "GZ_Target",
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, 70),
Size = UDim2.fromOffset(220, 58),
BackgroundColor3 = Theme.Sidebar,
ZIndex = 25,
Visible = false,
}, screenGui)
corner(p, 12)
stroke(p, Theme.Accent, 1.3, 0.35)
self.nameLbl = textLabel(p, {
Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 18),
Font = Enum.Font.GothamBold, TextSize = 14,
})
local track = new("Frame", {Position = UDim2.new(0, 12, 0, 30), Size = UDim2.new(1, -24, 0, 8), BackgroundColor3 = Theme.Track}, p)
corner(track, 4)
self.hpFill = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE}, track)
corner(self.hpFill, 4)
new("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2)}, self.hpFill)
self.hpLbl = textLabel(p, {
Position = UDim2.new(0, 12, 0, 40), Size = UDim2.new(1, -24, 0, 14),
TextColor3 = Theme.Sub, TextSize = 11,
})
self.panel = p
end
function targetInfo:Update()
local p = self.panel
if not p then return end
local root = getRoot()
local best, bestD, bestHum
if root then
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= player and pl.Character then
local r = pl.Character:FindFirstChild("HumanoidRootPart")
local h = pl.Character:FindFirstChildOfClass("Humanoid")
if r and h and h.Health > 0 then
local d = (r.Position - root.Position).Magnitude
if d <= self.Values.Range and (not bestD or d < bestD) then
best, bestD, bestHum = pl, d, h
end
end
end
end
end
if best then
p.Visible = true
self.nameLbl.Text = best.DisplayName
local frac = math.clamp(bestHum.Health / math.max(bestHum.MaxHealth, 1), 0, 1)
self.hpFill.Size = UDim2.fromScale(frac, 1)
self.hpLbl.Text = string.format("HP %d / %d   \u{2022}   %d m",
math.floor(bestHum.Health), math.floor(bestHum.MaxHealth), math.floor(bestD))
else
p.Visible = false
end
end
function targetInfo:Remove() self:Wipe() end
local clicker = registerModule({
Name = tr("Auto Clicker", "\u{410}\u{432}\u{442}\u{43E}\u{43A}\u{43B}\u{438}\u{43A}\u{435}\u{440}"),
Desc = tr("Automatically uses the tool in your hand", "\u{410}\u{432}\u{442}\u{43E}\u{43C}\u{430}\u{442}\u{438}\u{447}\u{435}\u{441}\u{43A}\u{438} \u{438}\u{441}\u{43F}\u{43E}\u{43B}\u{44C}\u{437}\u{443}\u{435}\u{442} \u{43F}\u{440}\u{435}\u{434}\u{43C}\u{435}\u{442} \u{432} \u{440}\u{443}\u{43A}\u{435}"),
Category = "Combat",
Settings = {
{Key = "CPS", Label = tr("Clicks per second", "\u{41A}\u{43B}\u{438}\u{43A}\u{43E}\u{432} \u{432} \u{441}\u{435}\u{43A}\u{443}\u{43D}\u{434}\u{443}"), Type = "slider", Min = 1, Max = 30, Step = 1, Default = 10},
{Key = "HoldOnly", Label = tr("Only while holding the mouse button", "\u{422}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{43F}\u{440}\u{438} \u{437}\u{430}\u{436}\u{430}\u{442}\u{43E}\u{439} \u{43A}\u{43D}\u{43E}\u{43F}\u{43A}\u{435} \u{43C}\u{44B}\u{448}\u{438}"), Type = "toggle", Default = false,
ShowIf = function() return platform == "pc" end},
},
})
clicker.acc = 0
function clicker:Apply() self.acc = 0 end
function clicker:Update(dt)
if self.Values.HoldOnly and platform == "pc"
and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
self.acc = 0
return
end
self.acc += dt
local interval = 1 / self.Values.CPS
if self.acc >= interval then
self.acc = self.acc % interval
local char = player.Character
local tool = char and char:FindFirstChildOfClass("Tool")
if tool then tool:Activate() end
end
end
local spin = registerModule({
Name = tr("Spin", "\u{412}\u{440}\u{430}\u{449}\u{435}\u{43D}\u{438}\u{435}"),
Desc = tr("Your character spins around", "\u{422}\u{432}\u{43E}\u{439} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436} \u{43A}\u{440}\u{443}\u{442}\u{438}\u{442}\u{441}\u{44F} \u{432}\u{43E}\u{43A}\u{440}\u{443}\u{433} \u{441}\u{432}\u{43E}\u{435}\u{439} \u{43E}\u{441}\u{438}"),
Category = "Combat",
Settings = {
{Key = "Speed", Label = tr("Spin speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{432}\u{440}\u{430}\u{449}\u{435}\u{43D}\u{438}\u{44F}"), Type = "slider", Min = 1, Max = 60, Step = 1, Default = 15},
},
})
function spin:Apply()
local hum = getHumanoid()
if hum then hum.AutoRotate = false end
end
function spin:Update(dt)
local root = getRoot()
if root then
root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(self.Values.Speed * dt * 60), 0)
end
end
function spin:Remove()
local hum = getHumanoid()
if hum then hum.AutoRotate = true end
end
local fly = registerModule({
Name = tr("Fly", "\u{41F}\u{43E}\u{43B}\u{451}\u{442}"),
Desc = tr("Flight. WASD / stick follows the camera, Space up, Shift down",
"\u{41F}\u{43E}\u{43B}\u{451}\u{442}. WASD / \u{441}\u{442}\u{438}\u{43A} \u{2014} \u{43F}\u{43E} \u{432}\u{437}\u{433}\u{43B}\u{44F}\u{434}\u{443} \u{43A}\u{430}\u{43C}\u{435}\u{440}\u{44B}, Space \u{2014} \u{432}\u{432}\u{435}\u{440}\u{445}, Shift \u{2014} \u{432}\u{43D}\u{438}\u{437}"),
Category = "Movement",
Settings = {
{Key = "Speed", Label = tr("Fly speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{43F}\u{43E}\u{43B}\u{451}\u{442}\u{430}"), Type = "slider", Min = 10, Max = 250, Step = 5, Default = 60},
{Key = "Noclip", Label = tr("Noclip while flying", "Noclip \u{432}\u{43E} \u{432}\u{440}\u{435}\u{43C}\u{44F} \u{43F}\u{43E}\u{43B}\u{451}\u{442}\u{430}"), Type = "toggle", Default = false},
},
})
fly.vel = Vector3.zero
function fly:Cleanup()
if self.lv then self.lv:Destroy() end
if self.ao then self.ao:Destroy() end
if self.att then self.att:Destroy() end
self.lv, self.ao, self.att = nil, nil, nil
local hum = self.hum
if hum and hum.Parent then
hum.PlatformStand = false
hum.AutoRotate = true
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end
self.hum = nil
self.vel = Vector3.zero
end
function fly:Apply()
local root, hum = getRoot(), getHumanoid()
if not root or not hum then return end
if not self.lv or self.lv.Parent ~= root then
self:Cleanup()
self.att = new("Attachment", {Name = "GZ_FlyAtt"}, root)
self.lv = new("LinearVelocity", {
Name = "GZ_FlyLV",
Attachment0 = self.att,
MaxForce = math.huge,
VectorVelocity = Vector3.zero,
RelativeTo = Enum.ActuatorRelativeTo.World,
}, root)
self.ao = new("AlignOrientation", {
Name = "GZ_FlyAO",
Attachment0 = self.att,
Mode = Enum.OrientationAlignmentMode.OneAttachment,
RigidityEnabled = false,
MaxTorque = math.huge,
Responsiveness = 40,
CFrame = root.CFrame.Rotation,
}, root)
self.hum = hum
hum.PlatformStand = true
hum.AutoRotate = false
end
setNoclip("fly", self.Values.Noclip)
end
function fly:Update(dt)
if not self.lv or not self.lv.Parent then return end
local cam = workspace.CurrentCamera
if not cam then return end
local up = 0
if not UserInputService:GetFocusedTextBox() then
local k = UserInputService
if k:IsKeyDown(Enum.KeyCode.Space) or k:IsKeyDown(Enum.KeyCode.E) then up += 1 end
if k:IsKeyDown(Enum.KeyCode.LeftShift) or k:IsKeyDown(Enum.KeyCode.LeftControl) or k:IsKeyDown(Enum.KeyCode.Q) then up -= 1 end
end
if self.hum and self.hum.Jump then up = math.max(up, 1) end
local dir = cam.CFrame:VectorToWorldSpace(getMoveVector()) + Vector3.new(0, up, 0)
if dir.Magnitude > 1 then dir = dir.Unit end
self.vel = self.vel:Lerp(dir * self.Values.Speed, math.clamp(dt * 10, 0, 1))
self.lv.VectorVelocity = self.vel
local look = cam.CFrame.LookVector
local flat = Vector3.new(look.X, 0, look.Z)
if flat.Magnitude > 0.01 then
self.ao.CFrame = CFrame.lookAt(Vector3.zero, flat)
end
end
function fly:Remove()
self:Cleanup()
setNoclip("fly", false)
end
function fly:Reset()
self.lv, self.ao, self.att, self.hum = nil, nil, nil, nil
self.vel = Vector3.zero
end
local noclip = registerModule({
Name = tr("Noclip", "Noclip"),
Desc = tr("Walk through walls and objects", "\u{41F}\u{440}\u{43E}\u{445}\u{43E}\u{434}\u{438} \u{441}\u{43A}\u{432}\u{43E}\u{437}\u{44C} \u{441}\u{442}\u{435}\u{43D}\u{44B} \u{438} \u{43F}\u{440}\u{435}\u{434}\u{43C}\u{435}\u{442}\u{44B}"),
Category = "Movement",
})
function noclip:Apply() setNoclip("noclip", true) end
function noclip:Remove() setNoclip("noclip", false) end
local speed = registerModule({
Name = tr("Speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C}"),
Desc = tr("Run much faster", "\u{411}\u{435}\u{433}\u{430}\u{439} \u{43D}\u{430}\u{43C}\u{43D}\u{43E}\u{433}\u{43E} \u{431}\u{44B}\u{441}\u{442}\u{440}\u{435}\u{435}"),
Category = "Movement",
Settings = {
{Key = "Speed", Label = tr("Walk speed", "\u{421}\u{43A}\u{43E}\u{440}\u{43E}\u{441}\u{442}\u{44C} \u{445}\u{43E}\u{434}\u{44C}\u{431}\u{44B}"), Type = "slider", Min = 16, Max = 250, Step = 2, Default = 50},
},
})
function speed:Apply()
local hum = getHumanoid()
if not hum then return end
if not self.orig then self.orig = hum.WalkSpeed end
hum.WalkSpeed = self.Values.Speed
end
function speed:Update()
local hum = getHumanoid()
if hum and hum.WalkSpeed ~= self.Values.Speed then hum.WalkSpeed = self.Values.Speed end
end
function speed:Remove()
local hum = getHumanoid()
if hum then hum.WalkSpeed = self.orig or 16 end
self.orig = nil
end
function speed:Reset() self.orig = nil end
local jump = registerModule({
Name = tr("High Jump", "\u{412}\u{44B}\u{441}\u{43E}\u{43A}\u{438}\u{439} \u{43F}\u{440}\u{44B}\u{436}\u{43E}\u{43A}"),
Desc = tr("Jump much higher", "\u{41F}\u{440}\u{44B}\u{433}\u{430}\u{439} \u{43D}\u{430}\u{43C}\u{43D}\u{43E}\u{433}\u{43E} \u{432}\u{44B}\u{448}\u{435}"),
Category = "Movement",
Settings = {
{Key = "Power", Label = tr("Jump power", "\u{421}\u{438}\u{43B}\u{430} \u{43F}\u{440}\u{44B}\u{436}\u{43A}\u{430}"), Type = "slider", Min = 50, Max = 400, Step = 5, Default = 120},
},
})
function jump:Apply()
local hum = getHumanoid()
if not hum then return end
if not self.orig then self.orig = {hum.UseJumpPower, hum.JumpPower} end
hum.UseJumpPower = true
hum.JumpPower = self.Values.Power
end
function jump:Update()
local hum = getHumanoid()
if hum and (hum.JumpPower ~= self.Values.Power or not hum.UseJumpPower) then
hum.UseJumpPower = true
hum.JumpPower = self.Values.Power
end
end
function jump:Remove()
local hum = getHumanoid()
local o = self.orig
if hum and o then
hum.UseJumpPower = o[1]
hum.JumpPower = o[2]
end
self.orig = nil
end
function jump:Reset() self.orig = nil end
local infjump = registerModule({
Name = tr("Infinite Jump", "\u{411}\u{435}\u{441}\u{43A}\u{43E}\u{43D}\u{435}\u{447}\u{43D}\u{44B}\u{439} \u{43F}\u{440}\u{44B}\u{436}\u{43E}\u{43A}"),
Desc = tr("Jump again in mid-air as many times as you want", "\u{41F}\u{440}\u{44B}\u{433}\u{430}\u{439} \u{432} \u{432}\u{43E}\u{437}\u{434}\u{443}\u{445}\u{435} \u{441}\u{43A}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{437}\u{430}\u{445}\u{43E}\u{447}\u{435}\u{448}\u{44C}"),
Category = "Movement",
})
function infjump:Apply()
if self.c then return end
self.c = UserInputService.JumpRequest:Connect(function()
local hum = getHumanoid()
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
end
function infjump:Remove()
if self.c then self.c:Disconnect() end
self.c = nil
end
local gravity = registerModule({
Name = tr("Gravity", "\u{413}\u{440}\u{430}\u{432}\u{438}\u{442}\u{430}\u{446}\u{438}\u{44F}"),
Desc = tr("Change gravity: float like on the Moon or fall like a rock", "\u{41C}\u{435}\u{43D}\u{44F}\u{439} \u{433}\u{440}\u{430}\u{432}\u{438}\u{442}\u{430}\u{446}\u{438}\u{44E}: \u{43A}\u{430}\u{43A} \u{43D}\u{430} \u{41B}\u{443}\u{43D}\u{435} \u{438}\u{43B}\u{438} \u{442}\u{44F}\u{436}\u{435}\u{43B}\u{435}\u{435}"),
Category = "Movement",
Settings = {
{Key = "Gravity", Label = tr("Gravity", "\u{413}\u{440}\u{430}\u{432}\u{438}\u{442}\u{430}\u{446}\u{438}\u{44F}"), Type = "slider", Min = 0, Max = 400, Step = 2, Default = 60},
},
})
function gravity:Apply()
if not self.orig then self.orig = workspace.Gravity end
workspace.Gravity = self.Values.Gravity
end
function gravity:Remove()
workspace.Gravity = self.orig or 196.2
self.orig = nil
end
local function tpTo(pos2)
local cam = workspace.CurrentCamera
local root = getRoot()
if not cam or not root then return end
local ray = cam:ScreenPointToRay(pos2.X, pos2.Y)
local params = RaycastParams.new()
params.FilterDescendantsInstances = {player.Character}
params.FilterType = Enum.RaycastFilterType.Exclude
local res = workspace:Raycast(ray.Origin, ray.Direction * 3000, params)
if res then
root.CFrame = CFrame.new(res.Position + Vector3.new(0, 3.5, 0)) * root.CFrame.Rotation
root.AssemblyLinearVelocity = Vector3.zero
end
end
local clicktp = registerModule({
Name = tr("Click Teleport", "\u{422}\u{435}\u{43B}\u{435}\u{43F}\u{43E}\u{440}\u{442} \u{43F}\u{43E} \u{43A}\u{43B}\u{438}\u{43A}\u{443}"),
Desc = tr("PC: Ctrl + click. Phone: tap in the world", "\u{41F}\u{41A}: Ctrl + \u{43A}\u{43B}\u{438}\u{43A}. \u{422}\u{435}\u{43B}\u{435}\u{444}\u{43E}\u{43D}: \u{442}\u{430}\u{43F} \u{43F}\u{43E} \u{43C}\u{438}\u{440}\u{443}"),
Category = "Movement",
})
function clicktp:Apply()
if self.c1 then return end
self.c1 = UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if input.UserInputType == Enum.UserInputType.MouseButton1
and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
tpTo(Vector2.new(input.Position.X, input.Position.Y))
end
end)
self.c2 = UserInputService.TouchTap:Connect(function(positions, processed)
if processed or not positions[1] then return end
tpTo(positions[1])
end)
end
function clicktp:Remove()
if self.c1 then self.c1:Disconnect() end
if self.c2 then self.c2:Disconnect() end
self.c1, self.c2 = nil, nil
end
local fling = registerModule({
Name = tr("Fling", "\u{424}\u{43B}\u{438}\u{43D}\u{433}"),
Desc = tr("Spins you: players you touch get thrown", "\u{420}\u{430}\u{441}\u{43A}\u{440}\u{443}\u{447}\u{438}\u{432}\u{430}\u{435}\u{442} \u{442}\u{435}\u{431}\u{44F}: \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{438}, \u{43A}\u{43E}\u{442}\u{43E}\u{440}\u{44B}\u{445} \u{437}\u{430}\u{434}\u{435}\u{43D}\u{435}\u{448}\u{44C}, \u{43E}\u{442}\u{43B}\u{435}\u{442}\u{430}\u{44E}\u{442}"),
Category = "Movement",
Settings = {
{Key = "Power", Label = tr("Spin power", "\u{421}\u{438}\u{43B}\u{430} \u{432}\u{440}\u{430}\u{449}\u{435}\u{43D}\u{438}\u{44F}"), Type = "slider", Min = 1000, Max = 30000, Step = 1000, Default = 10000},
{Key = "Heavy", Label = tr("Make character heavy (harder hits)", "\u{423}\u{442}\u{44F}\u{436}\u{435}\u{43B}\u{438}\u{442}\u{44C} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430} (\u{443}\u{434}\u{430}\u{440} \u{441}\u{438}\u{43B}\u{44C}\u{43D}\u{435}\u{435})"), Type = "toggle", Default = true},
},
})
fling.props = {}
function fling:SyncHeavy()
local char = player.Character
if not char then return end
if self.Values.Heavy then
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("BasePart") and not self.props[d] then
self.props[d] = {orig = d.CustomPhysicalProperties}
d.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0, 1, 1)
end
end
else
self:RestoreHeavy()
end
end
function fling:RestoreHeavy()
for part, o in pairs(self.props) do
if part.Parent then part.CustomPhysicalProperties = o.orig end
end
self.props = {}
end
function fling:Apply()
self:SyncHeavy()
if self.c1 then return end
self.c1 = RunService.Stepped:Connect(function()
local root = getRoot()
if root then root.AssemblyAngularVelocity = Vector3.new(0, self.Values.Power, 0) end
end)
self.c2 = RunService.RenderStepped:Connect(function()
local root = getRoot()
if root then root.AssemblyAngularVelocity = Vector3.zero end
end)
end
function fling:Remove()
if self.c1 then self.c1:Disconnect() end
if self.c2 then self.c2:Disconnect() end
self.c1, self.c2 = nil, nil
self:RestoreHeavy()
local root = getRoot()
if root then root.AssemblyAngularVelocity = Vector3.zero end
end
function fling:Reset()
self.props = {}
end
local antiFling = registerModule({
Name = tr("Anti-Fling", "\u{410}\u{43D}\u{442}\u{438}-\u{444}\u{43B}\u{438}\u{43D}\u{433}"),
Desc = tr("Other players can't push or fling you (their collisions are off for you)", "\u{414}\u{440}\u{443}\u{433}\u{438}\u{435} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{438} \u{43D}\u{435} \u{441}\u{43C}\u{43E}\u{433}\u{443}\u{442} \u{442}\u{43E}\u{43B}\u{43A}\u{43D}\u{443}\u{442}\u{44C} \u{438}\u{43B}\u{438} \u{437}\u{430}\u{444}\u{43B}\u{438}\u{43D}\u{433}\u{430}\u{442}\u{44C} \u{442}\u{435}\u{431}\u{44F}"),
Category = "Movement",
})
antiFling.changed = {}
function antiFling:Tick()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= player and pl.Character then
for _, d in ipairs(pl.Character:GetDescendants()) do
if d:IsA("BasePart") and d.CanCollide then
self.changed[d] = true
d.CanCollide = false
end
end
end
end
end
function antiFling:Apply()
if self.c then return end
self.c = RunService.Stepped:Connect(function() self:Tick() end)
end
function antiFling:Remove()
if self.c then self.c:Disconnect() end
self.c = nil
for part in pairs(self.changed) do
if part.Parent then part.CanCollide = true end
end
self.changed = {}
end
local invis = registerModule({
Name = tr("Invisibility", "\u{41D}\u{435}\u{432}\u{438}\u{434}\u{438}\u{43C}\u{43E}\u{441}\u{442}\u{44C}"),
Desc = tr("Hides your character (changes only on your screen)", "\u{421}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{43F}\u{435}\u{440}\u{441}\u{43E}\u{43D}\u{430}\u{436}\u{430} (\u{43C}\u{435}\u{43D}\u{44F}\u{435}\u{442}\u{441}\u{44F} \u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{443} \u{442}\u{435}\u{431}\u{44F} \u{43D}\u{430} \u{44D}\u{43A}\u{440}\u{430}\u{43D}\u{435})"),
Category = "Movement",
Settings = {
{Key = "Level", Label = tr("Invisibility level", "\u{421}\u{442}\u{435}\u{43F}\u{435}\u{43D}\u{44C} \u{43D}\u{435}\u{432}\u{438}\u{434}\u{438}\u{43C}\u{43E}\u{441}\u{442}\u{438}"), Type = "slider", Min = 0.3, Max = 1, Step = 0.05, Default = 1},
{Key = "Accessories", Label = tr("Hide accessories and tools", "\u{421}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{430}\u{43A}\u{441}\u{435}\u{441}\u{441}\u{443}\u{430}\u{440}\u{44B} \u{438} \u{43F}\u{440}\u{435}\u{434}\u{43C}\u{435}\u{442}\u{44B}"), Type = "toggle", Default = true},
},
})
invis.parts, invis.decals, invis.origDecal = {}, {}, {}
invis.nextScan = 0
function invis:Scan()
self.parts, self.decals = {}, {}
local char = player.Character
if not char then return end
for _, d in ipairs(char:GetDescendants()) do
local acc = d:FindFirstAncestorOfClass("Accessory") ~= nil or d:FindFirstAncestorOfClass("Tool") ~= nil
if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
table.insert(self.parts, {d, acc})
elseif d:IsA("Decal") then
if self.origDecal[d] == nil then self.origDecal[d] = d.Transparency end
table.insert(self.decals, {d, acc})
end
end
end
function invis:Paint()
local now = os.clock()
if now >= self.nextScan then
self.nextScan = now + 0.5
self:Scan()
end
local v = self.Values
for _, e in ipairs(self.parts) do
local part, acc = e[1], e[2]
if part.Parent then
part.LocalTransparencyModifier = (acc and not v.Accessories) and 0 or v.Level
end
end
for _, e in ipairs(self.decals) do
local decal, acc = e[1], e[2]
if decal.Parent then
decal.Transparency = (acc and not v.Accessories) and self.origDecal[decal] or v.Level
end
end
end
function invis:Apply()
if self.bound then return end
self.bound = true
RunService:BindToRenderStep("GZ_Invisibility", Enum.RenderPriority.Camera.Value + 1, function()
self:Paint()
end)
end
function invis:Remove()
if self.bound then
RunService:UnbindFromRenderStep("GZ_Invisibility")
self.bound = false
end
for _, e in ipairs(self.parts) do
if e[1].Parent then e[1].LocalTransparencyModifier = 0 end
end
for decal, orig in pairs(self.origDecal) do
if decal.Parent then decal.Transparency = orig end
end
self.parts, self.decals, self.origDecal = {}, {}, {}
self.nextScan = 0
end
function invis:Reset()
self.parts, self.decals, self.origDecal = {}, {}, {}
self.nextScan = 0
end
local stats = registerModule({
Name = tr("FPS / Ping", "FPS / \u{41F}\u{438}\u{43D}\u{433}"),
Desc = tr("Small panel with FPS and ping", "\u{41C}\u{430}\u{43B}\u{435}\u{43D}\u{44C}\u{43A}\u{430}\u{44F} \u{43F}\u{430}\u{43D}\u{435}\u{43B}\u{44C} \u{441} FPS \u{438} \u{43F}\u{438}\u{43D}\u{433}\u{43E}\u{43C}"),
Category = "Misc",
Settings = {
{Key = "Position", Label = tr("Show coordinates", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{44B}\u{432}\u{430}\u{442}\u{44C} \u{43A}\u{43E}\u{43E}\u{440}\u{434}\u{438}\u{43D}\u{430}\u{442}\u{44B}"), Type = "toggle", Default = false},
},
})
stats.fps = 60
stats.nextUpd = 0
function stats:Wipe()
if self.frame then self.frame:Destroy() end
self.frame, self.lbl = nil, nil
end
function stats:Apply()
self:Wipe()
local h = self.Values.Position and 64 or 46
local f = new("Frame", {
Name = "GZ_Stats",
Position = UDim2.fromOffset(12, 12),
Size = UDim2.fromOffset(190, h),
BackgroundColor3 = Theme.Sidebar,
BackgroundTransparency = 0.15,
ZIndex = 25,
}, screenGui)
corner(f, 10)
stroke(f, Theme.Accent, 1.2, 0.45)
self.lbl = textLabel(f, {
Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0),
Font = Enum.Font.GothamMedium, TextSize = 13,
})
self.frame = f
self.nextUpd = 0
end
function stats:Update(dt)
if not self.lbl then return end
if dt > 0 then self.fps = self.fps * 0.9 + (1 / dt) * 0.1 end
local now = os.clock()
if now < self.nextUpd then return end
self.nextUpd = now + 0.25
local ping = 0
pcall(function() ping = player:GetNetworkPing() * 1000 end)
local txt = string.format("FPS: %d\nPing: %d ms", math.floor(self.fps + 0.5), math.floor(ping + 0.5))
if self.Values.Position then
local root = getRoot()
if root then
local p = root.Position
txt = txt .. string.format("\nXYZ: %d, %d, %d", math.floor(p.X), math.floor(p.Y), math.floor(p.Z))
end
end
self.lbl.Text = txt
end
function stats:Remove() self:Wipe() end
local okVU, VirtualUser = pcall(function() return game:GetService("VirtualUser") end)
local afk = registerModule({
Name = tr("Anti-AFK", "\u{410}\u{43D}\u{442}\u{438}-\u{410}\u{424}\u{41A}"),
Desc = tr("Prevents getting kicked for being idle", "\u{41D}\u{435} \u{434}\u{430}\u{451}\u{442} \u{43A}\u{438}\u{43A}\u{43D}\u{443}\u{442}\u{44C} \u{442}\u{435}\u{431}\u{44F} \u{437}\u{430} \u{431}\u{435}\u{437}\u{434}\u{435}\u{439}\u{441}\u{442}\u{432}\u{438}\u{435}"),
Category = "Misc",
})
function afk:Apply()
if self.c or not okVU then return end
self.c = player.Idled:Connect(function()
pcall(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)
end)
end
function afk:Remove()
if self.c then self.c:Disconnect() end
self.c = nil
end
local clean = registerModule({
Name = tr("Clean Screen", "\u{427}\u{438}\u{441}\u{442}\u{44B}\u{439} \u{44D}\u{43A}\u{440}\u{430}\u{43D}"),
Desc = tr("Hides Roblox chat, player list, backpack and health bar (for screenshots)", "\u{421}\u{43A}\u{440}\u{44B}\u{432}\u{430}\u{435}\u{442} \u{447}\u{430}\u{442}, \u{441}\u{43F}\u{438}\u{441}\u{43E}\u{43A} \u{438}\u{433}\u{440}\u{43E}\u{43A}\u{43E}\u{432}, \u{440}\u{44E}\u{43A}\u{437}\u{430}\u{43A} \u{438} \u{437}\u{434}\u{43E}\u{440}\u{43E}\u{432}\u{44C}\u{435} (\u{434}\u{43B}\u{44F} \u{441}\u{43A}\u{440}\u{438}\u{43D}\u{448}\u{43E}\u{442}\u{43E}\u{432})"),
Category = "Misc",
})
function clean:Apply()
pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
end
function clean:Remove()
pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
end
end
local heartbeat = RunService.Heartbeat:Connect(function(dt)
for _, m in ipairs(allModules) do
if m.Enabled and m.Update then
local ok, err = pcall(m.Update, m, dt)
if not ok and not m._warned then
m._warned = true
report("[\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}] " .. tostring(T(m.Name)) .. " / Update: " .. tostring(err))
end
end
end
end)
table.insert(connections, heartbeat)
table.insert(connections, player.CharacterAdded:Connect(function(char)
char:WaitForChild("HumanoidRootPart", 10)
task.wait(0.4)
noclipOrig = {}
for _, m in ipairs(allModules) do
if m.Enabled then
if m.Reset then m:Reset() end
pcall(function() m:Apply() end)
end
end
end))
local WIN_W, WIN_H = 590, 410
local SIDE_W, TOP_H = 160, 50
local holder = new("Frame", {
Name = "Holder",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(WIN_W, WIN_H),
BackgroundTransparency = 1,
Visible = false,
ZIndex = 10,
}, screenGui)
local window = new("Frame", {
Name = "Menu",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = Theme.Bg,
}, holder)
corner(window, 16)
new("UIGradient", {
Color = ColorSequence.new(Color3.fromRGB(21, 19, 31), Color3.fromRGB(13, 12, 19)),
Rotation = 90,
}, window)
local windowStroke = stroke(window, WHITE, 1.5, 0.35)
new("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45}, windowStroke)
local scale = new("UIScale", {Scale = 1}, window)
local sidebar = new("Frame", {Size = UDim2.new(0, SIDE_W, 1, 0), BackgroundColor3 = Theme.Sidebar}, window)
corner(sidebar, 16)
new("Frame", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundColor3 = Theme.Sidebar}, sidebar)
local logo = textLabel(sidebar, {
Size = UDim2.new(1, -20, 0, 54),
Position = UDim2.new(0, 16, 0, 0),
Text = "\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}",
Font = Enum.Font.GothamBlack,
TextSize = 20,
TextColor3 = WHITE,
})
new("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2)}, logo)
local tabsFrame = new("Frame", {Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 1, -120), BackgroundTransparency = 1}, sidebar)
listLayout(tabsFrame, 6)
new("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, tabsFrame)
textLabel(sidebar, {
Position = UDim2.new(0, 16, 1, -46),
Size = UDim2.new(1, -20, 0, 36),
Text = T(platform == "pc" and S.footerPC or S.footerPhone),
TextColor3 = Theme.Sub,
TextSize = 11,
TextYAlignment = Enum.TextYAlignment.Bottom,
TextWrapped = true,
})
local topBar = new("Frame", {
Position = UDim2.new(0, SIDE_W, 0, 0),
Size = UDim2.new(1, -SIDE_W, 0, TOP_H),
BackgroundTransparency = 1,
}, window)
local tabTitle = textLabel(topBar, {
Position = UDim2.new(0, 16, 0, 0),
Size = UDim2.new(1, -70, 1, 0),
Text = "",
Font = Enum.Font.GothamBold,
TextSize = 20,
})
local closeBtn = textButton(topBar, {
Size = UDim2.fromOffset(32, 32),
Position = UDim2.new(1, -44, 0.5, -16),
Text = "\u{2715}",
TextSize = 15,
})
corner(closeBtn, 10)
hover(closeBtn, Theme.Seg, Color3.fromRGB(150, 60, 90))
local function makeDraggable(handle)
handle.InputBegan:Connect(function(input)
if not isPress(input) then return end
local startMouse = input.Position
local startPos = holder.Position
activeDrag = function(pos)
local d = pos - startMouse
holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end
end)
end
makeDraggable(topBar)
makeDraggable(sidebar)
local contentHolder = new("Frame", {
Position = UDim2.new(0, SIDE_W, 0, TOP_H),
Size = UDim2.new(1, -SIDE_W, 1, -TOP_H),
BackgroundTransparency = 1,
ClipsDescendants = true,
}, window)
local function makeScroll(parent, size, position)
local sf = new("ScrollingFrame", {
Size = size,
Position = position or UDim2.new(),
BackgroundTransparency = 1,
ScrollBarThickness = 3,
ScrollBarImageColor3 = Theme.Accent,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
}, parent)
listLayout(sf, 10)
new("UIPadding", {
PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 12),
PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 14),
}, sf)
return sf
end
local content = makeScroll(contentHolder, UDim2.fromScale(1, 1))
local page = new("Frame", {
Size = UDim2.fromScale(1, 1),
Position = UDim2.new(1, 0, 0, 0),
BackgroundTransparency = 1,
Visible = false,
}, contentHolder)
local backBtn = textButton(page, {
Position = UDim2.new(0, 12, 0, 2),
Size = UDim2.fromOffset(92, 30),
Text = T(S.back),
TextSize = 13,
})
corner(backBtn, 8)
hover(backBtn, Theme.Seg, Color3.fromRGB(50, 46, 70))
local pageTitle = textLabel(page, {
Position = UDim2.new(0, 116, 0, 2),
Size = UDim2.new(1, -130, 0, 30),
Text = "",
Font = Enum.Font.GothamBold,
TextSize = 16,
})
local pageList = makeScroll(page, UDim2.new(1, 0, 1, -40), UDim2.new(0, 0, 0, 40))
local function notify(msg)
local toast = new("Frame", {
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, -60),
Size = UDim2.fromOffset(280, 38),
BackgroundColor3 = Theme.Sidebar,
ZIndex = 150,
}, screenGui)
corner(toast, 10)
stroke(toast, Theme.Accent, 1.2, 0.4)
textLabel(toast, {
Size = UDim2.fromScale(1, 1),
Text = msg,
Font = Enum.Font.GothamMedium,
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Center,
})
tween(toast, 0.3, {Position = UDim2.new(0.5, 0, 0, 16)}, Enum.EasingStyle.Back)
task.delay(1.8, function()
local t = tween(toast, 0.25, {Position = UDim2.new(0.5, 0, 0, -60)})
t.Completed:Connect(function() toast:Destroy() end)
end)
end
local cfgScheduleSave = nil
local function setModuleEnabled(mod, state, quiet)
if mod.Enabled == state then return end
mod:SetEnabled(state)
for _, fn in pairs(mod.Listeners) do fn(state) end
if not quiet then notify(T(mod.Name) .. T(state and S.enabled or S.disabled)) end
if cfgScheduleSave then cfgScheduleSave() end
end
local HUD_SIZE = 60
local hudButtons = {}
local function removeHud(mod)
local sq = hudButtons[mod]
if sq then sq:Destroy() end
hudButtons[mod] = nil
mod.Listeners.hud = nil
end
local function createHud(mod)
if hudButtons[mod] then return end
local idx = 0
for _ in pairs(hudButtons) do idx += 1 end
local vp = camera.ViewportSize
local rows = math.max(1, math.floor((vp.Y * 0.7) / (HUD_SIZE + 8)))
local col, row = math.floor(idx / rows), idx % rows
local sq = new("Frame", {
Name = "HudButton",
Size = UDim2.fromOffset(HUD_SIZE, HUD_SIZE),
Position = UDim2.fromOffset(vp.X - HUD_SIZE - 12 - col * (HUD_SIZE + 8), vp.Y * 0.15 + row * (HUD_SIZE + 8)),
BackgroundColor3 = Theme.Card,
ZIndex = 30,
}, screenGui)
corner(sq, 14)
local st = stroke(sq, Theme.Stroke, 1.5, 0.2)
local fill = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = 1}, sq)
corner(fill, 14)
new("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 45}, fill)
local nameLbl = textLabel(sq, {
Position = UDim2.new(0, 4, 0, 6), Size = UDim2.new(1, -8, 0, 34),
Text = T(mod.Name), Font = Enum.Font.GothamBold, TextSize = 12, TextScaled = true,
TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center,
})
new("UITextSizeConstraint", {MaxTextSize = 13, MinTextSize = 7}, nameLbl)
local statusLbl = textLabel(sq, {
Position = UDim2.new(0, 0, 0, 42), Size = UDim2.new(1, 0, 0, 14),
Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Center,
})
local function setState(on)
tween(fill, 0.15, {BackgroundTransparency = on and 0.05 or 1})
tween(st, 0.15, {Color = on and WHITE or Theme.Stroke, Transparency = on and 0.5 or 0.2})
statusLbl.Text = T(on and S.on or S.off)
statusLbl.TextColor3 = on and WHITE or Theme.Sub
nameLbl.TextColor3 = on and WHITE or Theme.Text
end
setState(mod.Enabled)
mod.Listeners.hud = setState
hudButtons[mod] = sq
local hit = textButton(sq, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5})
hit.InputBegan:Connect(function(input)
if not isPress(input) then return end
local startMouse = input.Position
local startPos = sq.Position
local moved = false
activeDrag = function(pos)
local d = pos - startMouse
if d.Magnitude > 8 then moved = true end
if moved then
sq.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
end
end
activeDragEnd = function()
if moved then
local v = camera.ViewportSize
local ap = sq.AbsolutePosition
sq.Position = UDim2.fromOffset(
math.clamp(ap.X, 0, v.X - HUD_SIZE),
math.clamp(ap.Y, 0, v.Y - HUD_SIZE)
)
else
setModuleEnabled(mod, not mod.Enabled)
end
end
end)
end
local function createSwitch(parent, position, state, callback)
local btn = textButton(parent, {
Position = position,
Size = UDim2.fromOffset(44, 24),
BackgroundColor3 = state and Theme.Accent or Theme.Off,
})
corner(btn, 12)
local knob = new("Frame", {
Size = UDim2.fromOffset(18, 18),
Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
BackgroundColor3 = WHITE,
}, btn)
corner(knob, 9)
local obj = {State = state}
function obj.Set(v)
obj.State = v
tween(btn, 0.18, {BackgroundColor3 = v and Theme.Accent or Theme.Off})
tween(knob, 0.18, {Position = v and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)})
end
btn.MouseButton1Click:Connect(function()
obj.Set(not obj.State)
callback(obj.State)
end)
return obj
end
local function rowCard(parent, height, order)
local card = new("Frame", {
Size = UDim2.new(1, 0, 0, height),
BackgroundColor3 = Theme.Card,
LayoutOrder = order,
ClipsDescendants = true,
}, parent)
corner(card, 10)
return card
end
local function buildSegmented(parent, s, value, order, cb)
local nOpt = #s.Options
local cols = nOpt > 5 and math.ceil(nOpt / 2) or nOpt
local nRows = math.ceil(nOpt / cols)
local card = rowCard(parent, 76 + (nRows - 1) * 38, order)
textLabel(card, {Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 20), Text = T(s.Label), TextColor3 = Theme.Sub, TextSize = 13})
local row = new("Frame", {Position = UDim2.new(0, 12, 0, 34), Size = UDim2.new(1, -24, 0, nRows * 32 + (nRows - 1) * 6), BackgroundTransparency = 1}, card)
new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Wraps = true, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, row)
local btns = {}
local function choose(v)
for key, b in pairs(btns) do
local on = key == v
tween(b, 0.15, {BackgroundColor3 = on and Theme.Accent or Theme.Seg, TextColor3 = on and WHITE or Theme.Sub})
end
end
for i, opt in ipairs(s.Options) do
local b = textButton(row, {
LayoutOrder = i,
Size = UDim2.new(1 / cols, -(6 * (cols - 1) / cols) - 1, 0, 32),
Text = T(opt[2]),
TextSize = 13,
TextColor3 = Theme.Sub,
})
corner(b, 8)
btns[opt[1]] = b
b.MouseButton1Click:Connect(function()
choose(opt[1])
cb(opt[1])
end)
end
choose(value)
return card
end
local function buildSlider(parent, s, value, order, cb)
local card = rowCard(parent, 66, order)
textLabel(card, {Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 20), Text = T(s.Label), TextColor3 = Theme.Sub, TextSize = 13})
local valueLabel = textLabel(card, {
Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 20),
Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right,
})
local track = new("Frame", {Position = UDim2.new(0, 12, 0, 44), Size = UDim2.new(1, -24, 0, 6), BackgroundColor3 = Theme.Track}, card)
corner(track, 3)
local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE}, track)
corner(fill, 3)
new("UIGradient", {Color = ColorSequence.new(Theme.Accent, Theme.Accent2)}, fill)
local knob = new("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(16, 16),
Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = WHITE, ZIndex = 3,
}, track)
corner(knob, 8)
local decimals = s.Step >= 1 and 0 or (s.Step >= 0.1 and 1 or 2)
local function render(v)
local a = (v - s.Min) / (s.Max - s.Min)
fill.Size = UDim2.new(a, 0, 1, 0)
knob.Position = UDim2.new(a, 0, 0.5, 0)
valueLabel.Text = string.format("%." .. decimals .. "f", v)
end
render(value)
local function setFromX(x)
local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
local v = s.Min + a * (s.Max - s.Min)
v = math.clamp(math.floor(v / s.Step + 0.5) * s.Step, s.Min, s.Max)
v = tonumber(string.format("%.3f", v))
render(v)
cb(v)
end
local hit = textButton(card, {
Position = UDim2.new(0, 12, 0, 32), Size = UDim2.new(1, -24, 0, 30),
BackgroundTransparency = 1, ZIndex = 4,
})
hit.InputBegan:Connect(function(input)
if isPress(input) then
setFromX(input.Position.X)
activeDrag = function(pos) setFromX(pos.X) end
end
end)
return card
end
local function buildToggle(parent, s, value, order, cb)
local card = rowCard(parent, 46, order)
textLabel(card, {Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -80, 1, 0), Text = T(s.Label), TextSize = 14, TextWrapped = true})
createSwitch(card, UDim2.new(1, -56, 0.5, -12), value, cb)
return card
end
local function buildKeybind(parent, s, value, order, cb)
local card = rowCard(parent, 46, order)
textLabel(card, {
Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -150, 1, 0),
Text = T(s.Label), TextSize = 13, TextWrapped = true,
})
local btn = textButton(card, {
Position = UDim2.new(1, -130, 0, 9), Size = UDim2.fromOffset(118, 28),
Text = value == "" and T(S.none) or value, TextSize = 13,
TextColor3 = value == "" and Theme.Sub or Theme.Text,
})
corner(btn, 8)
stroke(btn, Theme.Stroke, 1.2, 0.4)
btn.MouseButton1Click:Connect(function()
btn.Text = T(S.pressKey)
tween(btn, 0.12, {BackgroundColor3 = Theme.Accent})
listeningBind = function(keyName)
listeningBind = nil
btn.Text = keyName == "" and T(S.none) or keyName
btn.TextColor3 = keyName == "" and Theme.Sub or Theme.Text
tween(btn, 0.12, {BackgroundColor3 = Theme.Seg})
cb(keyName)
end
end)
return card
end
local HUE_SEQ = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})
local function buildColor(parent, s, value, order, cb)
local card = rowCard(parent, 46, order)
textLabel(card, {Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -80, 0, 46), Text = T(s.Label), TextSize = 14})
local swatch = textButton(card, {Position = UDim2.new(1, -62, 0, 9), Size = UDim2.fromOffset(50, 28), BackgroundColor3 = value})
corner(swatch, 8)
stroke(swatch, WHITE, 1.2, 0.6)
local hh, ss, vv = value:ToHSV()
local sv = new("Frame", {Position = UDim2.new(0, 12, 0, 52), Size = UDim2.new(1, -24, 0, 104), BackgroundColor3 = Color3.fromHSV(hh, 1, 1)}, card)
corner(sv, 8)
local white = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE}, sv)
corner(white, 8)
new("UIGradient", {Transparency = NumberSequence.new(0, 1)}, white)
local black = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0)}, sv)
corner(black, 8)
new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}, black)
local svKnob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ZIndex = 3}, sv)
corner(svKnob, 7)
stroke(svKnob, WHITE, 2, 0)
local svHit = textButton(sv, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 4})
local hue = new("Frame", {Position = UDim2.new(0, 12, 0, 166), Size = UDim2.new(1, -24, 0, 16), BackgroundColor3 = WHITE}, card)
corner(hue, 8)
new("UIGradient", {Color = HUE_SEQ}, hue)
local hueKnob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 22), BackgroundTransparency = 1, ZIndex = 3}, hue)
corner(hueKnob, 4)
stroke(hueKnob, WHITE, 2, 0)
local hueHit = textButton(hue, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 4})
local function render(fire)
local c = Color3.fromHSV(hh, ss, vv)
swatch.BackgroundColor3 = c
sv.BackgroundColor3 = Color3.fromHSV(hh, 1, 1)
svKnob.Position = UDim2.new(ss, 0, 1 - vv, 0)
hueKnob.Position = UDim2.new(hh, 0, 0.5, 0)
if fire then cb(c) end
end
render(false)
local function svFrom(pos)
ss = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
vv = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
render(true)
end
local function hueFrom(pos)
hh = math.clamp((pos.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
render(true)
end
svHit.InputBegan:Connect(function(input)
if isPress(input) then svFrom(input.Position); activeDrag = svFrom end
end)
hueHit.InputBegan:Connect(function(input)
if isPress(input) then hueFrom(input.Position); activeDrag = hueFrom end
end)
local expanded = false
swatch.MouseButton1Click:Connect(function()
expanded = not expanded
tween(card, 0.2, {Size = UDim2.new(1, 0, 0, expanded and 194 or 46)})
end)
return card
end
local settingsOpen = false
local function closeSettings(instant)
if not settingsOpen then return end
settingsOpen = false
listeningBind = nil
if instant then
page.Visible = false
content.Position = UDim2.new()
else
tween(content, 0.25, {Position = UDim2.new()})
tween(page, 0.25, {Position = UDim2.new(1, 0, 0, 0)})
task.delay(0.27, function()
if not settingsOpen then page.Visible = false end
end)
end
end
local function openSettings(mod)
clearList(pageList)
pageList.CanvasPosition = Vector2.zero
pageTitle.Text = T(mod.Name)
local rows = {}
local function refresh()
for _, r in ipairs(rows) do
r.card.Visible = (r.def.ShowIf == nil) or r.def.ShowIf(mod.Values)
end
end
for i, def in ipairs(mod.Settings) do
local function cb(v)
mod.Values[def.Key] = v
if cfgScheduleSave then cfgScheduleSave() end
if def.Key == "ShowButton" then
if v then createHud(mod) else removeHud(mod) end
elseif def.Key ~= "Keybind" then
mod:Changed()
end
refresh()
end
local value = mod.Values[def.Key]
local card
if def.Type == "segmented" then
card = buildSegmented(pageList, def, value, i, cb)
elseif def.Type == "slider" then
card = buildSlider(pageList, def, value, i, cb)
elseif def.Type == "toggle" then
card = buildToggle(pageList, def, value, i, cb)
elseif def.Type == "color" then
card = buildColor(pageList, def, value, i, cb)
elseif def.Type == "keybind" then
card = buildKeybind(pageList, def, value, i, cb)
end
table.insert(rows, {card = card, def = def})
end
refresh()
settingsOpen = true
page.Position = UDim2.new(1, 0, 0, 0)
page.Visible = true
tween(page, 0.25, {Position = UDim2.new()})
tween(content, 0.25, {Position = UDim2.new(-1, 0, 0, 0)})
end
backBtn.MouseButton1Click:Connect(function() closeSettings(false) end)
table.insert(CATEGORIES, {key = "Config", name = tr("Config", "\u{41A}\u{444}\u{433}")})
local currentTab = "Visuals"
local cfgAutoOn = true
local cfgLoading = false
local cfgSavedAt = nil
local cfgStamp = 0
local cfgForgetLang = false
local function cfgSnapshot()
local data = {modules = {}}
if not cfgForgetLang then
data.lang = lang
data.platform = platform
end
for _, m in ipairs(allModules) do
local vals = {}
for k, v in pairs(m.Values) do
local tv = typeof(v)
if tv == "Color3" then
vals[k] = {__c = {v.R, v.G, v.B}}
elseif tv == "number" or tv == "boolean" or tv == "string" then
vals[k] = v
end
end
data.modules[m.Name.en] = {enabled = m.Enabled, values = vals}
end
return data
end
local function cfgApply(data)
if type(data) ~= "table" or type(data.modules) ~= "table" then return false end
cfgLoading = true
closeSettings(true)
for _, m in ipairs(allModules) do
if m.Enabled then setModuleEnabled(m, false, true) end
end
for _, m in ipairs(allModules) do
local e = data.modules[m.Name.en]
if type(e) == "table" and type(e.values) == "table" then
for k, v in pairs(e.values) do
local cur = m.Values[k]
if cur ~= nil then
if type(v) == "table" and type(v.__c) == "table" then
if typeof(cur) == "Color3" then
m.Values[k] = Color3.new(v.__c[1] or 0, v.__c[2] or 0, v.__c[3] or 0)
end
elseif typeof(v) == typeof(cur) then
m.Values[k] = v
end
end
end
end
if m.Values.ShowButton then createHud(m) else removeHud(m) end
end
for _, m in ipairs(allModules) do
local e = data.modules[m.Name.en]
if type(e) == "table" and e.enabled == true then setModuleEnabled(m, true, true) end
end
cfgLoading = false
return true
end
local function cfgList()
local l = cfgRead("list")
if type(l) ~= "table" then l = {} end
if type(l.items) ~= "table" then l.items = {} end
if type(l.nextId) ~= "number" then l.nextId = 2 end
return l
end
cfgScheduleSave = function()
if not cfgAutoOn or cfgLoading then return end
local stamp = os.clock()
cfgStamp = stamp
task.delay(1.5, function()
if cfgStamp == stamp and cfgAutoOn then
if cfgWrite("autosave", cfgSnapshot()) then
cfgSavedAt = os.date("%H:%M:%S")
end
end
end)
end
local function startupLoad()
local data = cfgRead("autosave")
if data and cfgApply(data) then
dbg("Cfg 1 (autosave) loaded")
end
end
local buildConfigTab
local function refreshCfgTab()
if currentTab == "Config" then
clearList(content)
buildConfigTab()
end
end
local function cfgRow(order, title, sub, defs)
local card = new("Frame", {Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = Theme.Card, LayoutOrder = order}, content)
corner(card, 12)
local reserve = 24 + #defs * 68
textLabel(card, {
Position = UDim2.new(0, 14, 0, 9), Size = UDim2.new(1, -reserve, 0, 20),
Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd,
})
textLabel(card, {
Position = UDim2.new(0, 14, 0, 31), Size = UDim2.new(1, -reserve, 0, 26),
Text = sub, TextColor3 = Theme.Sub, TextSize = 11, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
})
for i, d in ipairs(defs) do
local b = textButton(card, {
Size = UDim2.fromOffset(62, 30),
Position = UDim2.new(1, -(12 + (i - 1) * 68 + 62), 0.5, -15),
Text = T(d.text), TextSize = 12,
BackgroundColor3 = d.color or Theme.Seg,
TextColor3 = WHITE,
})
corner(b, 8)
b.MouseButton1Click:Connect(d.fn)
end
return card
end
buildConfigTab = function()
local order = 0
local function nxt()
order += 1
return order
end
if not fsOK then
textLabel(content, {
Size = UDim2.new(1, 0, 0, 34), LayoutOrder = nxt(), TextWrapped = true, TextSize = 12,
TextColor3 = Color3.fromRGB(255, 170, 120),
Text = T(tr("File saving is not available here: configs live only until you leave the game.",
"\u{421}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{435}\u{43D}\u{438}\u{435} \u{432} \u{444}\u{430}\u{439}\u{43B}\u{44B} \u{442}\u{443}\u{442} \u{43D}\u{435}\u{434}\u{43E}\u{441}\u{442}\u{443}\u{43F}\u{43D}\u{43E}: \u{43A}\u{43E}\u{43D}\u{444}\u{438}\u{433}\u{438} \u{436}\u{438}\u{432}\u{443}\u{442} \u{442}\u{43E}\u{43B}\u{44C}\u{43A}\u{43E} \u{434}\u{43E} \u{432}\u{44B}\u{445}\u{43E}\u{434}\u{430} \u{438}\u{437} \u{438}\u{433}\u{440}\u{44B}.")),
})
end
local autoCard = new("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Theme.Card, LayoutOrder = nxt()}, content)
corner(autoCard, 12)
textLabel(autoCard, {
Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -90, 1, 0),
Text = T(tr("Auto-save (slot 1)", "\u{410}\u{432}\u{442}\u{43E}\u{441}\u{435}\u{439}\u{432} (\u{441}\u{43B}\u{43E}\u{442} 1)")), Font = Enum.Font.GothamBold, TextSize = 14,
})
createSwitch(autoCard, UDim2.new(1, -58, 0.5, -12), cfgAutoOn, function(s)
cfgAutoOn = s
if s then cfgScheduleSave() end
end)
local hasAuto = cfgRead("autosave") ~= nil
local sub1
if hasAuto then
sub1 = cfgSavedAt and (T(tr("Saved at ", "\u{421}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{435}\u{43D}\u{43E} \u{432} ")) .. cfgSavedAt)
or T(tr("Saved. Loads by itself on start.", "\u{421}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{451}\u{43D}. \u{413}\u{440}\u{443}\u{437}\u{438}\u{442}\u{441}\u{44F} \u{441}\u{430}\u{43C} \u{43F}\u{440}\u{438} \u{437}\u{430}\u{43F}\u{443}\u{441}\u{43A}\u{435}."))
else
sub1 = T(tr("Empty. Fills in by itself after your first change.", "\u{41F}\u{443}\u{441}\u{442}\u{43E}. \u{417}\u{430}\u{43F}\u{43E}\u{43B}\u{43D}\u{438}\u{442}\u{441}\u{44F} \u{441}\u{430}\u{43C}\u{43E} \u{43F}\u{43E}\u{441}\u{43B}\u{435} \u{43F}\u{435}\u{440}\u{432}\u{43E}\u{433}\u{43E} \u{438}\u{437}\u{43C}\u{435}\u{43D}\u{435}\u{43D}\u{438}\u{44F}."))
end
cfgRow(nxt(), "1  \u{2022}  " .. T(tr("Auto-save", "\u{410}\u{432}\u{442}\u{43E}\u{441}\u{435}\u{439}\u{432}")), sub1, {
{text = tr("Save", "\u{421}\u{43E}\u{445}\u{440}."), fn = function()
if cfgWrite("autosave", cfgSnapshot()) then
cfgSavedAt = os.date("%H:%M:%S")
notify(T(tr("Config 1 saved", "\u{41A}\u{444}\u{433} 1 \u{441}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{451}\u{43D}")))
else
notify(T(tr("Could not save", "\u{41D}\u{435} \u{443}\u{434}\u{430}\u{43B}\u{43E}\u{441}\u{44C} \u{441}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{438}\u{442}\u{44C}")))
end
refreshCfgTab()
end},
{text = tr("Load", "\u{417}\u{430}\u{433}\u{440}."), fn = function()
local d = cfgRead("autosave")
if d and cfgApply(d) then
notify(T(tr("Config 1 loaded", "\u{41A}\u{444}\u{433} 1 \u{437}\u{430}\u{433}\u{440}\u{443}\u{436}\u{435}\u{43D}")))
else
notify(T(tr("Slot 1 is empty", "\u{421}\u{43B}\u{43E}\u{442} 1 \u{43F}\u{443}\u{441}\u{442}")))
end
end},
})
local list = cfgList()
for idx, it in ipairs(list.items) do
cfgRow(nxt(), (idx + 1) .. "  \u{2022}  " .. tostring(it.name),
T(tr("Save overwrites it with your current settings", "\u{AB}\u{421}\u{43E}\u{445}\u{440}.\u{BB} \u{43F}\u{435}\u{440}\u{435}\u{437}\u{430}\u{43F}\u{438}\u{448}\u{435}\u{442} \u{435}\u{433}\u{43E} \u{442}\u{435}\u{43A}\u{443}\u{449}\u{438}\u{43C}\u{438} \u{43D}\u{430}\u{441}\u{442}\u{440}\u{43E}\u{439}\u{43A}\u{430}\u{43C}\u{438}")), {
{text = "\u{2715}", color = Color3.fromRGB(150, 60, 90), fn = function()
local l = cfgList()
for i, x in ipairs(l.items) do
if x.id == it.id then
table.remove(l.items, i)
break
end
end
if fsOK and type(delfile) == "function" then
pcall(function() delfile(cfgPath(it.id)) end)
end
cfgWrite("list", l)
notify(T(tr("Config deleted", "\u{41A}\u{444}\u{433} \u{443}\u{434}\u{430}\u{43B}\u{451}\u{43D}")))
refreshCfgTab()
end},
{text = tr("Save", "\u{421}\u{43E}\u{445}\u{440}."), fn = function()
if cfgWrite(it.id, cfgSnapshot()) then
notify(T(tr("Config saved", "\u{41A}\u{444}\u{433} \u{441}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{451}\u{43D}")))
else
notify(T(tr("Could not save", "\u{41D}\u{435} \u{443}\u{434}\u{430}\u{43B}\u{43E}\u{441}\u{44C} \u{441}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{438}\u{442}\u{44C}")))
end
end},
{text = tr("Load", "\u{417}\u{430}\u{433}\u{440}."), fn = function()
local d = cfgRead(it.id)
if d and cfgApply(d) then
notify(T(tr("Config loaded", "\u{41A}\u{444}\u{433} \u{437}\u{430}\u{433}\u{440}\u{443}\u{436}\u{435}\u{43D}")))
else
notify(T(tr("Config is empty", "\u{41A}\u{444}\u{433} \u{43F}\u{443}\u{441}\u{442}")))
end
end},
})
end
local newCard = new("Frame", {Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = Theme.Card, LayoutOrder = nxt()}, content)
corner(newCard, 12)
local box = new("TextBox", {
Position = UDim2.new(0, 12, 0.5, -16), Size = UDim2.new(1, -108, 0, 32),
BackgroundColor3 = Theme.Seg, TextColor3 = Theme.Text, PlaceholderColor3 = Theme.Sub,
PlaceholderText = T(tr("New config name (optional)", "\u{418}\u{43C}\u{44F} \u{43D}\u{43E}\u{432}\u{43E}\u{433}\u{43E} \u{43A}\u{444}\u{433} (\u{43D}\u{435}\u{43E}\u{431}\u{44F}\u{437}\u{430}\u{442}\u{435}\u{43B}\u{44C}\u{43D}\u{43E})")),
Text = "", TextSize = 13, Font = Enum.Font.Gotham, ClearTextOnFocus = false,
TextXAlignment = Enum.TextXAlignment.Left,
}, newCard)
corner(box, 8)
new("UIPadding", {PaddingLeft = UDim.new(0, 10)}, box)
local create = textButton(newCard, {
Position = UDim2.new(1, -86, 0.5, -16), Size = UDim2.fromOffset(74, 32),
Text = T(tr("+ Create", "+ \u{421}\u{43E}\u{437}\u{434}\u{430}\u{442}\u{44C}")), TextSize = 13, BackgroundColor3 = Theme.Accent, TextColor3 = WHITE,
})
corner(create, 8)
create.MouseButton1Click:Connect(function()
local l = cfgList()
if #l.items >= 20 then
notify(T(tr("Max 20 configs", "\u{41C}\u{430}\u{43A}\u{441}\u{438}\u{43C}\u{443}\u{43C} 20 \u{43A}\u{444}\u{433}")))
return
end
local name = box.Text:gsub("^%s+", ""):gsub("%s+$", "")
name = string.sub(name, 1, 24)
if name == "" then name = T(tr("Config", "\u{41A}\u{444}\u{433}")) .. " " .. (#l.items + 2) end
local id = "cfg_" .. l.nextId
l.nextId = l.nextId + 1
table.insert(l.items, {id = id, name = name})
if cfgWrite(id, cfgSnapshot()) and cfgWrite("list", l) then
notify(T(tr("Config created", "\u{41A}\u{444}\u{433} \u{441}\u{43E}\u{437}\u{434}\u{430}\u{43D}")))
else
notify(T(tr("Could not save", "\u{41D}\u{435} \u{443}\u{434}\u{430}\u{43B}\u{43E}\u{441}\u{44C} \u{441}\u{43E}\u{445}\u{440}\u{430}\u{43D}\u{438}\u{442}\u{44C}")))
end
refreshCfgTab()
end)
cfgRow(nxt(), T(tr("Language / platform", "\u{42F}\u{437}\u{44B}\u{43A} / \u{43F}\u{43B}\u{430}\u{442}\u{444}\u{43E}\u{440}\u{43C}\u{430}")),
T(tr("Show the choice screen again on next launch", "\u{41F}\u{43E}\u{43A}\u{430}\u{437}\u{430}\u{442}\u{44C} \u{44D}\u{43A}\u{440}\u{430}\u{43D} \u{432}\u{44B}\u{431}\u{43E}\u{440}\u{430} \u{441}\u{43D}\u{43E}\u{432}\u{430} \u{43F}\u{440}\u{438} \u{441}\u{43B}\u{435}\u{434}\u{443}\u{44E}\u{449}\u{435}\u{43C} \u{437}\u{430}\u{43F}\u{443}\u{441}\u{43A}\u{435}")), {
{text = tr("Reset", "\u{421}\u{431}\u{440}\u{43E}\u{441}"), fn = function()
cfgForgetLang = true
cfgWrite("autosave", cfgSnapshot())
notify(T(tr("Will ask next launch", "\u{421}\u{43F}\u{440}\u{43E}\u{448}\u{443} \u{43F}\u{440}\u{438} \u{441}\u{43B}\u{435}\u{434}\u{443}\u{44E}\u{449}\u{435}\u{43C} \u{437}\u{430}\u{43F}\u{443}\u{441}\u{43A}\u{435}")))
end},
})
end
local function createModuleCard(mod, order)
local card = new("Frame", {Size = UDim2.new(1, 0, 0, 78), BackgroundColor3 = Theme.Card, LayoutOrder = order}, content)
corner(card, 12)
local st = stroke(card, mod.Enabled and Theme.Accent or Theme.Stroke, 1.2, mod.Enabled and 0.2 or 0.65)
local sw = createSwitch(card, UDim2.new(0, 14, 0.5, -12), mod.Enabled, function(state)
setModuleEnabled(mod, state)
end)
mod.Listeners.card = function(state)
sw.Set(state)
tween(st, 0.2, {Color = state and Theme.Accent or Theme.Stroke, Transparency = state and 0.2 or 0.65})
end
textLabel(card, {Position = UDim2.new(0, 72, 0, 14), Size = UDim2.new(1, -130, 0, 20), Text = T(mod.Name), Font = Enum.Font.GothamBold, TextSize = 15})
textLabel(card, {
Position = UDim2.new(0, 72, 0, 36), Size = UDim2.new(1, -130, 0, 34), Text = T(mod.Desc),
TextColor3 = Theme.Sub, TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
})
local gear = textButton(card, {
Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, -44, 0.5, -16),
Text = "\u{2699}", TextSize = 17, TextColor3 = Theme.Sub,
})
corner(gear, 9)
hover(gear, Theme.Seg, Color3.fromRGB(52, 47, 74))
gear.MouseButton1Click:Connect(function() openSettings(mod) end)
end
local tabButtons = {}
local function loadTab(key)
closeSettings(true)
for _, m in ipairs(allModules) do m.Listeners.card = nil end
clearList(content)
currentTab = key
for _, cat in ipairs(CATEGORIES) do
local t = tabButtons[cat.key]
local active = cat.key == key
if active then tabTitle.Text = T(cat.name) end
tween(t.btn, 0.15, {BackgroundTransparency = active and 0.85 or 1, TextColor3 = active and Theme.Text or Theme.Sub})
tween(t.bar, 0.15, {BackgroundTransparency = active and 0 or 1})
end
if key == "Config" then
buildConfigTab()
content.CanvasPosition = Vector2.zero
return
end
local count = 0
for _, mod in ipairs(allModules) do
if mod.Category == key then
count += 1
createModuleCard(mod, count)
end
end
if count == 0 then
textLabel(content, {
Size = UDim2.new(1, 0, 0, 60), Text = T(S.soon), TextColor3 = Theme.Sub,
TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center,
})
end
content.CanvasPosition = Vector2.zero
end
for i, cat in ipairs(CATEGORIES) do
local b = textButton(tabsFrame, {
LayoutOrder = i,
Size = UDim2.new(1, 0, 0, 38),
BackgroundColor3 = Theme.Accent,
BackgroundTransparency = 1,
Text = T(cat.name),
TextSize = 14,
TextColor3 = Theme.Sub,
TextXAlignment = Enum.TextXAlignment.Left,
})
corner(b, 10)
new("UIPadding", {PaddingLeft = UDim.new(0, 16)}, b)
local bar = new("Frame", {
Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, -13, 0.5, -9),
BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1,
}, b)
corner(bar, 2)
tabButtons[cat.key] = {btn = b, bar = bar}
b.MouseButton1Click:Connect(function() loadTab(cat.key) end)
end
local MIN_SCALE = 0.01
local fitScale = 1
local menuOpen = false
local busy = false
local function updateFit()
local vp = camera.ViewportSize
fitScale = math.clamp(math.min(vp.X / (WIN_W + 40), vp.Y / (WIN_H + 40)), 0.5, 1)
if menuOpen and not busy then scale.Scale = fitScale end
end
updateFit()
table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateFit))
local mini = textButton(screenGui, {
AnchorPoint = Vector2.new(0.5, 1),
Position = UDim2.new(0.5, 0, 1, -20),
Size = UDim2.fromOffset(190, 40),
BackgroundColor3 = Theme.Sidebar,
Text = "\u{433}\u{430}\u{437}\u{44F}\u{432}\u{44B}\u{434}\u{43B}\u{441}  \u{2022}  " .. T(S.open),
TextSize = 15,
Visible = false,
ZIndex = 10,
})
corner(mini, 12)
stroke(mini, Theme.Accent, 1.3, 0.4)
hover(mini, Theme.Sidebar, Color3.fromRGB(26, 23, 38))
local function openMenu()
if menuOpen or busy then return end
busy, menuOpen = true, true
mini.Visible = false
holder.Visible = true
scale.Scale = MIN_SCALE
tween(scale, 0.35, {Scale = fitScale}, Enum.EasingStyle.Back).Completed:Connect(function()
busy = false
end)
end
local function closeMenu()
if not menuOpen or busy then return end
busy, menuOpen = true, false
closeSettings(true)
tween(scale, 0.22, {Scale = MIN_SCALE}, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Connect(function()
holder.Visible = false
mini.Visible = true
busy = false
end)
end
closeBtn.MouseButton1Click:Connect(closeMenu)
mini.MouseButton1Click:Connect(openMenu)
table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
if listeningBind then
local fnBind = listeningBind
if input.KeyCode == Enum.KeyCode.Backspace then
fnBind("")
elseif input.KeyCode ~= Enum.KeyCode.Unknown then
fnBind(input.KeyCode.Name)
end
return
end
if processed then return end
if input.KeyCode == MENU_KEY then
if menuOpen then closeMenu() else openMenu() end
return
end
if platform == "pc" then
local name = input.KeyCode.Name
for _, m in ipairs(allModules) do
if m.Values.Keybind ~= "" and m.Values.Keybind == name then
setModuleEnabled(m, not m.Enabled)
end
end
end
end))
screenGui.Destroying:Connect(function()
for _, m in ipairs(allModules) do
if m.Enabled then m:SetEnabled(false) end
end
for _, c in ipairs(connections) do c:Disconnect() end
end)
startupLoad()
loadTab("Visuals")
openMenu()
dbg("4/4 \u{43C}\u{435}\u{43D}\u{44E} \u{43E}\u{442}\u{43A}\u{440}\u{44B}\u{442}\u{43E} \u{2714} (RightShift \u{2014} \u{441}\u{43A}\u{440}\u{44B}\u{442}\u{44C}/\u{43F}\u{43E}\u{43A}\u{430}\u{437}\u{430}\u{442}\u{44C})")
task.delay(5, dbgHide)
end
local okMain, errMain = xpcall(main, function(e)
return debug.traceback(tostring(e), 2)
end)
if not okMain then
report("\u{41A}\u{420}\u{410}\u{428}: " .. tostring(errMain))
end
