Team = Class{} 


function Team:init( characters ,  teamNumber )
    self.characters = characters
    self.teamNumber = teamNumber
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}}
end

function Team:draw(  )
    love.graphics.setColor( self.colors[ self.teamNumber] )
    for k,character in ipairs(self.characters) do
        character:draw()
    end
    love.graphics.setColor({1,1, 1, 1})
end