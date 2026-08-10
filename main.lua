_G.love      = require 'love'
local Player = require 'player'
local Camera = require 'camera'
local level  = require 'levels.level1'

local player
local camera

function love.load()
  player = Player.new(level.spawnX, level.spawnY)
  camera = Camera.new()
end

function love.update(dt)
  if not player.hasReachedGoal then
    local moveAmount = Player.update(
      player,
      dt,
      level.platforms,
      level.hazards,
      level.goal,
      level.checkpoints
    )
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
  for _, plat in ipairs(level.platforms) do
    love.graphics.rectangle('fill', plat.x, plat.y, plat.w, plat.h)
  end

  -- draw hazards --
  love.graphics.setColor(0.9, 0.2, 0.2)
  for _, hz in ipairs(level.hazards) do
    love.graphics.rectangle('fill', hz.x, hz.y, hz.w, hz.h)
  end

  -- draw checkpoints --
  for _, cp in ipairs(level.checkpoints) do
    love.graphics.setColor(0.3, 0.5, 1)
    love.graphics.rectangle('fill', cp.x, cp.y, cp.w, cp.h)
  end

  -- draw goal --
  love.graphics.setColor(1, 0.85, 0.2)
  love.graphics.rectangle('fill', level.goal.x, level.goal.y, level.goal.w, level.goal.h)

  Player.draw(player)
  Camera.detach()

  if player.hasReachedGoal then
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Level Complete!', 0, 20, love.graphics.getWidth(), 'center')
  end
end
