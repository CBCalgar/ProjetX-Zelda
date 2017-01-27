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
  print(game:get_value(variable_name))
  return next_xp;
end

-- retourne le niveau d'xp
function relation_manager:get_xp_bar(game,npc)

  local xp_default = 1000;
  local xp_hated_cap = 1000;
  local xp_neutral_cap = 1100
  local xp_friendly_cap = 1600;
  local xp_exalted_cap = 3500;
  
  local xp = {}

  local variable_name="xp_" .. npc:get_name():lower()
  local current_xp = game:get_value(variable_name)
  
  print('current_xp'..current_xp)


  -- Si xp toute nouvelle
  if(current_xp==nil)then
    current_xp=xp_default;
  end
  
  print('current_xp'..current_xp)

  -- réputation au délà d'exalté avec ce npc  
  if(current_xp>=xp_exalted_cap) then
    local diff=current_xp-xp_exalted_cap
    xp[0]="xp_evo_3.png"
    xp[1]="1"

  end
 
  -- réputation friendly
  if(current_xp<xp_exalted_cap) and (current_xp>=xp_friendly_cap) then
    local diff=current_xp-xp_friendly_cap
    local diff_exalted=xp_exalted_cap-xp_friendly_cap
    local percent = diff_exalted / diff
    xp[0]="xp_evo_2.png"
    xp[1]=percent

  end

  -- réputation neutre
  if(current_xp<xp_friendly_cap)and(current_xp>=xp_neutral_cap) then
    local diff=current_xp-xp_neutral_cap
    local diff_exalted=xp_exalted_cap-xp_neutral_cap
    local percent = diff_exalted / diff
    xp[0]="xp_evo_1.png"
    xp[1]=percent

  end  

  -- réputation hated
  if(current_xp<xp_neutral_cap) then
    local diff=current_xp
    local diff_exalted=xp_neutral_cap
    local percent = diff_exalted / diff
    
    print('hated '..percent)
    xp[0]="xp_evo_0.png"
    xp[1]=percent

  end  
  
  return xp
end

return relation_manager
