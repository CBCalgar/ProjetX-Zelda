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








-- FOG & day/night cycle
local map_metatable = sol.main.get_metatable("map")


function map_metatable:start_day_night(start)
    local start=start or false
    if(start)then
      self.surface_nuit = nil
      self.surface_lumiere = nil
      self.animated = false
      local timer = sol.timer.start(self:get_game(), 1000, function()
        local time = self:get_game():get_value("time_played")        
        if(time==nil)then
         time=0
        end
          return self:display_day_or_night(self:get_game(),time)
      end)
    end
end

function map_metatable:display_day_or_night(game,time)
     -- on recupe le nombre de jours complet
     
    local time_updated=time*24
    local duree_jour=86400

    local time_du_jour=time_updated%duree_jour
    -- On prend le time du jour, et on le transforme en heure et en minute
    local duree_heure=3600
    
    local heure_du_jour=time_du_jour/duree_heure
    local heure_courante=math.floor(heure_du_jour)
    
    local minute_du_jour=time_du_jour%duree_heure
    --print(minute_du_jour)
    
    local duree_minute=60
    local minute_courante=math.floor(minute_du_jour/duree_minute)

    local mult = 10^(0)
    local minute_courante= math.floor((minute_du_jour/duree_minute) * mult + 0.5) / mult    
   

    -- On format l'heure et la minute sur deux chiffres
    local display_heure = tostring(string.format("%02d",heure_courante))
    local display_minute = tostring(string.format("%02d",minute_courante))
    
    
    -- on affiche dans l'horloge
    --print(heure_courante);
    
    if(heure_courante==0) and (minute_courante==2) and (self.animated==false) then
      -- on met la nuit
     self.animated=true     
     self.surface_nuit = sol.surface.create("fogs/night_2.png") 
     self.surface_nuit:set_opacity(10)   
     local surface_ecran = sol.surface.create(sol.video.get_quest_size())      
     local coord_x, coord_y = sol.video.get_quest_size()
     self.surface_nuit:draw(surface_ecran,0,0)
     self:fade_it("in",20)
      
       -- on allume les lumières
       
      --for k in self:get_entities() do
        --print(k:get_name())
      --end
      self.surface_lumiere = sol.surface.create("fogs/light.png") 
      self.surface_lumiere:set_opacity(255)   
      local surface_ecran = sol.surface.create(sol.video.get_quest_size())      
      local coord_x, coord_y = sol.video.get_quest_size()
      self.surface_lumiere:draw(surface_ecran,96,208)     
    end

    if(heure_courante==0) and (minute_courante==6) and (self.animated==false) then
      -- on met le jour
      self.animated=true     
      self.surface_nuit = sol.surface.create("fogs/night_2.png") 
      self.surface_nuit:set_opacity(200)   
      local surface_ecran = sol.surface.create(sol.video.get_quest_size())      
      local coord_x, coord_y = sol.video.get_quest_size()
      self.surface_nuit:draw(surface_ecran,0,0)
      self:fade_it("out",20)
      
    end


    return true
 -- display_day_or_night(time)
end

function map_metatable:fade_it(mode,step)
  local mode = mode or "in"
  local step = step or 5
  local max_opacity=200
  
  local pas = math.floor(max_opacity/step)  

  if(mode=="in") then
      local start=0
      local current_opacity = start

      local timer = sol.timer.start(self:get_game(), 250, function()
          print(current_opacity)
          print(max_opacity)          
          if(current_opacity<=max_opacity)then
                self.surface_nuit:set_opacity(current_opacity)  
                current_opacity = current_opacity + pas
                return true
          end
          self.surface_nuit:set_opacity(200)  
          self.animated=false
          return false
      end)
  end
  if(mode=="out") then
      local start=200
      local current_opacity = start

      local timer = sol.timer.start(self:get_game(), 250, function()
          if(current_opacity>=0)then
                self.surface_nuit:set_opacity(current_opacity)  
                current_opacity = current_opacity - pas
                return true
          end
          self.surface_nuit:set_opacity(0)  
          self.animated=false
          return false
      end)
  end
end

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
        -- cas ou on veut afficher la nuit ou le jour
       if self.surface_nuit ~= nil then
         --print(self.surface_nuit).get_size()
          --print('ici')         
          self.surface_nuit:draw(dst_surface, 0, 0)
          --self.surface_lumiere:set_blend_mode("multiply")
          self.surface_lumiere:draw(dst_surface,96,208)
       end
end
 
  function map_metatable:on_finished()
        self:get_game():set_value("current_fog", nil)
  end

return game_manager

