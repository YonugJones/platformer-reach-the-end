_G.love        = require 'love'
local Player   = require 'player'
local Camera   = require 'camera'
-- local level    = require 'levels.level1'

local player
local camera
local level
local isPaused = false
local timer    = 0

local function formatTime(t)
  local minutes = math.floor(t / 60)
  local seconds = t % 60
  return string.format('%02d:%05.2f', minutes, seconds)
end

local function loadLevel(levelPath)
  local previousDeaths = player and player.deaths or 0

  level = require(levelPath)
  player = Player.new(level.spawnX, level.spawnY)
  camera = Camera.new()

  player.deaths = previousDeaths
end

function love.load()
  loadLevel('levels.level1')
end

function love.update(dt)
  if isPaused then return end

  if player.hasReachedGoal then
    if level.nextLevel then
      loadLevel(level.nextLevel)
    end
    return
  end

  timer = timer + dt

  local moveAmount = Player.update(
    player,
    dt,
    level.platforms,
    level.hazards,
    level.goal,
    level.checkpoints,
    level.exits
  )
  Camera.update(camera, dt, player, moveAmount, level.cameraBounds)

  if player.triggeredExit then
    loadLevel(player.triggeredExit.target)
  end
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
  Player.keyreleased(player, key)
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
  if level.platforms then
    love.graphics.setColor(0.3, 0.7, 0.3)
    for _, plat in ipairs(level.platforms) do
      love.graphics.rectangle('fill', plat.x, plat.y, plat.w, plat.h)
    end
  end

  -- draw hazards --
  if level.hazards then
    love.graphics.setColor(0.9, 0.2, 0.2)
    for _, hz in ipairs(level.hazards) do
      love.graphics.rectangle('fill', hz.x, hz.y, hz.w, hz.h)
    end
  end

  -- draw checkpoints --
  if level.checkpoints then
    for _, cp in ipairs(level.checkpoints) do
      love.graphics.setColor(0.3, 0.5, 1)
      love.graphics.rectangle('fill', cp.x, cp.y, cp.w, cp.h)
    end
  end

  -- draw goal --
  if level.goal then
    love.graphics.setColor(1, 0.85, 0.2)
    love.graphics.rectangle('fill', level.goal.x, level.goal.y, level.goal.w, level.goal.h)
  end

  Player.draw(player)
  Camera.detach()

  love.graphics.setColor(1, 1, 1)
  love.graphics.print('P: Pause/Controls', 10, 10)
  love.graphics.print('Deaths: ' .. player.deaths, 10, 30)
  love.graphics.print('Time: ' .. formatTime(timer), 10, 50)

  if player.hasReachedGoal then
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Level Complete!', 0, 20, love.graphics.getWidth(), 'center')
  end

  if isPaused then
    drawPauseMenu()
  end
end
