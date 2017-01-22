local item = ...
local game = item:get_game()

function item:on_created()

  self:set_savegame_variable("i1102")
  self:set_amount_savegame_variable("i1025")
  self:set_assignable(true)
end

function item:on_using()

  local map = game:get_map()
  local hero = map:get_hero()

  hero:set_animation("rateau", function()
    hero:unfreeze()
    --rateau:remove()
  end)


end


function item:on_obtaining(variant, savegame_variable)

 game:get_item("rateau"):set_variant(1)
 game:set_item_assigned(1,game:get_item("rateau"))  
end
