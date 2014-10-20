Game = require "../../lib/game"
bird = require "./bird.coffee"
debug = require "./debug.coffee"

game = new Game
birdDOM = new Image

loadImageAndDraw = ->
    birdDOM.style.webkitTransform = "translate3d(0, 0, 0)"
    birdDOM.addEventListener "load", ->
        bird.init birdDOM
        flipWhenTouchDown()
        game.add bird 
    birdDOM.src = "assets/bird.png"
    document.body.appendChild birdDOM

flipWhenTouchDown = ->
    window.addEventListener "touchstart", ->
        bird.flip()

game.on "init", ->
    game.add debug
    loadImageAndDraw()

game.init()
