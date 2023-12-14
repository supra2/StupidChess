
function getCharacterQuad(atlas)
    return love.graphics.newQuad( 
                        0, 256, 256, 256, atlas:getDimensions()
                    )
end

function getCharacter(atlas)
    return love.graphics.newQuad( 
                        0, 256, 256, 256, atlas:getDimensions()
                    )
end

-- returns the degrees between (0,0) and pt (note: 0 degrees is 'east')
function angleOfPoint( pt )
    local x, y = pt.x, pt.y
    local radian = math.atan2(y,x)
    local angle = radian*180/math.pi
    if angle < 0 then angle = 360 + angle end
    return angle
end

function contains( table , elem )
    found = false
    for i = 0 , #table do
        found = found or table[i] == elem
        if found then 
            break
        end
    end
    return found
end

function SplitSymbols(atlas)
    quads = {}
    for i = 0 , 512 , 256 do
        for j = 0, 129 ,129 do
          table.insert(  quads, love.graphics.newQuad(i, j, 256, 129, atlas:getDimensions()) )
        end
    end

    for i = 0 , 512 , 256 do
        for j = 258, 461 ,203 do
          table.insert(  quads, love.graphics.newQuad(i, j, 256, 203, atlas:getDimensions()) )
        end
    end
    return quads
end

function FindIndex(table, elem)
    for i, elem2 in ipairs(table) do
        if elem2== elem then 
            return i
        end
    end
    return -1
end