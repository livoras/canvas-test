{$} = require "../../lib/util"
EventEmitter = require("eventemitter2").EventEmitter2
{WIDTH, HEIGHT} = require "./common.coffee"

class Candy extends EventEmitter
    constructor: ->
        super @
        @$candy = $ ".candy"
        @width = 30
        @height = 16
        @isShow = no
        @x = 0
        @y = 0

    init: (@bounds)->
        @$candy.style.width = "#{@width}px"
        @$candy.style.height = "#{@height}px"

    show: ->
        @$candy.style.display = "block"
        @isShow = yes

    hide: ->
        @$candy.style.display = "none"
        @isShow = no

    moveToRandomPos: ->
        GAP = 40
        x = @bounds.left + GAP + (@bounds.right - @bounds.left - @width - 2 * GAP) * Math.random() 
        y = @bounds.up + GAP + (@bounds.down - @bounds.up - @height - 2 * GAP) * Math.random() 
        @moveTo x, y

    moveTo: (x, y)->
        @x = x
        @y = y
        @$candy.style.webkitTransform = "translate3d(#{x}px, #{y}px, 0)"


module.exports = (new Candy)
