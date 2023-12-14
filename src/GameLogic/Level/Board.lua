Board = Class{}

function Board:init( params)
   self.width  =  params.level_width
   self.height =  params.level_height
   self.position = Vector2D( VIRTUAL_WIDTH/4 , VIRTUAL_HEIGHT/8 )
   self.levelData = params.levelData
   self.tiles = {}
   for i = 1,self.height do
      self.tiles[i] = {}
    for j = 1,self.width do
      tileType = self.levelData[i][j]
      self.tiles[i][j] = Tile( j  , i , 
      tileType , self )
    end
 end

end

function Board:getTileClicked( clickposition , selectabletiles , selectedCharacter )
   local tileclicked = self:clickTile( clickposition , selectabletiles )
   if tileclicked ~= nil then
      selectedCharacter:move( tileclicked )
      return true
   end

   return false

end

function Board:clickTile( clickposition , selectabletiles )
    local clickmap = Tile.isoTo2D( clickposition - self.position + Vector2D(-TILE_WIDTH/2 ,0  ))
    local tileclicked = nil
   for i = 1,self.height do
      for j = 1,self.width do 
         if clickmap.x >  j and clickmap.x <  j +1  and
            clickmap.y >  i and clickmap.y <  i +1  
         and contains( selectabletiles , self.tiles[i][j] ) then
            tileclicked = self.tiles[i][j]
         end
      end
   end
   return tileclicked
end

function Board:update(dt)
   for y= 1, #self.tiles do
      for x= 1, #self.tiles[y] do
         if self.tiles[y][x] ~= nil then 
         self.tiles[y][x]:update(dt)
         end
      end
   end
end

function Board:draw()
   for y= 1, #self.tiles do
      for x= 1, #self.tiles[y] do
         self.tiles[y][x]:draw(self.position)
         if self.tiles[y][x] == self.tileclicked then
            love.graphics.draw( gTextures['pointer'],
            (self.position + Tile.twoDToIso( self.tiles[y][x].position )).x + 45 ,
            (self.position + Tile.twoDToIso( self.tiles[y][x].position )).y + 20 )
         end
      end
   end

end

function Board:getTilesAround( position )
   local adjacent_tiles={}
   for i = -1 ,1 do 
      for j = -1 ,1 do 
         if i ~=0 or j~=0 then 
            if position.x + i  > 0    and 
               position.y + j  > 1 and
               position.y + j  < #self.tiles  and 
               position.x + i  < #self.tiles[position.y+j]  then 
                  if self.tiles[position.y + j][position.x + i].inPlay then 
                    table.insert( adjacent_tiles , self.tiles[position.y + j][position.x + i])
                  end
            end
         end
      end
   end
   return adjacent_tiles

end

function Board:getTilesAvailable( position )
  local accessibleTiles = {}
  if position.y > 1  and self.tiles[position.y -1][position.x]:available()  then 
      table.insert(accessibleTiles ,self.tiles[position.y -1][position.x])
  end

  if position.x > 1  and self.tiles[position.y][position.x-1]:available() then 
      table.insert(accessibleTiles , self.tiles[position.y][position.x-1])
  end

  if position.x < #self.tiles[position.y]  then 
      if self.tiles[position.y ][ position.x +1]:available( ) then 
          table.insert( accessibleTiles  , self.tiles[position.y][position.x +1] )
      end
  end
  if position.y < #self.tiles  and self.tiles[position.y+1 ][position.x]:available() then 
      table.insert( accessibleTiles , self.tiles[position.y+1][position.x])
  end 
  return accessibleTiles
end