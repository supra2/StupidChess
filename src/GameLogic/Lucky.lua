Lucky = Class{'CharacterClass'}


function Lucky:init( character )
    self.name = 'Lucky'
    self.character = character
end

function Lucky:onStartTurn( board , tiledrawn ) 

    local safeTiles = {}
    local tileAround =  board:getTilesAround( self.character.tile.position )
    for i = 1 , #tileAround do
        if tileAround[i] ~= tiledrawn  and tileAround[i].inPlay  and  
         tileAround[i].highlighted ~= true and tileAround[i]:available()  then
            table.insert( safeTiles , tileAround[i] )
        end
    end 
    if #safeTiles ~=0  then
        safeTiles[math.random(1,#safeTiles)]:highlightAsSafe(true)
    end
end