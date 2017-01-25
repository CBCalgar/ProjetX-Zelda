local game_manager = {}

local initial_game = require("scripts/initial_game")
local dialog_box_manager = require("scripts/dialog_box")
local relation_manager = require("scripts/relation_manager")


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
  game:start()
  dialog_box = dialog_box_manager:create(game)
  --local item = game:get_item("boomerang")
  --game:set_item_assigned(1, item)


 --game:get_item("rateau"):set_variant(1)
-- game:set_item_assigned(1,game:get_item("rateau"))



 --game:get_item("boomerang"):set_variant(1)
 --game:set_item_assigned(1,game:get_item("boomerang"))
end

return game_manager

