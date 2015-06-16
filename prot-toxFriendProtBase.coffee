module.exports =
class ToxFriendProtBase
  pInitBotProtocol: (params) ->
    @pID      = params.id
    @pManager = params.manager
    @pSendCB  = params.sendCB

    @pManager.addBot this

  pReceivedCommand: (cmd) ->
