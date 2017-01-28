-- Hearts view used in game screen and in the savegames selection screen.

local horloge_builder = {}

local horloge_img = sol.surface.create("hud/hud_horloge.png")

function horloge_builder:new(game, config)

  local horloge = {}
  horloge.txt1=nil
  horloge.txt2=nil
  horloge.txt3=nil
  horloge.txt4=nil
  horloge.speed = 24
  horloge.surface = sol.surface.create(sol.video.get_quest_size())
  horloge.dst_x = config.x
  horloge.dst_y = config.y
  horloge.time_played = game:get_value("time_played")
  print( game:get_value("time_played"))



  function horloge:rebuild_surface()

    horloge.surface:clear()
    horloge_img:draw_region(0, 0, 70  , 43, horloge.surface,0, 0)   
    local surface1 = sol.text_surface.create{
          horizontal_alignment = "left",
          vertical_alignment = "top",
          font = "minecraftia",
          font_size = "10",
          color = {255,235,205},
          text = horloge.txt1,
        }
        local txt_width,txt_height = horloge.surface:get_size()
           
        local decal = math.floor((14-txt_width)/2)              
        surface1:draw(horloge.surface,11,18)  
    local surface1 = sol.text_surface.create{
          horizontal_alignment = "left",
          vertical_alignment = "top",
          font = "minecraftia",
          font_size = "10",
          color = {255,235,205},
          text = horloge.txt2,
   oHI     }
        local txt_width,txt_height = horloge.surface:get_size()
           
        local decal = math.floor((14-txt_width)/2)              
        surface1:draw(horloge.surface,24,18)       
    local surface1 = sol.text_surface.create{
          horizontal_alignment = "left",
          vertical_alignment = "top",
          font = "minecraftia",
          font_size = "10",
          color = {255,235,205},
          text = horloge.txt3,
        }
        local txt_width,txt_height = horloge.surface:get_size()
           
        local decal = math.floor((14-txt_width)/2)              
        surface1:draw(horloge.surface,40,18)      
    local surface1 = sol.text_surface.create{
          horizontal_alignment = "left",
          vertical_alignment = "top",
          font = "minecraftia",
          font_size = "10",
          color = {255,235,205},
          text = horloge.txt4,
        }
        local txt_width,txt_height = horloge.surface:get_size()
           
        local decal = math.floor((14-txt_width)/2)              
        surface1:draw(horloge.surface,53,18)    
  end

  function horloge:on_draw(dst_surface)

    local x, y = horloge.dst_x, horloge.dst_y
    local width, height = dst_surface:get_size()
    if x < 0 then
      x = width + x
    end
    if y < 0 then
      y = height + y
    end  

    horloge.surface:draw(dst_surface, x, y )
  end

  -- Checks whether the view displays correct information
  -- and updates it if necessary.
  local function check()

    local need_rebuild = false
    
    local current_time = game:get_value("time_played")
   -- print(horloge.time_played)
    if(horloge.time_played ~= current_time)then
        horloge.time_played = current_time
        horloge:computeTime(current_time)
    end
    horloge:rebuild_surface()
    return true  -- Repeat the timer.
  end
  
  -- TEMPS EXPRIME EN SECONDE
  function horloge:computeTime(time)
    
    
    

     -- on recupe le nombre de jours complet
    local time_updated=time*horloge.speed
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

    
    horloge.txt1 = string.sub(display_heure, 0, 1)
    horloge.txt2 = string.sub(display_heure, 2, 3)
    horloge.txt3 = string.sub(display_minute, 0, 1)
    horloge.txt4 = string.sub(display_minute, 2, 3)

   
  end

  function horloge:on_started()

    -- This function is called when the HUD starts or
    -- was disabled and gets enabled again.
    -- Unlike other HUD elements, the timers were canceled because they
    -- are attached to the menu and not to the game
    -- (this is because the hearts may also be used in the savegame menu).
    horloge.danger_sound_timer = nil
    -- Periodically check.
    check()
    sol.timer.start(horloge, 50, check)
    horloge:rebuild_surface()
  end

  return horloge
end

return horloge_builder
