MeshbluHttp = require 'meshblu-http'
debug       = require('debug')('friendly-sharefile:status-device')

class StatusDevice
  constructor: ({@meshbluConfig}) ->
    @meshbluHttp = new MeshbluHttp @meshbluConfig

  create: ({link,uuid,fileName}, callback) =>
    debug 'creating status device'
    whitelist = []
    whitelist = [uuid] if uuid?
    title = fileName || link
    deviceProperties =
      name: 'Sharefile Transfer'
      type: 'progress:status'
      progressInfo:
        title: title
        progress: 0
        done: false
      configureWhitelist: whitelist
      receiveWhitelist: whitelist
      sendWhitelist: whitelist
      discoverWhitelist: whitelist

    deviceProperties.owner = uuid if uuid?

    @meshbluHttp.register deviceProperties, callback

  updateProgress: (progress) =>
    debug 'updating progress', progress
    @meshbluHttp.updateDangerously @meshbluConfig.uuid, {$set: 'progressInfo.progress': progress}, (error) =>
      return console.error error if error?
      debug 'updated progress'

  updateDone: (callback=->) =>
    debug 'updating done, removing device'
    @meshbluHttp.unregister {uuid: @meshbluConfig.uuid}, callback

module.exports = StatusDevice
