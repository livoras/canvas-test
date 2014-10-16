Game = require "../../lib/game"
util = require "../../lib/util"

{$} = util
game = new Game
eCanvas = $ "#canvas"
eDebug = $ "#debug"
ctx = canvas.getContext "2d"
bird = null
userAgent = window.navigator.userAgent

HEIGHT = document.documentElement.clientHeight
WIDTH = document.documentElement.clientWidth

eCanvas.height = HEIGHT
eCanvas.width = WIDTH

loadImageAndDraw = ->
    bird = new Image
    bird.addEventListener "load", ->
        game.add man 
    bird.src = "assets/bird.png"

man = 
    x: 0# Math.random() * WIDTH
    y: 0#Math.random() * HEIGHT
    vx: 10
    vy: 10
    move: ->
        ctx.clearRect @x, @y, bird.width, bird.height
        if (@x > WIDTH - bird.width) or (@x < 0)
            if @x < 0 then @x = 0
            else @x = WIDTH - bird.width
            @vx = -@vx
        if (@y > HEIGHT - bird.height) or (@y < 0)
            if @y < 0 then @y = 0
            else @y = HEIGHT - bird.height
            @vy = -@vy

        @x += @vx
        @y += @vy

        ctx.drawImage bird, @x, @y, bird.width, bird.height

world = 
    move: ->
        ctx.clearRect 0, 0, WIDTH, HEIGHT

test = 
    count: 0
    move: ->
        fps = util.fps()
        if ++@count is 10
            @count = 0
            eDebug.innerHTML = """
                <p>width: #{WIDTH}, height: #{HEIGHT}, FPS: #{fps}</p>
                <hr>
                <p>#{userAgent}</p>
            """

game.on "init", ->
    # game.add world
    game.add test
    loadImageAndDraw()

game.init()
