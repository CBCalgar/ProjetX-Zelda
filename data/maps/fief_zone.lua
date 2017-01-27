-- Lua script of map fief_zone.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest
local dialog_box_manager = require("scripts/dialog_box")
local relation_manager = require("scripts/relation_manager")
local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
  map:display_fog("overworld_smallcloud", speed, angle, opacity)

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
function Violette:on_interaction()
     
     local xp_value=relation_manager:add_xp(game,10,Violette)
    
     dialog_box:set_xp_value(xp_value) 
     dialog_box:set_npc_value(Violette) 
     game:start_dialog("dialogue.violette", function (answer)

      if(answer==3) then -- NO
       dialog_box:set_xp_value(xp_value) 
       dialog_box:set_npc_value(Violette)        
       game:start_dialog("dialogue.violette_triste")
      else -- yes
       dialog_box:set_xp_value(xp_value) 
       dialog_box:set_npc_value(Violette)
       game:start_dialog("dialogue.violette")
      end
  end)
end