module.exports =
class BotManager
  constructor: (params) ->
    @pAToxClients = []

  addBot: (TOXfriend) ->
    @pAToxClients.push TOXfriend
