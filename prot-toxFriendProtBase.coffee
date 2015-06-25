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
    @pKey     = params.pubKey.slice 0, 64

    @pManager.addBot this

    @pIsValidBot = false
    @pCMDid      = 0

    @pCollabList = []

    @pSendCommand 'ping'

  pHandleRequests: (data) ->
    if not GenRequests.validateRequest data, this
      console.log "  - Invalid Request"
      return
    else
      console.log "  - Valid Request (#{data.cmd})"

    try
      HandleRequests.run data, this
      response = GenResponse.gen data, this
      console.log " --> Sending response:"
      console.log response
      @pSendCB JSON.stringify response
    catch e
      console.log "  - Failed to handle request"
      console.log e

  pHandleResponse: (data) ->
    if not GenResponse.validateResponse data, this
      console.log "  - Invalid Response"
      return
    else
      console.log "  - Valid Response (#{data.resp})"

    try
      HandleResponse.run data, this
    catch e
      console.log "  - Failed to handle response"
      console.log e

    @pManager.pReceivedResponse data.id

  pReceivedCommand: (cmd) ->
    try
      data = JSON.parse cmd
    catch error
      return

    console.log ""
    console.log "<--- From friend #{@pID}:"
    console.log data

    return @pHandleRequests data if data.cmd?
    return @pHandleResponse data if data.resp?

    console.log "  - Unknown OBJ"

  pSendCommand: (name, params={}) ->
    console.log ""
    try
      data = GenRequests.gen name, this, params
      @pSendCB JSON.stringify data
      console.log "---> Sent CMD #{name} to #{@pID}"
      console.log data
      return data.id
    catch e
      console.log "Failed to send CMD '#{name}'"
      console.log e
      return -1

  pGetNewCommandID: -> @pManager.pGetNewCommandID()
