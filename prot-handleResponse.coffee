module.exports =
class HandleResponse
  @ping: (d, f) ->
    f.pIsValidBot = true if d.version is f.pManager.version
    console.log "  - Bot #{d.id} is valid: #{f.pIsValidBot}"

  @run: (d, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 2, "msg": "Data is undefined"}   unless d?

    func = HandleRequest[d.resp]
    throw {"id": 3, "msg": "Unknown response"}    unless func?
    func d, f
