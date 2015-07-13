# coffeelint: disable=max_line_length

MSG = {}
ID_LENGTH = 10

module.exports =
class BigMessage
  @genOBJ: (id, length, max, nParts) ->
    {
      "id":     "#{id}"
      "length": length
      "max":    max
      "n":      nParts
    }

  @validateOBJ: (obj) ->
    comp = @genOBJ "", 0, 0, 0
    for i of comp
      found = false
      for j of obj
        if i is j
          found = true
          break
      return false unless found

    return true

  @send: (msg, maxLength, cb) ->
    if msg.length <= maxLength # Nothing to do
      return cb msg

    maxData = maxLength - ID_LENGTH
    throw new Error "Max length < ID_LENGTH" if maxData <= 0

    numParts = Math.floor msg.length / maxData
    numParts++ unless msg.length % maxData is 0

    id = @genID()
    first = JSON.stringify @genOBJ id, msg.length, maxLength, numParts

    parts = []
    for i in [0..(msg.length - 1)] by maxData
      parts.push "#{id}#{msg.slice i, i + maxData}"

    throw new Error "maxLength is to small. MIN: #{first.length}" if first.length > maxLength

    cb first
    for i in parts
      ret = cb i

    return ret

  @receive: (msg, cb) ->
    console.log msg
    return cb msg if msg.length <= ID_LENGTH

    try
      parsedMSG = JSON.parse msg
      unless @validateOBJ parsedMSG
        console.log "THRPW"
        throw {}
      console.log parsedMSG

      MSG[parsedMSG.id] = parsedMSG
      MSG[parsedMSG.id].lengthCount = 0
      MSG[parsedMSG.id].parts       = []
      MSG[parsedMSG.id].timeout     = @myTimeout 10000, => @timeout parsedMSG.id, cb
      return
    catch error

    msgID = msg.slice 0, ID_LENGTH
    return cb msg unless MSG[msgID]?
    return cb msg unless MSG[msgID].id is msgID
    return cb msg if     MSG[msgID].parts.length is MSG[msgID].n
    return cb msg if    (MSG[msgID].max isnt msg.length) and ((MSG[msgID].parts.length + 1) isnt MSG[msgID].n)

    part = msg.slice ID_LENGTH
    if (MSG[msgID].parts.length + 1) is MSG[msgID].n
      # The last part
      return cb msg if (MSG[msgID].lengthCount + part.length) isnt MSG[msgID].length
      clearTimeout MSG[msgID].timeout

      MSG[msgID].parts.push part
      completeMSG = ""
      for i in MSG[msgID].parts
        completeMSG += i

      return cb completeMSG
    else
      clearTimeout MSG[msgID].timeout
      MSG[msgID].timeout      = @myTimeout 10000, => @timeout msgID, cb
      MSG[msgID].lengthCount += part.length
      MSG[msgID].parts.push part

  @timeout: (id, cb) ->
    console.error ""
    console.error "SPLIT MESSAGE '#{id}' TIMED OUT"
    console.error ""
    for i in MSG[id].parts
      cb i

  @genID: ->
    t = ""
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"$&(){}[]_+-*/%=?^'#|;,:.<>~`"
    t += chars[Math.floor(Math.random() * chars.length)] for i in [0...ID_LENGTH]
    return t

  @myTimeout: (s, cb) ->
    setTimeout cb, s
