module.exports =
class GenRequests
  @ping:       (f, params) -> {"version": f.pManager.version}
  @collabList: (f, params) -> {}
  @joinCollab: (f, params) -> {"name": params.name}

  @gen: (c, f, params) ->
    func = GenRequests[c]
    throw {"id": 1, "msg": "Friend is undefined"}       unless f?
    throw {"id": 2, "msg": "Unknown command", "cmd": c} unless func?

    o     = func f, params
    o.cmd = c
    o.id  = f.pGetNewCommandID()
    return o

  @validateRequest: (o, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 1, "msg": "Object is undefined"} unless o?
    return false unless o.cmd?
    return false unless o.id?

    func = GenRequests[o.cmd]

    return false unless func?
    comp = func f, {}

    for i in comp
      found = false
      for j in o
        if i is j
          found = true
          break
      return false unless found

    return true
