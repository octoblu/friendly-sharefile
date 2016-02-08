_                = require 'lodash'
commander        = require 'commander'
colors           = require 'colors'
fs               = require 'fs'
path             = require 'path'
ShareFileService = require './'

class DownloadCommand
  run: =>
    @parseOptions()
    @downloadFile()

  downloadFile: =>
    # return
    @downloadFileByPath() if @path?
    @downloadFileById() if @itemId?

  downloadFileById: =>
    sharefileService = new ShareFileService {@token, @sharefileDomain}
    sharefileService.downloadFileById {@itemId}, (error, result) =>
      return console.error colors.red "Error: #{error.message}" if error?
      console.log result.body

  downloadFileByPath: =>
    sharefileService = new ShareFileService {@token, @sharefileDomain}
    sharefileService.downloadFileByPath {@path}, (error, result) =>
      return console.error colors.red "Error: #{error.message}" if error?
      console.log result.body

  parseOptions: =>
    commander
      .option '-D, --Domain <Domain>', 'The domain name for Sharefile'
      .option '-t, --token <token>', 'The token for Sharefile'
      .option '-i, --id <itemId>', 'The target folder itemId (must have either itemId or path)'
      .option '-p, --path <path>', 'The target folder path (must have either itemId or path)'
      .parse process.argv

    @sharefileDomain = commander.Domain
    @token = commander.token
    @path = commander.path
    @itemId = commander.id

    unless @sharefileDomain? and @token?
      commander.outputHelp()
      process.exit 1

    unless @path? or @itemId?
      commander.outputHelp()
      process.exit 1

(new DownloadCommand()).run()