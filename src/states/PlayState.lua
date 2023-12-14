PlayState = Class{'BaseState'}

function PlayState:init()
 
end

function PlayState:enter( params )
    self.board = Board( params )
    self.teams = {}
    for i = 1 , params.nbTeams do
        self.teams[i] = Team( {Character(1,'Lucky'),Character(2,'Heavy') } , i )
    end
    self.teams[1].player = true
    self.teams[1].characters[1]:setTile( self.board.tiles[1][1]  )
    self.teams[1].characters[2]:setTile( self.board.tiles[2][1]  )

    self.teams[2].characters[1]:setTile( self.board.tiles[3][2]  )
    self.teams[2].characters[2]:setTile( self.board.tiles[3][1]  )
    self:StartTurn()
    self.ui = UI()
end

function PlayState:update( dt)
   -- if click
   if self.mode == 'moving' then 
        if clicked and self.moveAvailable > 0 then
            local tileClicked = self.board:clickTile( mouseLeftClick , self.accessibletiles )
            if tileClicked ~= nil and 
              self.selectedCharacter.className == 'Heavy' and  
              tileClicked.character ~= nil then
                self.mode = 'pushing' 
                self.pushedCharacter =  tileClicked.character 
                self.accessibletiles =  self.board:getTilesAvailable(  self.pushedCharacter.tile.position )
                clicked = false
            else
                if self.board:getTileClicked( mouseLeftClick , self.accessibletiles , self.selectedCharacter ) then
                    self.moveAvailable = self.moveAvailable - 1
                    self:nextStep()
                end
            end
        end
    end
    if self.mode == 'pushing' then 
        if clicked  and  self.moveAvailable  > 0  then 
            local tileClicked = self.board:clickTile( mouseLeftClick , self.accessibletiles )
            if tileClicked ~= nil then
                    movetile = self.pushedCharacter.tile
                    self.selectedCharacter:move( movetile )
                    self.pushedCharacter:move( tileClicked )
                    self.moveAvailable = self.moveAvailable - 1
                    clicked = false
                    self:nextStep()
            end
       end
    end
   
    if clicked then
        self:clickCharacter( mouseLeftClick )
        clicked =false
    end
    
   self.board:update(dt)
   for i = 1,#self.teams do
    for j = 1,#self.teams[i].characters do
        self.teams[ i].characters[j]:update( dt )
    end 
   end

   if self.accessibletiles ~= nil then

    for y = 1 , #self.board.tiles do
        for x= 1, #self.board.tiles[y]  do
                self.board.tiles[y][x]:blink(
                    contains( self.accessibletiles ,self.board.tiles[y][x] )) 
            end
        end
    end
end

function PlayState:nextStep()
    for i = 1,#self.teams[self.currentTeam].characters do
            self.teams[self.currentTeam].characters[i]:blink( false )
    end
    if self.currentTeam ==  #self.teams then
        self:endTurn()
    else
    self:teamTurn( self.currentTeam +1 )
    end
end

function PlayState:updateTeam()
    local toRemove ={ }
    for i,charac in ipairs(self.teams[self.currentTeam].characters ) do
        if  charac.alive == false then

            table.insert( toRemove , self.teams[self.currentTeam].characters)
        end
    end
    for i,charac in ipairs(toRemove ) do
        table.remove( self.teams[self.currentTeam].characters , FindIndex(self.teams[self.currentTeam].characters , charac) )
    end
    if #self.teams[self.currentTeam].characters == 0 then

        if self.teams[self.currentTeam].player then
                gStateMachine:change('gameover')
        end 
        table.remove( self.teams , self.currentTeam )
    end
end

function PlayState:render( )
    self.board:draw()
    for j = 1 , #self.teams do 
      self.teams[j]:draw()
    end
    self.ui:draw()
end

function PlayState:clickCharacter( mouseLeftClick )
    for i ,charac in ipairs(self.teams[self.currentTeam].characters) do
      if    charac:GetWordPosition().x <  mouseLeftClick.x and
            charac:GetWordPosition().x + 256 > mouseLeftClick.x and
            charac:GetWordPosition().y <  mouseLeftClick.y and
            charac:GetWordPosition().y + 256 >  mouseLeftClick.y then
                self:pickCharacter( charac )
                break
        end
    end
end

function PlayState:pickCharacter( character )
    self.selectedCharacter  = character
    self.mode ='moving'
    self.accessibletiles = self.board:getTilesAvailable(
        self.selectedCharacter.tile.position )
    
    if self.selectedCharacter.className == 'Heavy' then 
        local strength = self.selectedCharacter.class:GetStrength( self.board )
        local tilesAround = self.board:getTilesAround( self.selectedCharacter.tile.position )
        for i = 1, #tilesAround do
            if ( self.selectedCharacter.position - tilesAround[i].position ):magnitude() -1 < 0.00001 and 
                tilesAround[i].character ~= nil then
                 if #self.board:getTilesAvailable( tilesAround[i].character.tile.position ) > 0 and
                  tilesAround[i].character:pushable( strength , self.board ) then 
                    table.insert( self.accessibletiles ,  tilesAround[i]  )
                 end
            end
        end
    end
end

function PlayState:teamTurn( index  )
    self.moveAvailable = 1
    for j , charac in ipairs( self.teams[index].characters )  do
        charac:blink(true,0.1) 
        charac.class:onStartTurn( self.board , self.tilePicked  )
    end
    self.selectedCharacter = nil
    self.currentTeam = index
    self.mode = 'selecting'
end

function PlayState:StartTurn( )
    local availableTiles = {}
    if self.board.tiles[1][1] ~= nil then 
        for a = 1 , self.board.height do
            for b = 1 , self.board.width do
                if self.board.tiles[a][b].inPlay then 
                    table.insert( availableTiles , self.board.tiles[a][b] )
                end
            end
        end
    end
    self.tilePicked = availableTiles[ math.random(1,#availableTiles)] 
    self:teamTurn( 1 )
end

function PlayState:endTurn( )
    
    self.ui:ShowSymbol( true,  self.tilePicked.symbol )
    for i =  1,#self.board.tiles do
        for j =  1,#self.board.tiles[i] do
            self.board.tiles[i][j]:highlightAsSafe(false)
        end
    end
    Timer.after( 1.1 ,function() self.tilePicked:destroyTile( ) self:updateTeam() self.ui:ShowSymbol(false)  self:StartTurn( ) end)
   
end

