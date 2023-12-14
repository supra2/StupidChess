UI= Class{}

function UI:init()
end


function UI:draw()
    if self.showButton then
        love.graphics.rectangle('fill', SCREEN_WIDTH -120, SCREEN_HEIGHT -60, 100,50)
       -- love.graphics.print('Deselect', SCREEN_WIDTH - 120 , SCREEN_HEIGHT - 60, 100 , 50)
    end
end


function UI:ShowSymbol( showsymbol , symbol_drawn )
    
    self.showSymbol = showsymbol 
    if showsymbol then
        self.alpha = 0
        self.symbol_drawn  = symbol_drawn
       self.visibilityTween = Timer.tween( 1 ,  { [self] =
        {alpha = 255} } )
    else
        self.visibilityTween = Timer.tween( 1 ,  { [self] =
        {alpha =  0 } } )
    end
end


function UI:draw()
    if  self.showSymbol  then 
        love.graphics.setColor(1,1,1,self.alpha )
        love.graphics.draw( gTextures['symbol'] ,
        gFrames['symbol'][ self.symbol_drawn + 6] ,0 ,0)
    end
end