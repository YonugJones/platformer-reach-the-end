return {
  spawnX       = 20,
  spawnY       = 340,
  platforms    = {
    -- floor --
    { x = -620, y = -100, w = 120,  h = 640 }, -- left-most wall --
    { x = -500, y = 400,  w = 1300, h = 140 },
    { x = 1100, y = 400,  w = 100,  h = 40 },
    { x = 1400, y = 300,  w = 100,  h = 40 },
    { x = 1700, y = 200,  w = 100,  h = 40 },
    { x = 2300, y = 400,  w = 100,  h = 40 },
    { x = 2700, y = 200,  w = 20,   h = 100 },
    { x = 3300, y = 400,  w = 100,  h = 40 }
  },
  hazards      = {
    { x = 2700, y = 190, w = 20, h = 20 }
  },
  checkpoints  = {
    { x = 3350, y = 360, w = 10, h = 40 }
  },
  cameraBounds = { minX = 0, maxX = 5600 },
}
