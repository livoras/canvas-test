util = require "../../lib/util"
EventEmitter = require("eventemitter2").EventEmitter2
common = require "./common.coffee"

states = ["start", "game", "over", "share"]
$ = util.$

class State extends EventEmitter

    constructor: ->
        super @
        @$over = $ "#over"
        @$share = $ "#share"
        @$score = $ "#over .score"
        @state = "start" # "game", "over", "share"
        @init()

    init: ->
        @initOverState()
        @initShareState()
        window.addEventListener "touchstart", =>
            if @state is "start" then @change "game"

    initOverState: ->
        $("#over div.again").addEventListener "touchstart", (event)=>
            event.stopPropagation()
            @change "start"

        $("#over div.show-off").addEventListener "touchstart", =>
            event.stopPropagation()
            @change "share"

    initShareState: ->
        $("#share div.back").addEventListener "touchstart", =>
            @$share.style.display = "none"

    change: (state)->
        if state not in states then throw "#{state} is not in states"
        @state = state
        @toggleOverState state
        if state is "share" then @showShare()
        @emit state

    toggleOverState: (state)->
        if state in ["over", "share"]
            @$score.innerHTML = common.score
            @$over.style.display = "block"
        else
            @$over.style.display = "none"

    showShare: ->
        @$share.style.display = "block"


module.exports = (new State)
