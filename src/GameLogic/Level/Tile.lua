Tile = Class{}

function Tile:init( x , y , symbol , board )
    
    self.position = Vector2D( x , y )
    self.symbol = symbol
    self.inPlay = true
    self.board = board
    self.dt =0
    self.blinking = false
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

function Tile:update( dt )
    if  not  self.character  == nil  then
        self.character:update( dt )
    end
end

function Tile:draw (  )
    if  not self.inPlay then return end
    love.graphics.setShader( self.shader )
    local tiles = 'tile'

    if self.blinking  then
    
        tiles ='selected'
    end

    if  self.highlighted then
        love.graphics.print('highlighted',gFonts['normal'],VIRTUAL_WIDTH/2,50)
        love.graphics.setShader(self.shader) 
        self.shader:send("WhiteFactor", math.sin( 10 * self.dt  )/3)
    end

    love.graphics.draw(  gTextures[tiles] , 
    self.board.position.x +  Tile.twoDToIso(  self.position).x ,
    self.board.position.y +  Tile.twoDToIso( self.position).y )

    love.graphics.setShader()

    love.graphics.draw(  gTextures['symbol'] ,gFrames['symbol'][self.symbol],
    self.board.position.x +  Tile.twoDToIso(  self.position).x ,
    self.board.position.y +  Tile.twoDToIso( self.position).y )
    
end

function Tile:destroyTile()
    if  self.character ~= nil then
        self.character:fall()
    end 
    self.inPlay = false
    self.highlighted = false
    self.blinking = false
end

function Tile.isoTo2D(pt)
   tempPt = Vector2D(0, 0)
   tempPt.x =( pt.y/(TILE_HEIGHT/2) + pt.x / (TILE_WIDTH/2))/2
   tempPt.y =( pt.y/(TILE_HEIGHT/2) - pt.x/ ( TILE_WIDTH/2))/2
   return( tempPt );
end

function Tile.twoDToIso(pt)
   tempPt = Vector2D(0,0);
   tempPt.x = pt.x *TILE_WIDTH/2 - pt.y *TILE_WIDTH/2;
   tempPt.y = pt.x *TILE_HEIGHT/2 + pt.y*TILE_HEIGHT/2;
   return(tempPt);
end

function Tile:available()
    return self.inPlay and self.character  == nil
 end


 function Tile:blink( blink )
    self.blinking =  blink
  
end

function Tile:highlightAsSafe( highlightAsSafe )
    self.highlighted = highlightAsSafe
    if self.highlighted then
        dt = 0
    end
end
function Tile:blink( blink  )
    self.blinking = blink
end
