_                = require 'lodash'
commander        = require 'commander'
colors           = require 'colors'
MeshbluConfig    = require 'meshblu-config'
ShareFileService = require './'

class TransferCommand
  run: =>
    @parseOptions()
    @transferLinkFile()

  transferLinkFile: =>
    @transferLinkFileByPath() if @path?
    @transferLinkFileById() if @itemId?

  transferLinkFileById: =>
    meshbluConfig = new MeshbluConfig({@filename}).toJSON()
    sharefileService = new ShareFileService {@token,@domain,meshbluConfig}
    sharefileService.transferLinkFileById {statusDeviceConfig:meshbluConfig,@link,@fileName,@itemId}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  transferLinkFileByPath: =>
    meshbluConfig = new MeshbluConfig({@filename}).toJSON()
    sharefileService = new ShareFileService {@token,@domain,meshbluConfig}
    sharefileService.transferLinkFileByPath {statusDeviceConfig:meshbluConfig,@link,@fileName,@path}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  parseOptions: =>
    commander
      .option '-D, --Domain <Domain>', 'The domain name for Sharefile'
      .option '-t, --token <token>', 'The token for Sharefile'
      .option '-i, --id <itemId>', 'The target folder itemId (must have either itemId or path)'
      .option '-p, --path <path>', 'The target folder path (must have either itemId or path)'
      .option '-l, --link <link>', 'Shared link to transfer to Sharefile'
      .option '-f, --fileName <fileName.txt>', 'File name with extension (optional)'
      .usage '[options] path/to/status-device-meshblu.json'
      .parse process.argv

    @filename = _.first commander.args
    @domain = commander.Domain
    @token = commander.token
    @path = commander.path
    @itemId = commander.id
    @link = commander.link
    @fileName = commander.fileName

    unless @domain? and @token? and @link?
      commander.outputHelp()
      process.exit 0

    unless @path? or @itemId?
      console.log 'Missing Path or Item ID'
      commander.outputHelp()
      process.exit 0

(new TransferCommand()).run()
