_G.love        = require 'love'
local Player   = require 'player'
local Camera   = require 'camera'
local level    = require 'levels.level1'

local player
local camera
local isPaused = false

function love.load()
  player = Player.new(level.spawnX, level.spawnY)
  camera = Camera.new()
end

function love.update(dt)
  if isPaused or player.hasReachedGoal then return end

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

function love.keypressed(key)
  if key == 'p' then
    isPaused = not isPaused
    return
  end

  if not isPaused and not player.hasReachedGoal then
    Player.keypressed(player, key)
  end
end

function love.keyreleased(key)
  if not player.hasReachedGoal then
    Player.keyreleased(player, key)
  end
end

local function drawPauseMenu()
  local screenWidth  = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  love.graphics.setColor(0, 0, 0, 0.6)
  love.graphics.rectangle('fill', 0, 0, screenWidth, screenHeight)

  love.graphics.setColor(1, 1, 1)
  love.graphics.printf('PAUSED', 0, screenHeight * 0.25, screenWidth, 'center')

  local lines = {
    'Reach the golden goalpost',
    'Pass through the blue checkpoints to save progress',
    "Don't fall into the red pits!",
    '',
    'Controls:',
    'Move: ' .. player.keys.left .. ' / ' .. player.keys.right,
    'Jump: ' .. player.keys.jump,
    'Dash: ' .. player.keys.dash,
    'Pause: p',
  }

  local startY = screenHeight * 0.4
  for i, line in ipairs(lines) do
    love.graphics.printf(line, 0, startY + (i - 1) * 24, screenWidth, 'center')
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

  love.graphics.setColor(1, 1, 1)
  love.graphics.print('P: Pause/Controls', 10, 10)
  love.graphics.print('Deaths: ' .. player.deaths, 10, 30)

  if player.hasReachedGoal then
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Level Complete!', 0, 20, love.graphics.getWidth(), 'center')
  end

  if isPaused then
    drawPauseMenu()
  end
end
