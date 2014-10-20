util = require "../../lib/util"
{HEIGHT, WIDTH, RATE, AGENT} = require "./common.coffee"

$ = util.$
eDebug = $ "#debug"
agent = AGENT.match(/AppleWebKit\/.+?\s/)[0]

debug = 
    count: 0
    move: ->
        fps = util.fps()
        if ++@count is 10
            @count = 0
            eDebug.innerHTML = """
                <p>width: #{WIDTH}, height: #{HEIGHT}, FPS: #{fps}</p>
                <hr>
                <p>#{agent}</p>
            """

module.exports = debug
