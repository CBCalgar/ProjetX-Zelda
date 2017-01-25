-- This script initializes game values for a new savegame file.
-- You should modify the initialize_new_savegame() function below
-- to set values like the initial life and equipment
-- as well as the starting location.
--
-- Usage:
-- local initial_game = require("scripts/initial_game")
-- initial_game:initialize_new_savegame(game)



local relation_manager = {}

-- Sets initial values to a new savegame file.
function relation_manager:add_xp(game,value,npc)
  local variable_name="xp_" .. npc:get_name():lower()
  local next_xp=0;  
  local current_xp = game:get_value(variable_name)
  
  next_xp=current_xp+value;
  game:set_value(variable_name,next_xp) 
  return next_xp;
end

return relation_manager
