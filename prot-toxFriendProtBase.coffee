module.exports =
class ToxFriendProtBase
  constructor: (params) ->
    @id      = params.id
    @manager = params.manager
    @sendCB  = params.sendCB
