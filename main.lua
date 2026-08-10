_G.love      = require 'love'
local Player = require 'player'
local Camera = require 'camera'

local player
local camera
local platforms
local hazards
local checkpoints
local goal

function love.load()
  player      = Player.new(100, 100)
  camera      = Camera.new()
  platforms   = {
    { x = 0,    y = 400, w = 800, h = 100 },
    { x = 1000, y = 400, w = 800, h = 100 },
    { x = 2100, y = 400, w = 800, h = 100 },
    { x = 3300, y = 400, w = 800, h = 100 }
  }
  hazards     = {
    { x = 800,  y = 440, w = 200, h = 60 },
    { x = 1800, y = 440, w = 300, h = 60 },
    { x = 2900, y = 440, w = 400, h = 60 }
  }
  checkpoints = {
    { x = 2400, y = 400, w = 40, h = 80 }
  }
  goal        = { x = 4060, y = 350, w = 40, h = 50 }
end

function love.update(dt)
  if not player.hasReachedGoal then
    local moveAmount = Player.update(player, dt, platforms, hazards, goal, checkpoints)
    Camera.update(camera, dt, player, moveAmount)
  end
end

function love.keypressed(key)
  if not player.hasReachedGoal then
    Player.keypressed(player, key)
  end
end

function love.keyreleased(key)
  if not player.hasReachedGoal then
    Player.keyreleased(player, key)
  end
end

function love.draw()
  Camera.attach(camera)

  -- draw platforms --
  love.graphics.setColor(0.3, 0.7, 0.3)
  for _, plat in ipairs(platforms) do
    love.graphics.rectangle('fill', plat.x, plat.y, plat.w, plat.h)
  end

  -- draw hazards --
  love.graphics.setColor(0.9, 0.2, 0.2)
  for _, hz in ipairs(hazards) do
    love.graphics.rectangle('fill', hz.x, hz.y, hz.w, hz.h)
  end

  -- draw checkpoints --
  for _, cp in ipairs(checkpoints) do
    love.graphics.setColor(0.3, 0.5, 1)
    love.graphics.rectangle('fill', cp.x, cp.y, cp.w, cp.h)
  end

  -- draw goal --
  love.graphics.setColor(1, 0.85, 0.2)
  love.graphics.rectangle('fill', goal.x, goal.y, goal.w, goal.h)

  Player.draw(player)
  Camera.detach()

  if player.hasReachedGoal then
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Level Complete!', 0, 20, love.graphics.getWidth(), 'center')
  end
end
