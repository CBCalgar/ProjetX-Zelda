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
 
 -- Detect enemies with an invisible custom entity.
  local x, y, layer = hero:get_position()
  local direction4 = hero:get_direction()
  if direction4 == 0 then x = x + 12
  elseif direction4 == 1 then y = y - 12
  elseif direction4 == 2 then x = x - 12
  else y = y + 12
  end

  local rateau = map:create_custom_entity{
    x = x,
    y = y,
    layer = layer,
    width = 8,
    height = 8,
    direction = 0,
  }
  local entities_touched = { }
  rateau:set_origin(4, 5)
  rateau:add_collision_test("overlapping", function(rateau, entity)
  if( entity:get_sprite()~=nil) then
    
    local nom_sprite = entity:get_sprite():get_animation()
    if(nom_sprite == "on_ground")then
        local coords_x, coords_y, coords_layer = entity:get_position()
        local brush_explosed = map:create_custom_entity{
          x = coords_x,
          y = coords_y,
          layer = layer,
          width = 8,
          height = 8,
          direction = 0,
        }   
        -- on affiche l'animation de destruction      
        local brush_sprite= brush_explosed:create_sprite("entities/bush_green")
        brush_sprite:set_animation("destroy")
        -- on remove le sprite du brush
        entity:remove()

    end  
  end
end)


  hero:set_animation("rateau", function()
    hero:unfreeze()
    --rateau:remove()
  end)


end


function item:on_obtaining(variant, savegame_variable)

 game:get_item("rateau"):set_variant(1)
 game:set_item_assigned(1,game:get_item("rateau"))  
end
