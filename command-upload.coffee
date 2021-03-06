_                = require 'lodash'
commander        = require 'commander'
colors           = require 'colors'
fs               = require 'fs'
path             = require 'path'
ShareFileService = require './'

class UploadCommand
  run: =>
    @parseOptions()
    @uploadFile()

  uploadFile: =>
    # return
    @uploadFileByPath() if @path?
    @uploadFileById() if @itemId?

  getFileData: =>
    fs.readFileSync path.resolve(@filename)

  uploadFileById: =>
    sharefileService = new ShareFileService {@token, @domain}
    fileName = path.basename @filename
    fileData = @getFileData()
    sharefileService.uploadFileById {fileName,@title, @description,@itemId,data:fileData}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  uploadFileByPath: =>
    sharefileService = new ShareFileService {@token, @domain}
    fileName = path.basename @filename
    fileData = @getFileData()
    sharefileService.uploadFileByPath {fileName,@title,@description,@path,data:fileData}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  parseOptions: =>
    commander
      .option '-D, --Domain <Domain>', 'The domain name for Sharefile'
      .option '-t, --token <token>', 'The token for Sharefile'
      .option '-i, --id <itemId>', 'The target folder itemId (must have either itemId or path)'
      .option '-p, --path <path>', 'The target folder path (must have either itemId or path)'
      .option '-t, --title <title>', 'The file title (optional)'
      .option '--desciption <desciption>', 'The file desciption (optional)'
      .usage '[options] path/to/file'
      .parse process.argv

    @filename = _.first commander.args
    @domain = commander.Domain
    @token = commander.token
    @path = commander.path
    @itemId = commander.id
    @title = commander.title
    @desciption = commander.desciption

    unless @domain? and @token?
      commander.outputHelp()
      process.exit 0

    unless @path? or @itemId?
      commander.outputHelp()
      process.exit 0

(new UploadCommand()).run()
