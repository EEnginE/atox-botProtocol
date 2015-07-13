# coffeelint: disable=max_line_length

module.exports =
class GenResponse
  @ping:       (r, f) -> {"version": f.pManager.version}
  @collabList: (r, f) -> {"list":    f.pManager.getCollabList()}
  @joinCollab: (r, f) ->
    ret = -1
    ret = f.rCollabInviteReturn if f.rCollabInviteReturn?
    {"inviteReturn": ret, "name": r.name}

  @gen: (r, f) ->
    throw {"id": 1, "msg": "Friend is undefined"}  unless f?
    throw {"id": 2, "msg": "Request is undefined"} unless r?
    func = GenResponse[r.cmd]

    o      = func r, f
    o.resp = r.cmd
    o.id   = r.id
    return o

  @validateResponse: (o, f) ->
    throw {"id": 1, "msg": "Friend is undefined"} unless f?
    throw {"id": 1, "msg": "Object is undefined"} unless o?
    return false unless o.resp?
    return false unless o.id?

    func = GenResponse[o.resp]

    return false unless func?
    comp = func {}, f

    for i of comp
      found = false
      for j of o
        if i is j
          found = true
          break
      return false unless found

    return true
