EventEmitter = require("eventemitter2").EventEmitter2
{HEIGHT, WIDTH, RATE} = require "./common.coffee"

VX = 3
VY = 5
DIE_WAIT = 500

class Bird extends EventEmitter
    constructor: ->
        super @
        @x = 0
        @y = 0
        @vx = VX
        @vy = VY
        @then = null
        @acc = null
        @bird = null
        @leftBricksPos = []
        @rightBricksPos = []
        @rotateY = 0
        @rotateZ = 0
        @width = 50
        @height = 32

    init: (@bird, @bounds)->
        @bird.width = @width
        @bird.height = @height
        @reset()
        @draw()
        @show()

    show: ->
        @bird.style.display = "block"

    reset: ->
        @isDie = yes
        @x = (WIDTH - @bird.width) / 2
        @y = HEIGHT / 2 - @bird.height
        @vx = 0
        @vy = 0
        @rotateZ = 0
        @leftBricksPos = []
        @rightBricksPos = []
        @turnRight()
        @changeBirdStatus isDie = no
        @bird.className = "bird"

    revive: ->
        @isDie = no
        @vx = VX
        @vy = -VY

    move: ->
        if not @then 
            @acc = 0
            return @then = +new Date
        now = +new Date
        passed = now - @then
        @acc += passed
        while @acc > RATE
            @update()
            @acc -= RATE
        @then = now
        @draw()

    update: ->
        @updateX()
        @updateY()

    updateX: ->
        @checkTouchSideBricks()
        if (@x > WIDTH - @bird.width) or (@x < 0)
            if @x < 0 then @x = 0
            else @x = WIDTH - @bird.width
            @vx = -@vx
            if @vx > 0 then @turnRight()
            else @turnLeft()
            @emit "turn around"
        @x += @vx

    checkTouchSideBricks: ->
        if @isDie then return
        if @x < @bounds.left
            if @vx < 0 then bricksPos = @leftBricksPos
            else return
        else if @x > @bounds.right - @bird.width
            if @vx > 0 then bricksPos = @rightBricksPos
            else return
        else return
        for pos in bricksPos
            from = @bounds.up + pos * @bounds.brickWidth
            to = from + @bounds.brickWidth
            if from < @y < to then return @die()

    updateY: ->
        if @isDie then return
        if (@y <= @bounds.up) or (@y >= @bounds.down - @bird.height)
            # @y = @bounds.down - @bird.height
            @die()
        else
            @vy += 0.2
        @y += @vy

    turnRight: ->
        @bird.src = "assets/bird.png"

    turnLeft: ->
        @bird.src = "assets/bird-left.png"

    draw: ->
        @bird.style.webkitTransform = """
            translate3d(#{@x}px, #{@y}px, 0) rotateY(#{@rotateY}deg) rotateZ(#{@rotateZ}deg)
        """

    flip: ->
        @vy = -VY
        if @isDie then @reset()

    die: ->
        @vy = 0
        @vx = 0
        @isDie = yes
        @emit "die"
        @changeBirdStatus isDie = yes
        if @isOnTheGround()
            setTimeout =>
                @emit "die end"
            , DIE_WAIT
        else
            @moveToGround => @emit "die end"

    changeBirdStatus: (isDie)->
        if isDie then @bird.src = "assets/dead-bird.png"
        else @bird.src = "assets/bird.png"

    isOnTheGround: ->
        if @y >= @bounds.down - @bird.height then return yes
        else return no

    moveToGround: (callback)->
        @bird.className += " dead-animation"
        @y = @bounds.down - @bird.height + 10
        @x = @bounds.left + (@bounds.right - @bounds.left) / 2 - @bird.width / 2 - 20
        @rotateZ = 1840
        ANIMATION_TIME = 400 # define in css
        setTimeout ->
            callback()
        , DIE_WAIT + ANIMATION_TIME


module.exports = new Bird
