class TimeoutHelper
  timeoutHelper: (t, cb) -> setTimeout cb, t
  constructor: (counter, cb) ->
    @counter = counter
    @cb      = cb

  cancleOne: ->
    @counter--
    if @counter is 0 and @timeout?
      cancleTimeout @timeout
      @cb {"timeout": false}

  run: (t) ->
    @timeout = @timeoutHelper t, => @cb {"timeout": true}

module.exports =
class BotManager
  constructor: (params) ->
    @version = '0.0.1'
    @pCMDid  = 0

    @pAToxClients = []

    @pResponses = []

  addBot: (TOXfriend) ->
    @pAToxClients.push TOXfriend

  getCollabList: -> [] # Stub

  pGetNewCommandID: -> @pCMDid++

  pGenResponseOBJ: -> {"done": false, "timeout": null}

  pReceivedResponse: (id) ->
    @pResponses[id] = @pGenResponseOBJ() unless @pResponses[id]?
    @pResponses[id].done = true
    @pResponses[id].timeout.cancleOne() if @pResponses[id].timeout?

  pWaitForResponses: (ids, timeout, cb) ->
    haveToWait = 0
    for id in ids
      @pResponses[id] = @pGenResponseOBJ() unless @pResponses[id]?
      if @pResponses[id].done
        haveToWait++

    if haveToWait is ids.length then return cb {"timeout": false}

    to = new TimeoutHelper ids.length - haveToWait, (a) =>
      for id in ids
        @pResponses[id].timeout = null

      cb a

    for id in ids
      continue if @pResponses[id].done
      if @pResponses[id].timeout?
        throw {"id": 1, "message": "Previous timeout not finished yet"}

      @pResponses[id].timeout = to

    to.run timeout
