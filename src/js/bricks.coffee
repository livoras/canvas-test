{$} = require "../../lib/util"
EventEmitter = require("eventemitter2").EventEmitter2
{WIDTH, HEIGHT} = require "./common.coffee"
PENALTY = 0.8
BRICK_HEIGHT = 20

leftWall = $ ".left-wall"
rightWall = $ ".right-wall"

class Bricks extends EventEmitter
    constructor: ->
        @leftBrick = null
        @rightBrick = null
        @topBrick = null
        @bottomBrick = null
        @brickWidth = null
        @dist = null
        @bricksCount = 3
        @leftBricksPos = null
        @rightBricksPos = null

    init: (width, @dist)->
        @brickWidth = width
        @setGroups dist / 2
        @initBricks width
        @initBottomBricks()
        @initTopBricks()
        @initWalls()

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
        {up, down, left, right, brickWidth: @brickWidth}

    initWalls: ->
        leftWall.style.height = "#{@brickWidth * 11}px"
        leftWall.style.width = "#{BRICK_HEIGHT}px"
        rightWall.style.height = "#{@brickWidth * 11}px"
        rightWall.style.width = "#{BRICK_HEIGHT}px"
        window.a = @

    hideLeft: ->
        @leftBricksPos = []
        leftWall.style.webkitTransform = "translate3d(#{-BRICK_HEIGHT}px, 0, 0)"

    showLeftWithRandomBricks: ->
        leftWall.innerHTML = ""
        pos = [0..10]
        @leftBricksPos = []
        for i in [1..@bricksCount]
            index = Math.floor(Math.random() * pos.length)
            toSetPos = pos[index]
            pos.splice index, 1
            @leftBricksPos.push toSetPos
            brick = @leftBrick.cloneNode true
            brick.style.webkitTransform = "translate3d(0, #{toSetPos * @brickWidth}px, 0)"
            leftWall.appendChild brick
        @emit "left bricks change", @leftBricksPos
        leftWall.style.webkitTransform = "translate3d(0, 0, 0)"

    hideRight: ->
        @rightBricksPos = []
        rightWall.style.webkitTransform = "translate3d(#{BRICK_HEIGHT}px, 0, 0)"

    showRightWithRandomBricks: ->
        rightWall.innerHTML = ""
        pos = [0..10]
        @rightBricksPos = []
        for i in [1..@bricksCount]
            index = Math.floor(Math.random() * pos.length)
            toSetPos = pos[index]
            pos.splice index, 1
            @rightBricksPos.push toSetPos
            brick = @rightBrick.cloneNode true
            brick.style.webkitTransform = "translate3d(0, #{toSetPos * @brickWidth}px, 0)"
            rightWall.appendChild brick
        @emit "right bricks change", @rightBricksPos
        rightWall.style.webkitTransform = "translate3d(0, 0, 0)"


createBrick = (type)->
    div = document.createElement "div"
    div.className = "angle #{type}"
    div

module.exports = (new Bricks)