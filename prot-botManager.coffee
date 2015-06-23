module.exports =
class BotManager
  constructor: (params) ->
    @version = '0.0.1'

    @pAToxClients = []

  addBot: (TOXfriend) ->
    @pAToxClients.push TOXfriend

  getCollabList: -> [] # Stub
