module.exports =
class HandleRequests
  @ping: (d, f) ->
    console.log "  - HandleRequest ping #{d.id}"
    return d

  @collabList: (d, f) -> d

  @run: (d, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 2, "msg": "Data is undefined"}   unless d?

    func = HandleRequests[d.cmd]
    throw {"id": 3, "msg": "Unknown request"}     unless func?
    cb = f["REQ_#{d.cmd}"]

    if cb?
      console.log "  - #{d.cmd} callback registerd"
      cb.call f, func d, f
    else
      console.log "  - NO callback for #{d.cmd}"
      func d, f
