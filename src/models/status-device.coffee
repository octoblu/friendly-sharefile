MeshbluHttp = require 'meshblu-http'
debug       = require('debug')('friendly-sharefile:status-device')

class StatusDevice
  constructor: ({@meshbluConfig}) ->
    @meshbluHttp = new MeshbluHttp @meshbluConfig

  create: ({link}, callback) =>
    debug 'creating status device'
    deviceProperties =
      name: 'Sharefile Device Status'
      type: 'sharefile:status'
      sharefile:
        link: link
        progress: 0
        done: false
      configureWhitelist: [@meshbluConfig.uuid]
      receiveWhitelist: ['*']
      sendWhitelist: ['*']
      discoverWhitelist: [@meshbluConfig.uuid]
      owner: @meshbluConfig.uuid

    @meshbluHttp.register deviceProperties, callback

  updateProgress: (progress) =>
    debug 'updating progress', progress
    @meshbluHttp.updateDangerously @meshbluConfig.uuid, {$set: 'sharefile.progress': progress}, (error) =>
      return console.error error if error?
      debug 'updated progress'

  updateDone: (callback=->) =>
    debug 'updating done'
    @meshbluHttp.updateDangerously @meshbluConfig.uuid, {$set: 'sharefile.done': true}, callback

module.exports = StatusDevice
