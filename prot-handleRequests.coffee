module.exports =
class HandleRequests
  @ping:       (d, f) -> d
  @collabList: (d, f) -> d
  @joinCollab: (d, f) -> d

  @run: (d, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 2, "msg": "Data is undefined"}   unless d?

    func = HandleRequests[d.cmd]
    throw {"id": 3, "msg": "Unknown request"}     unless func?
    cb = f["REQ_#{d.cmd}"]

    drop = false

    if cb?
      console.log "  - Running callback"
      if cb.call( f, func d, f ) is "drop" then drop = true
    else
      func d, f

    return drop
