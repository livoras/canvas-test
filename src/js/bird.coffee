EventEmitter = require("eventemitter2").EventEmitter2
{HEIGHT, WIDTH, RATE} = require "./common.coffee"

VX = 3
VY = 5

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

    init: (@bird)->
        @bird.width = 36
        @bird.height = 36
        @bird.style.border = "3px solid #ddd"
        @reset()
        @draw()

    reset: ->
        @isDie = no
        @x = (WIDTH - @bird.width) / 2
        @y = 100
        @vx = VX

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
        if (@x > WIDTH - @bird.width) or (@x < 0)
            if @x < 0 then @x = 0
            else @x = WIDTH - @bird.width
            @vx = -@vx
        @x += @vx

    updateY: ->
        if @isDie then return
        if (@y >= HEIGHT - @bird.height)
            @y = HEIGHT - @bird.height
            @vy = 0
            @vx = 0
            @isDie = yes
        else
            @vy += 0.2
        @y += @vy

    draw: ->
        @bird.style.webkitTransform = "translate3d(#{@x}px, #{@y}px, 0)"

    flip: ->
        @vy = -VY
        if @isDie then @reset()

module.exports = new Bird
