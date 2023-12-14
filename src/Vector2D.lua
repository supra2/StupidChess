Vector2D = Class{}

function Vector2D:init(x, y)
    self.x =x 
    self.y =y 
end

function Vector2D:dotproduct(vec2)
    return self.x* vec2.x + self.y*  vec2.y
end

function Vector2D:magnitude()
    return math.sqrt((self.x *self.x)+ (self.y * self.y))
end

function Vector2D:scale(factor)
    self.x = factor * self.x
    self.y = factor * self.y
    return self
end

function Vector2D:normalize()

    if magnitude == 0 then return nil end

    self.x = self.x/self:magnitude()
    self.y = self.y/self:magnitude()
    
    return self
end

function Vector2D.__add (a,b)
    return Vector2D(  a.x+b.x , a.y+b.y)
end

function Vector2D.__sub(a,b)
    return Vector2D(  a.x-b.x, a.y-b.y)
end