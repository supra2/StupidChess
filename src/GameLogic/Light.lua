Light = Class{'CharacterClass'}

function Light:init(Character)
    self.character = Character
    self.name ='Light'
end


function Light:onDestroyed(_playState)
  if _playState.moveAvailable > 0 then
   local accessibleTiles = _playState.board:GetAccessibleTiles( )
    if #accessibleTiles>0 then 
        self.character:move( accessibleTiles[math.random(1,#accessibleTiles)] )
        _playState.moveAvailable = _playState.moveAvailable-1
    end
  end
end