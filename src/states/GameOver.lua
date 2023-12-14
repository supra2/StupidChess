GameOver = Class{'BaseState'}

function GameOver:init()
 
end

function GameOver:enter(params)

end 
function GameOver:render()
   love.graphics.print( 'GAMEOVER', gFonts['big'] , SCREEN_WIDTH /2 , SCREEN_HEIGHT/2 )
end