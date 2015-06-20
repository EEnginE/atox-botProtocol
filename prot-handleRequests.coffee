module.exports =
class HandleRequests
  @ping: (d, f) -> console.log "  - HandleRequest ping #{d.id}"

  @run: (d, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 2, "msg": "Data is undefined"}   unless d?

    func = HandleRequests[d.cmd]
    throw {"id": 3, "msg": "Unknown request"}     unless func?
    func d, f
