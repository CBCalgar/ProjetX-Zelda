local game_manager = {}

local initial_game = require("scripts/initial_game")
local dialog_box_manager = require("scripts/dialog_box")
local relation_manager = require("scripts/relation_manager")
local horloge_manager = require("scripts/horloge_manager")


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

  horloge = horloge_manager:create(game)
 

end








-- FOG
local map_metatable = sol.main.get_metatable("map")
function map_metatable:display_fog(fog, speed, angle, opacity)
   local  fog = fog or nil
        local speed = speed or 1
        local angle = angle or 0
        local opacity = opacity or 80
        
        if type(fog) == "string" then
        
          self.fog = sol.surface.create("fogs/"..fog..".png")
      self.fog:set_opacity(opacity)
          self.fog_size_x, self.fog_size_y = self.fog:get_size()
      self.fog_m = sol.movement.create("straight")
          
          function restart_overlay_movement()
                self.fog_m:set_speed(speed) 
                self.fog_m:set_max_distance(self.fog_size_x)
                self.fog_m:set_angle(angle * math.pi / 4)
                self.fog_m:start(self.fog, function()
                        restart_overlay_movement()
                        self.fog:set_xy(0,0)
                end)
      end
          restart_overlay_movement()
        
        self:get_game():set_value("current_fog", fog)
     end
  end
  
  function map_metatable:get_current_fog()
    return self:get_game():get_value("current_fog")
  end
 
  function map_metatable:on_draw(dst_surface)
        local scr_x, scr_y = dst_surface:get_size()
        if self:get_current_fog() ~= nil then
          local camera_x, camera_y = self:get_camera_position()
          local overlay_width, overlay_height = self.fog:get_size()
          local x, y = camera_x, camera_y
          x, y = -math.floor(x), -math.floor(y)
          x = x % overlay_width - 4 * overlay_width
          y = y % overlay_height - 4 * overlay_height
          local dst_y = y
          while dst_y < scr_y + overlay_height do
                local dst_x = x
                while dst_x < scr_x + overlay_width do
                  self.fog:draw(dst_surface, dst_x, dst_y)
                  dst_x = dst_x + overlay_width
                end
                dst_y = dst_y + overlay_height
          end
        end
end
 
  function map_metatable:on_finished()
        self:get_game():set_value("current_fog", nil)
  end

return game_manager

