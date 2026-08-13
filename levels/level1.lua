return {
  spawnX       = 20,
  spawnY       = 340,
  platforms    = {
    -- floor --
    { x = -500, y = 400,  w = 1300, h = 140 },
    { x = -620, y = -100, w = 120,  h = 640 }, -- left-most wall --
    { x = 1000, y = 400,  w = 800,  h = 140 },
    { x = 2100, y = 400,  w = 800,  h = 140 },
    { x = 3300, y = 400,  w = 800,  h = 140 },
    { x = 5700, y = 500,  w = 300,  h = 80 },  -- secret path --
    { x = 6180, y = -100, w = 120,  h = 640 }, -- right-most wall --
    -- floating --
    { x = 4400, y = 200,  w = 50,   h = 80 },
    { x = 4800, y = 100,  w = 50,   h = 80 },
    { x = 5200, y = 0,    w = 50,   h = 80 },
    { x = 5500, y = 200,  w = 800,  h = 80 }
  },
  hazards      = {
    { x = 4100, y = 500, w = 1600, h = 100 }
  },
  checkpoints  = {
    { x = 3700, y = 200, w = 40, h = 80 }
  },
  goal         = { x = 6000, y = 100, w = 40, h = 50 },
  cameraBounds = { minX = 0, maxX = 5600 }
}
