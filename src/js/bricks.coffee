{$} = require "../../lib/util"
EventEmitter = require("eventemitter2").EventEmitter2
{WIDTH, HEIGHT} = require "./common.coffee"
PENALTY = 0.8
BRICK_HEIGHT = 20

class Bricks extends EventEmitter
    constructor: ->
        @leftBrick = null
        @rightBrick = null
        @topBrick = null
        @bottomBrick = null
        @brickWidth = null
        @dist = null

    init: (width, @dist)->
        console.log width, dist
        @brickWidth = width
        @setGroups dist / 2
        @initBricks width
        @initBottomBricks()
        @initTopBricks()

    initBricks: (width)->
        COLOR = "#76B1D8"
        height = BRICK_HEIGHT

        @leftBrick = createBrick "left"
        @leftBrick.style.cssText = """
            border-left: #{height}px solid #{COLOR};
            border-top: #{width/2}px solid transparent;
            border-bottom: #{width/2}px solid transparent;
        """

        @rightBrick = createBrick "right"
        @rightBrick.style.cssText = """
            border-right: #{height}px solid #{COLOR};
            border-top: #{width/2}px solid transparent;
            border-bottom: #{width/2}px solid transparent;
        """

        @bottomBrick = createBrick "bottom"
        @bottomBrick.style.cssText = """
            border-bottom: #{height}px solid #{COLOR};
            border-right: #{width/2}px solid transparent;
            border-left: #{width/2}px solid transparent;
            top: #{-height * PENALTY}px;
        """

        @topBrick = createBrick "top"
        @topBrick.style.cssText = """
            border-top: #{height}px solid #{COLOR};
            border-right: #{width/2}px solid transparent;
            border-left: #{width/2}px solid transparent;
            bottom: #{-height * PENALTY}px;
        """

    setGroups: (height)->
        $(".up-ground").style.height = "#{height}px"
        $(".down-ground").style.height = "#{height}px"

    initBottomBricks: ->
        downGround = $(".down-ground")
        for i in [0..(WIDTH / @brickWidth) - 1]
            brick = @bottomBrick.cloneNode(true)
            brick.style.left = "#{i * @brickWidth}px"
            downGround.appendChild brick

    initTopBricks: ->
        upGround = $(".up-ground")
        for i in [0..(WIDTH / @brickWidth) - 1]
            brick = @topBrick.cloneNode(true)
            brick.style.left = "#{i * @brickWidth}px"
            upGround.appendChild brick

    getBounds: ->
        up = @dist / 2 + BRICK_HEIGHT * PENALTY
        down = HEIGHT - (@dist / 2 + BRICK_HEIGHT * PENALTY)
        left = BRICK_HEIGHT
        right = WIDTH - BRICK_HEIGHT
        {up, down, left, right}

createBrick = (type)->
    div = document.createElement "div"
    div.className = "angle #{type}"
    div

module.exports = (new Bricks)