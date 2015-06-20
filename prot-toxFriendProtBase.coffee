GenRequests   = require './prot-genRequests'
GenResponse   = require './prot-genResponse'
HandleRequests = require './prot-handleRequests'
HandleResponse = require './prot-handleResponse'

module.exports =
class ToxFriendProtBase
  pInitBotProtocol: (params) ->
    @pID      = params.id
    @pManager = params.manager
    @pSendCB  = params.sendCB

    @pManager.addBot this

    @pIsValidBot = false
    @pCMDid      = 0

    @pSendCommand 'ping'

  pHandleRequests: (data) ->
    if not GenRequests.validateRequest data, this
      console.log "  - Invalid Request"
      return
    else
      console.log "  - Valid Request"

    try
      HandleRequests.run data, this
      @pSendCB JSON.stringify GenResponse.gen data, this
    catch e
      console.log "  - Failed to handle request"
      console.log e

  pHandleResponse: (data) ->
    if not GenResponse.validateResponse data, this
      console.log "  - Invalid Response"
      return
    else
      console.log "  - Valid Response"

    try
      HandleResponse.run data, this
    catch e
      console.log "  - Failed to handle response"
      console.log e

  pReceivedCommand: (cmd) ->
    try
      data = JSON.parse cmd
    catch error
      return

    console.log ""
    console.log "Friend #{@pID} received:"
    cosnole.log data

    return @pHandleRequests data if data.cmd?
    return @pHandleResponse data if data.resp?

    console.log "  - Unknown OBJ"

  pSendCommand: (name) ->
    try
      data = GenRequests.gen name, this
      @pSendCB JSON.stringify data
      console.log "Sent CMD #{name} to #{@pID}"
      console.log data
    catch e
      console.log "Failed to send CMD '#{name}'"
      console.log e

  pGetNewCommandID: -> @pCMDid++
