require "Dependencies"
-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH  = 1920
VIRTUAL_HEIGHT = 1080 
TILE_WIDTH = 256
TILE_HEIGHT = 129
clicked = false

function love.load()
    love.window.setTitle('tactifall')
    math.randomseed(os.time())
     -- initialize our virtual resolution
     push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })
     -- initialize state machine with all state-returning functions
     gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['PickCharacter'] = function() return PickCharacter() end,
        ['gameover'] = function() return GameOver() end,
        ['play'] = function() return PlayState() end,
    }
    params = {}
    params.level_width=2
    params.level_height=3
    params.levelData = {}
    k=1
    for i = 1 , 3 do
        params.levelData[i] = {}
        for j = 1,2 do 
            params.levelData[i][j] = k
            k = k+1
        end
    end
    params.tileswidth = TILE_SIZE
    params.nbTeams = 2
    params.tilesheight = TILE_SIZE
    gStateMachine:change( 'play' , params )
    gTextures['character']={}
    for i = 0,7 do
        gTextures['character'][i+1]={}
        gTextures['character'][i+1]['run']={}
        gTextures['character'][i+1]['idle']={}
        gTextures['character'][i+1]['idle'][1]=
        love.graphics.newImage('img/Human/Human_'..i..'_Idle0.png')
        for j = 0,9 do
        gTextures['character'][i+1]['run'][j+1]=
        love.graphics.newImage('img/Human/Human_'..i..'_Run'..j..'.png')
        end
    end
    gFrames['symbol'] =  SplitSymbols(gTextures['symbol'] )

    
end

function screenRatio()
    return Vector2D( VIRTUAL_WIDTH/WINDOW_WIDTH , VIRTUAL_HEIGHT/WINDOW_HEIGHT )
end

--]] mouse handling
-- mouse pressed
function love.mousepressed( x , y , button )
    if button == 1 then
        mouseLeftClick = Vector2D( x *screenRatio().x  ,
         y*screenRatio().y  )
        clicked = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        mouseLeftClick = nil
        clicked = false
    end
end

function love.update(dt)
    gStateMachine:update(dt)
    Timer.update(dt)
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    --love.graphics.draw(gTextures['background'], backgroundX, 0)
    
    gStateMachine:render()
    push:finish()
end