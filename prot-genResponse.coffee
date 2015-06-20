module.exports =
class GenResponse
  @ping: (f) -> {"version": f.manager.versions}

  @gen: (r, f) ->
    throw {"id": 1, "msg": "Friend is undefined"}  unless f?
    throw {"id": 2, "msg": "Request is undefined"} unless r?
    func = GenResponse[r.cmd]

    o      = func f
    o.resp = r.cmd
    o.id   = r.id
    return o

  @validateResponse: (o, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 1, "msg": "Object is undefined"} unless o?
    return false unless o.resp?
    return false unless o.id?

    func = GenRequests[o.resp]

    return false unless func?
    comp = func f

    for i in comp
      found = false
      for j in o
        if i is j
          found = true
          break
      return false unless found

    return true
