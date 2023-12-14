CharacterClass = Class{}

function CharacterClass:init(character) end
function CharacterClass:OnMove() end
function CharacterClass:onStartTurn(board, tiledrawn) end
function CharacterClass:onDestroyed(_playstate) end