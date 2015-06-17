module.exports =
class ToxFriendProtBase
  pInitBotProtocol: (params) ->
    @pID      = params.id
    @pManager = params.manager
    @pSendCB  = params.sendCB
    @pKey     = params.pubKey.slice 0, 64

    @pManager.addBot this

  pReceivedCommand: (cmd) ->
