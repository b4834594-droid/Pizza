-- início

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

------------------------------------------------
-- REMOVER DANO DE QUEDA
------------------------------------------------
humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

------------------------------------------------
-- FUNÇÃO DE MOVIMENTO
------------------------------------------------
local function irAte(pos, velocidade)
	local distancia = (hrp.Position - pos).Magnitude
	local tempo = distancia / velocidade

	local tween = TweenService:Create(
		hrp,
		TweenInfo.new(tempo, Enum.EasingStyle.Linear),
		{CFrame = CFrame.new(pos)}
	)

	tween:Play()
	tween.Completed:Wait()
end

------------------------------------------------
-- FUNÇÃO PARA INTERAGIR COM PROXIMITYPROMPT
------------------------------------------------
local function interagir(obj)
	local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt then
		fireproximityprompt(prompt)
	end
end

------------------------------------------------
-- 1º LOCAL
------------------------------------------------
local primeiroLocal = Vector3.new(3312.1, 2.6, 3019.9)

irAte(primeiroLocal, 60)
task.wait(0.5)

-- tenta interagir com algo próximo
for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("ProximityPrompt") then
		if (v.Parent.Position - hrp.Position).Magnitude < 10 then
			fireproximityprompt(v)
			break
		end
	end
end

------------------------------------------------
-- 2º LOCAL (PAD)
------------------------------------------------
local padFolder = workspace.Construcoes.Pizzaria.OrderCharSpawns.Pad

-- pega o PAD mais próximo
local padEscolhido
local menorDistancia = math.huge

for _, pad in pairs(padFolder:GetChildren()) do
	if pad:IsA("BasePart") then
		local dist = (pad.Position - hrp.Position).Magnitude
		if dist < menorDistancia then
			menorDistancia = dist
			padEscolhido = pad
		end
	end
end

if padEscolhido then
	irAte(padEscolhido.Position + Vector3.new(0, 2, 0), 60)
	task.wait(0.5)
	interagir(padEscolhido)
end
