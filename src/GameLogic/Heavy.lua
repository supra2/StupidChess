Heavy = Class{'CharacterClass'}

function Heavy:init (character )
    self.name = 'Heavy'
    self.character = character
end

function Heavy:onStartTurn( board , tiledrawn ) 
end

function Heavy:GetStrength( board )
    local adjacent_tiles = 
    board:getTilesAround( self.character.tile.position ) 

    local strength = 1
    for  i = 1, #adjacent_tiles do
        if adjacent_tiles[i].character ~= nil and
           adjacent_tiles[i].character.className== 'Heavy' 
            and self.character.teamNumber ==
             adjacent_tiles[i].character.teamNumber then
                strength = strength + 1 
        end
    end
    return strength;
end