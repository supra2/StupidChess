Character = Class{}

function Character:init( skin , class , teamNumber )

    if class== 'Lucky' then 
        self.class = Lucky(self)
    end
    if class== 'Heavy' then 
        self.class = Heavy(self)
    end 
    if class == 'Light' then 
        self.class = Light(self)
    end 
    self.className =  class
    self.skin = skin
    self.position = Vector2D(0,0)
    self.state = 'idle'
    self.currentFrame = 1
    self.direction  = 1
    self.displayOffset = Vector2D( 0, -128 )
    self.velocity = 100
    self.teamNumber = teamNumber
    self.alive = true
    self.shader = love.graphics.newShader[[
        extern float WhiteFactor;
        
        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
        ]]
end

function Character:setTile( _tile )
    if self.tile then  self.tile.character = nil end
    self.tile = _tile
    self.tile.character = self
end

function Character:GetWordPosition(  )
    return Tile.twoDToIso( self.tile.position ) + self.position +
     self.tile.board.position + self.displayOffset
end

function Character:SetWordPosition( newPosition )
    self.position =   newPosition  - ( Tile.twoDToIso( self.tile.position ) 
    + self.tile.board.position + self.displayOffset)
end

function Character:updateOrientation()
    angle = angleOfPoint( self.speed )
    i =  angle % 45 
    if i == 0 then  self.direction  = 2 end
    if i == 1 then  self.direction  = 1 end
    if i == 2 then  self.direction  = 8 end
    if i == 3 then  self.direction  = 7 end
    if i == 4 then  self.direction  = 6 end
    if i == 5 then  self.direction  = 5 end
    if i == 6 then  self.direction  = 4 end
    if i == 7 then  self.direction  = 3 end
end

function Character:update( dt )
    if self.blinking then
    self.dt =  self.dt + dt
    end
end

function Character:move( tile )
    self.state = 'run'
    local dir = tile.position - self.tile.position
    if dir.x == -1 then
        self.direction = 7
    end
    if dir.x == 1 then
        self.direction = 3
    end
    if dir.y == -1 then
        self.direction = 1
    end
    if dir.y == 1 then
       self.direction = 5
    end
    self.blinktween  = Timer.every( 0.1 , function()  self.currentFrame = ( self.currentFrame + 1) %
        (#gTextures['character'][self.direction][self.state] - 1 ) + 1  end ):limit(10):finish( function() self.currentFrame = 1 end)
    self.movementTween  = Timer.tween( 1 ,  
    { [self.position] = {  x = (  Tile.twoDToIso( dir)).x,
                           y =  ( Tile.twoDToIso( dir)).y }
    } ):finish( function() if self == nil  then return end self:setTile(tile)  self.position = Vector2D(0,0) 
                   self.state ='idle' self.currentFrame = 1
         end )
      
end

function Character:blink( blink , timer )
    self.blinking = blink
    if not blink then
    else
        self.dt  = 0
    end
end

function Character:fall()
    self.alive = false
    if self.blinktween then  self.blinktween:remove() end 
    if self.movementTween  then self.movementTween:remove()  end
      self.TimermovementTween  = Timer.tween( 3 ,  { [self.position] = {  y =  VIRTUAL_WIDTH }} )
end

function Character:draw(  )

    if  self.alive then 

        displayPosition = self.position +
        Tile.twoDToIso( self.tile.position ) +
        self.displayOffset + self.tile.board.position

        if  self.blinking then 
            love.graphics.setShader(self.shader) 
            self.shader:send("WhiteFactor", math.sin( 10 * self.dt  )/3)
        end

        love.graphics.print( self.className, gFonts['normal'], displayPosition.x  + 128 , displayPosition.y +30)
        love.graphics.draw( gTextures['character'][self.direction][self.state][self.currentFrame],
        getCharacterQuad(gTextures['character'][self.direction][self.state][self.currentFrame]),
        displayPosition.x  , displayPosition.y )
        love.graphics.setShader()
    end
end

function Character:pushable( strength , Board )

    --todo check pushability
    local tiles = Board:getTilesAround(self.position)
    local counterstrength = 0
    if self.className =='Heavy' then
        counterstrength = counterstrength + 1
    end
    for  i = 1,#tiles do
       if  tiles.character.className =='Heavy' and tiles.character.teamNumber == self.teamNumber then
        counterstrength = counterstrength + 1
       end
    end
    return strength > counterstrength
end