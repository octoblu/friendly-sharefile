MeshbluHttp = require 'meshblu-http'
debug       = require('debug')('friendly-sharefile:status-device')

class StatusDevice
  constructor: ({@meshbluConfig}) ->
    @meshbluHttp = new MeshbluHttp @meshbluConfig

  create: ({link,uuid}, callback) =>
    debug 'creating status device'
    deviceProperties =
      name: 'Sharefile Device Status'
      type: 'sharefile:status'
      sharefile:
        link: link
        progress: 0
        done: false
      configureWhitelist: [uuid,@meshbluConfig.uuid]
      receiveWhitelist: [uuid]
      sendWhitelist: [uuid]
      discoverWhitelist: [uuid,@meshbluConfig.uuid]
      owner: uuid

    @meshbluHttp.register deviceProperties, callback

  updateProgress: (progress) =>
    debug 'updating progress', progress
    @meshbluHttp.updateDangerously @meshbluConfig.uuid, {$set: 'sharefile.progress': progress}, (error) =>
      return console.error error if error?
      debug 'updated progress'

  updateDone: (callback=->) =>
    debug 'updating done, removing device'
    @meshbluHttp.unregister {uuid: @meshbluConfig.uuid}, callback

module.exports = StatusDevice
