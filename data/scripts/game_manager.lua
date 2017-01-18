local game_manager = {}

local initial_game = require("scripts/initial_game")


--local hud_manager = require("scripts/hud/hud")
--local equipment_manager = require("scripts/equipment")



sol.language.set_language("fr")

-- Starts the game from the given savegame file,
-- initializing it if necessary.
function game_manager:start_game(file_name)

  local exists = sol.game.exists(file_name)
  local game = sol.game.load(file_name)
  if not exists then
    -- Initialize a new savegame.
    initial_game:initialize_new_savegame(game)
  end
  if game:get_value("xp_violette") == nil then
    game:set_value("xp_violette",0)
  end

  game:start()

  -- Function called when the player runs this game.


  function game:on_started()
    --equipment_manager:create(game)
    --hud = hud_manager:create(game)
  end


function game:on_paused()
  game:start_dialog("ui.save",function(answer)
    if(answer==2) then
      game:save()
      game:set_paused(false);
    end
  end)
end


end



return game_manager

