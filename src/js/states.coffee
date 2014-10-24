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
        @$rank = $ "#over .rank"
        @$bullShit = $ "#over .bull-shit"
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

    change: (state, score)->
        if state not in states then throw "#{state} is not in states"
        @state = state
        @toggleOverState state, score
        if state is "share" then @showShare()
        @emit state

    toggleOverState: (state, score)->
        if state is "share" then return
        if state is "over"
            @$score.innerHTML = common.score
            @$rank.innerHTML = getRankByScore score
            @$bullShit.innerHTML = getBullShitByScore score
            @$over.style.display = "block"
        else
            @$over.style.display = "none"

    showShare: ->
        @$share.style.display = "block"

getRankByScore = (score)->
    if 0 <= score <= 3 then return percentBullShit 6
    if 4 <= score <= 6 then return percentBullShit 8
    if 7 <= score <= 10 then return percentBullShit 10
    if 11 <= score <= 13 then return percentBullShit 21
    if 14 <= score <= 16 then return percentBullShit 32
    if 17 <= score <= 20 then return percentBullShit 43
    if 21 <= score <= 23 then return percentBullShit 50
    if 24 <= score <= 26 then return percentBullShit 62
    if 27 <= score <= 30 then return percentBullShit 69
    if 31 <= score <= 33 then return percentBullShit 73
    if 34 <= score <= 36 then return percentBullShit 79
    if 37 <= score <= 40 then return percentBullShit 85

    if 41 <= score <= 45 then return randBullShit 5000, 9999
    if 46 <= score <= 50 then return randBullShit 2000, 4999
    if 51 <= score <= 55 then return randBullShit 1000, 2999
    if 56 <= score <= 60 then return randBullShit 700, 999
    if 61 <= score <= 65 then return randBullShit 500, 699
    if 65 <= score <= 70 then return randBullShit 100, 499
    if score > 70 then return randBullShit 10, 99


percentBullShit = (percent)-> 
    "打爆了全国#{percent}%的人"

randBullShit = (from, to)->
    "排在全国#{from + Math.floor((to - from + 1)  * Math.random())}名"

getBullShitByScore = (score)->
    if score <= 10 then return "矮油，你也太温柔了吧？！"
    if 11 <= score <= 30 then return "你做得还不错嘛！"
    if 31 <= score <= 50 then return "靠！牛逼爆了你！"
    if score > 50 then return "OMG！你这么高分还能不能做朋友啊？"

module.exports = (new State)
