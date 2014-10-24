Game = require "../../lib/game"
bird = require "./bird.coffee"
candy = require "./candy.coffee"
debug = require "./debug.coffee"
states = require "./states.coffee"
bricks = require "./bricks.coffee"
r = require "../../lib/r"
util = require "../../lib/util"
common = require "./common.coffee"
{HEIGHT, WIDTH} = common

$ = util.$
game = new Game
$area = $(".area")
$score = $ "#score"
score = 0

game.on "init", ->
    # game.add debug
    initArea()
    initBricks()
    initStates()
    initBird()
    initCandy()
    collideCandyAndBird()
    states.change "start"

initArea = ->    
    $area.style.height = "#{HEIGHT}px"
    $area.style.width = "#{WIDTH}px"

initBird = ->
    birdDOM = $ ".bird"
    birdDOM.className = "bird"
    $area.appendChild birdDOM
    bird.init birdDOM, bricks.getBounds()
    flipWhenTouchDown()
    boundBricks()
    game.add bird 

initCandy = ->
    candy.init bricks.getBounds()
    bird.on "turn around", -> 
        if candy.isShow then return
        candy.show()
        if isBirdFacingLeft()
            candy.moveToRandomPos()
        else
            candy.moveToRandomPos isRight = yes

collideCandyAndBird = ->
    game.add 
        move: ->
            if not candy.isShow then return
            vTouched = (candy.x < bird.x + bird.width) && (bird.x < candy.x + candy.width)
            hTouched = (candy.y < bird.y + bird.height) && (bird.y < candy.y + candy.height)
            if vTouched and hTouched
                score += 3
                updateScore score
                candy.hide()


boundBricks = ->
    bird.on "turn around", ->
        score++
        updateScore()
        if isBirdFacingLeft()
            bricks.hideRight()
            bricks.showLeftWithRandomBricks()
        else
            bricks.hideLeft()
            bricks.showRightWithRandomBricks()

    bricks.on "left bricks change", (pos)->
        bird.leftBricksPos = pos

    bricks.on "right bricks change", (pos)->
        bird.rightBricksPos = pos

isBirdFacingLeft = ->
    bird.vx < 0

initBricks = ->
    brickWidth = 35
    dist = HEIGHT - brickWidth * 13
    if dist < 0
        brickWidth = Math.floor(HEIGHT / 13)
        dist = 0
    bricks.init brickWidth, dist

initStates = ->
    states.on "start", ->
        score = 0
        $score.style.display = "none"
        updateScore()
        bricks.hideLeft()
        bricks.hideRight()
        bird.reset()
        candy.hide()

    states.on "game", ->
        $score.style.display = "block"
        bird.revive()

    bird.on "die end", -> states.change "over"

flipWhenTouchDown = ->
    window.addEventListener "touchstart", ->
        if states.state is "game" and not bird.isDie
            bird.flip()

updateScore = ->
    common.score = score
    updateBricksCount score
    $score.innerHTML = score 

updateBricksCount = (score)->
    count = (Math.floor score / 10) + 3
    if count > 10 then count = 10
    bricks.bricksCount = count

game.init()