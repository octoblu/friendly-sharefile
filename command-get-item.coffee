commander        = require 'commander'
colors           = require 'colors'
ShareFileService = require './'

class GetItemIdCommand
  run: =>
    @parseOptions()
    @getItem()

  getItem: =>
    # return
    @getItemByPath() if @path?
    @getItemById() if @itemId?

  getItemById: =>
    sharefileService = new ShareFileService {@token, @domain}
    sharefileService.getItemById {@itemId}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  getItemByPath: =>
    sharefileService = new ShareFileService {@token, @domain}
    sharefileService.getItemByPath {@path}, (error, result) =>
      return console.log colors.red "Error: #{error.message}" if error?
      console.log JSON.stringify result.body, null, 2

  parseOptions: =>
    commander
      .option '-D, --Domain <Domain>', 'The domain name for Sharefile'
      .option '-t, --token <token>', 'The token for Sharefile'
      .option '-i, --id <itemId>', 'The file itemId (must have either itemId or path)'
      .option '-p, --path <path>', 'The file path (must have either itemId or path)'
      .parse process.argv

    @domain = commander.Domain
    @token = commander.token
    @path = commander.path
    @itemId = commander.id
    @path = commander.path

    unless @domain? and @token?
      commander.outputHelp()
      process.exit 0

    unless @path? or @itemId?
      commander.outputHelp()
      process.exit 0

(new GetItemIdCommand()).run()
