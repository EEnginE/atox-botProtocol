module.exports =
class HandleResponse
  @ping: (d, f) ->
    f.pIsValidBot = true if d.version is f.pManager.version
    console.log "  - Bot #{d.id} is valid: #{f.pIsValidBot}"
    {"version": d.version, "valid": f.pIsValidBot}

  @collabList: (d, f) ->
    console.log "  - Updated collab list for #{f.pKey}"
    f.pCollabList = d.list
    d

  @run: (d, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 2, "msg": "Data is undefined"}   unless d?

    func = HandleResponse[d.resp]
    throw {"id": 3, "msg": "Unknown response"}    unless func?
    cb = f["RESP_#{d.resp}"]

    if cb?
      console.log "  - #{d.resp} callback registerd"
      cb.call f, func d, f
    else
      console.log "  - NO callback for #{d.resp}"
      func d, f
