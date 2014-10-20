Game = require "../../lib/game"
bird = require "./bird.coffee"
debug = require "./debug.coffee"
states = require "./states.coffee"
bricks = require "./bricks.coffee"
r = require "../../lib/r"
util = require "../../lib/util"
{HEIGHT, WIDTH} = require "./common.coffee"

$ = util.$
game = new Game
$area = $(".area")

game.on "init", ->
    game.add debug
    initArea()
    initBricks()
    initStates()
    initBird()
    states.change "start"

initArea = ->    
    $area.style.height = "#{HEIGHT}px"
    $area.style.width = "#{WIDTH}px"

initBird = ->
    birdDOM = r.images.get "bird"
    birdDOM.className = "bird"
    $area.appendChild birdDOM
    bird.init birdDOM, bricks.getBounds()
    flipWhenTouchDown()
    game.add bird 

initBricks = ->
    brickWidth = 35
    dist = HEIGHT - brickWidth * 13
    if dist < 0
        brickWidth = Math.floor(HEIGHT / 13)
        dist = 0
    bricks.init brickWidth, dist

initStates = ->
    states.on "start", ->
        bird.reset()

    states.on "game", ->
        bird.revive()

    bird.on "die", -> states.change "over"

flipWhenTouchDown = ->
    window.addEventListener "touchstart", ->
        if states.state is "game" then bird.flip()

load = ->
    r.on "all images loaded", -> game.init()
    r.images.set "bird", "assets/bird.png"

load()
