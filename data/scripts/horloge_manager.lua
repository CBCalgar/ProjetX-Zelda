local horloge_manager = {}  

-- Creates a clock object
function horloge_manager:create(game)
  local timer = sol.timer.start(game, 1000, function()
        local time = game:get_value("time_played")
        if(time==nil)then
         time=0
        end

      
        time = time + 1
        game:set_value("time_played", time)
        
        return true  -- Repeat the timer.
        end)
  timer:set_suspended_with_map(false)

 
end



return horloge_manager