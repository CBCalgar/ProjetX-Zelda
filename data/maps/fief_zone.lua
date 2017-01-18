-- Lua script of map fief_zone.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function Violette:on_interaction()
local local_xp_violette=game:get_value("xp_violette");
      game:set_value("xp_violette",local_xp_violette+10)      
      print(local_xp_violette)

 game:start_dialog("dialogue.violette", function (answer)

      if(answer==3) then -- NO
        game:start_dialog("dialogue.violette_triste")
      else -- yes
        game:start_dialog("dialogue.violette")
      end
  end)
end