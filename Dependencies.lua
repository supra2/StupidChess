--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'
Chain = require 'lib/knife.chain'
--
-- our own code
--

-- utility
require 'src/StateMachine'
require 'src/Vector2D'
require 'src/Util'
require 'src/GameLogic/Character'
require 'src/GameLogic/CharacterClass'
require 'src/GameLogic/Heavy'
require 'src/GameLogic/Lucky'
require 'src/GameLogic/Light'
require 'src/GameLogic/Team'
-- game pieces
require 'src/GameLogic/Level/Board'
require 'src/GameLogic/Level/Tile'
require 'src/UI'
-- game states
require 'src/states/BaseState'
require 'src/states/PlayState'

require 'src/states/GameOver'

gSounds = {

}

gTextures = 
{
    ['tile'] =  love.graphics.newImage('img/tile.png'),
    ['selected'] =  love.graphics.newImage('img/selected.png'),
    ['pointer'] =  love.graphics.newImage('img/pick.png'),
    ['UI'] =  love.graphics.newImage('img/ui.png'),
    ['symbol'] =  love.graphics.newImage('img/symbols.png')
}

gFrames = {
    
}

-- this time, we're keeping our fonts in a global table for readability
gFonts = {
    ['normal'] =  love.graphics.newFont('font/font.ttf',16),
    ['big'] =  love.graphics.newFont('font/font.ttf',48)
}