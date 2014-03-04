
gulp   = require("gulp")
gutil  = require("gulp-util")
path   = require("path")
Buffer = require('buffer').Buffer
es     = require("event-stream")
Q      = require("q")
fs     = require("fs")
vm     = require("vm")
EventEmitter = require("events").EventEmitter

tinylr   = require("tiny-lr")
chokidar = require("chokidar")
notifier = require("node-notifier")

coffee     = require("gulp-coffee")
coffeelint = require("gulp-coffeelint")
gulpif     = require("gulp-if")
cached     = require("gulp-cached")

indexOf    = require("./indexof")

buildLangSrc = require("../../config/lang")


# Configs
coffeelintOptions =
  indentation     : { level : "ignore" }
  no_tabs         : { level : "ignore" }
  max_line_length : { level : "ignore" }


compileIgnorePath = /.src.(test|vender|ui)/
compileCoffeeOnlyRegex = /.src.(service|model)/



Helper =
  shouldLintCoffee : (f)-> not f.path.match compileCoffeeOnlyRegex
  endsWith : ( string, pattern )->
    if string.length < pattern.length then return false

    idx      = 0
    startIdx = string.length - pattern.length

    while idx < pattern.length
      if string[ startIdx + idx ] isnt pattern[ idx ]
        return false
      ++idx

    true

  notify : ( msg )->
    if GLOBAL.gulpConfig.enbaleNotifier
      notifier.notify {
        title   : "IDE Gulp"
        message : msg
      }, ()-> # Add an callback, so that windows won't fail.
    null

  lrServer : undefined
  createLrServer : ()->
    if Helper.lrServer isnt undefined then return

    # Start LiveReload Server
    gutil.log gutil.colors.bgBlue.white(" Starting livereload server... ")

    Helper.lrServer = tinylr()
    # Better error output
    Helper.lrServer.server.removeAllListeners 'error'
    Helper.lrServer.server.on "error", (e)->
      if e.code isnt "EADDRINUSE" then return
      console.error('[LR Error] Cannot start livereload server. You already have a server listening on %s', Helper.lrServer.port)
      Helper.lrServer = null

    Helper.lrServer.listen GLOBAL.gulpConfig.livereloadServerPort, ( err )->
      if err
        gutil.log "[LR Error]", "Cannot start livereload server"
        Helper.lrServer = null
      null

    null

  log  : (e)-> console.log e
  noop : ()->

  compileTitle : ( extra )->
    title = "[" + gutil.colors.green("Compile @#{(new Date()).toLocaleTimeString()}") + "]"
    if extra
      title += " " + gutil.colors.inverse( extra )
    title

  cwd : process.cwd()

  watchRetry : 0
  watchIsWorking : false
  createWatcher : ()->
    # Watch files
    if GLOBAL.gulpConfig.pollingWatch
      gutil.log gutil.colors.bgBlue.white(" Watching file changes... ") + " [Polling]"

      watcher = new EventEmitter()
      gulp.watch ["./src/**/*.coffee", "./src/assets/**/*"], ( event )->
        if event.type is "added"
          type = "add"
        else if event.type is "changed"
          type = "change"
        else
          return

        watcher.emit type, event.path
        null
    else
      gutil.log gutil.colors.bgBlue.white(" Watching file changes... ") + " [Native FSevent, git pull will not trigger changes]"

      watcher = chokidar.watch "./src", {
        usePolling    : false
        useFsEvents   : true
        ignoreInitial : true
        ignored       : /([\/\\]\.)|src.(test|vender)/
      }

      # Native file event doesn't report git co correctly.
      # So we polling watch .git/HEAD
      gulp.watch "./.git/HEAD", ( event )->
        console.log "[" + gutil.colors.green("Git HEAD Changed @#{(new Date()).toLocaleTimeString()}") + "] Ready to re-compile the whole project"

        compileDev()
        null

    return watcher


StreamFuncs =
  jshint       : require("./jshint")
  lintReporter : require('./reporter')

  coffeeErrorPrinter : ( error )->
    console.log gutil.colors.red.bold("\n[CoffeeError]"), error.message.replace( process.cwd(), "." )

    Helper.notify "Error occur when compiling " + error.message.replace( process.cwd(), "." ).split(":")[0]
    null

  throughLiveReload : ()->
    es.through ( file )->
      if Helper.lrServer
        Helper.lrServer.changed {
          body : { files : [ file.path ] }
        }
      null

  throughCoffeeConditionalCompile : ()->
    # This transformer simply replace "### env:prod ### to ### env:prod "
    es.through ( file )->
      buffer = file.contents
      index = 0
      found = 0
      while (index = indexOf( buffer, "### env:prod ###", index )) != -1
        if GLOBAL.gulpConfig.verbose then console.log "[EnvProdFound]", file.relative

        buffer[index + 13] = buffer[index + 14] = buffer[index + 15] = 32

        index = indexOf( buffer, "### env:prod:end ###", index+16 )
        if index == -1
          console.log "[Missing EnvProdEnd]"
          break
        if GLOBAL.gulpConfig.verbose then console.log "[EnvProdEndFound]", file.relative
        buffer[index + 0] = buffer[index + 1] = buffer[index + 2] = 32
        index += 20

        ++found

      if found
        file.extra = "EnvProdFound"
        if found > 1 then file.extra += " x" + found

      @emit "data", file
      null

  throughLangSrc : ()->

    startPipeline = coffee()

    cachedLangSrc = null

    pipeline = startPipeline.pipe es.through ( file )->

      newContent = file.contents.toString("utf8")

      # Drop the change if the content is the same
      if newContent is cachedLangSrc then return

      cachedLangSrc = newContent

      console.log Helper.compileTitle(), "lang-souce.coffee"

      ctx = vm.createContext({module:{}})
      vm.runInContext( newContent, ctx )

      buildLangSrc.run gruntMock, Helper.noop, ctx.module.exports
      null

    pipeline.pipe( gulp.dest(".") )

    gruntMock =
      log  :
        error : Helper.log
      file :
        write : ( p1, p2 ) =>
          cwd = process.cwd()
          pipeline.emit "data", new gutil.File({
            cwd      : cwd
            base     : cwd
            path     : p1
            contents : new Buffer( p2 )
          })
          null

    startPipeline

  throughCoffee : ()->

    conditionalCompile = gulpif( Helper.shouldLintCoffee, coffeelint( undefined, coffeelintOptions) )

    # Compile
    if GLOBAL.gulpConfig.enableCache
      coffeeBranch = cached("coffee")
      coffeeCompile = coffeeBranch.pipe( conditionalCompile )
    else
      coffeeCompile = coffeeBranch = conditionalCompile


    coffeeCompile = coffeeCompile
                    .pipe( StreamFuncs.throughCoffeeConditionalCompile() )
                    .pipe( coffee({sourceMap:GLOBAL.gulpConfig.coffeeSourceMap}) )

    pipeline = coffeeCompile
      # Log
      .pipe( es.through ( f )->
        console.log Helper.compileTitle( f.extra ), "#{f.relative}"
        @emit "data", f
      )
      # Jshint and report
      .pipe( gulpif Helper.shouldLintCoffee, StreamFuncs.jshint() )
      .pipe( gulpif Helper.shouldLintCoffee, StreamFuncs.lintReporter() )
      # Save
      .pipe( gulp.dest(".") )

    if GLOBAL.gulpConfig.reloadJsHtml
      pipeline.pipe StreamFuncs.throughLiveReload()

    # calling pipe will add error listener to the pipeline.
    # Making the pipeline stop after an error occur.
    # But I want the coffee pipeline still works even after compilation fails.
    coffeeCompile.removeAllListeners("error")
    coffeeCompile.on("error", StreamFuncs.coffeeErrorPrinter)

    coffeeBranch

  workStream : null
  workEndStream : null
  createStreamObject : ()->
    # Create Work Stream
    if StreamFuncs.workStream then return

    StreamFuncs.workStream    = es.through()
    StreamFuncs.workEndStream = StreamFuncs.setupCompileStream StreamFuncs.workStream
    null

  setupCompileStream : ( stream )->

    # Branch Used to handle asset files ( image / css / fonts / etc. )
    assetBranch = StreamFuncs.throughLiveReload()

    # Branch Used to handle lang-source.js
    langSrcBranch = StreamFuncs.throughLangSrc()

    # Branch Used to handle coffee files
    coffeeBranch = StreamFuncs.throughCoffee()

    # Setup compile branch
    langeSrcBranchRegex   = /lang-source\.coffee/
    coffeeBranchRegex     = /\.coffee$/

    if GLOBAL.gulpConfig.reloadJsHtml
      liveReloadBranchRegex = /(src.assets)|(\.js$)|(\.html$)/
    else
      liveReloadBranchRegex = /src.assets/

    stream.pipe( gulpif langeSrcBranchRegex,   langSrcBranch, true )
          .pipe( gulpif coffeeBranchRegex,     coffeeBranch,  true )
          .pipe( gulpif liveReloadBranchRegex, assetBranch,   true )



changeHandler = ( path )->
  Helper.watchIsWorking = true

  if not fs.existsSync( path ) then return

  stats = fs.statSync( path )
  # If it's a folder, do nothing
  if stats.isDirectory() then return

  if GLOBAL.gulpConfig.verbose then console.log "[Change]", path

  if path.match /src.assets/
    # No need to read file for assets folder
    StreamFuncs.workStream.emit "data", { path : path }
  else
    fs.readFile path, ( err, data )->
      if not data then return

      StreamFuncs.workStream.emit "data", new gutil.File({
        cwd      : Helper.cwd
        base     : Helper.cwd
        path     : path
        contents : data
      })
      null
  null

checkWatchHealthy = ( watcher )->
  # Do not ensure watch for polling.
  if GLOBAL.gulpConfig.pollingWatch then return

  # Try to detect if watch is not working
  fs.writeFileSync( "./src/robots.txt", fs.readFileSync("./src/robots.txt") )
  setTimeout ()->
    if not Helper.watchIsWorking
      console.log "[Info]", "Watch is not working. Will retry in 2 seconds."
      Helper.notify "Watch is not working. Will retry in 2 seconds."
      watcher.removeAllListeners()

      setTimeout (()-> watch()), 2000

  , 500

# Tasks
watch = ()->
  ++Helper.watchRetry
  if Helper.watchRetry > 3
    console.log gutil.colors.red.bold "[Fatal]", "Watch is still not working. Please manually retry."
    Helper.notify "Watch is still not working. Please manually retry."
    return

  Helper.createLrServer()

  StreamFuncs.createStreamObject()

  watcher = Helper.createWatcher()
  watcher.on "add",    changeHandler
  watcher.on "change", changeHandler
  watcher.on "error", (e)-> console.log "[error]", e

  checkWatchHealthy( watcher )
  null


compileDev = ( allCoffee )->
  if allCoffee
    path = ["src/**/*.coffee", "!src/test/**/*" ]
  else
    path = ["src/**/*.coffee", "!src/test/**/*", "!src/service/**/*", "!src/model/**/*" ]

  deferred = Q.defer()

  StreamFuncs.createStreamObject()

  compileStream = gulp.src( path, {cwdbase:true} ).pipe es.through ( f )->
    # Re-pipe the data to the workStream
    StreamFuncs.workStream.emit "data", f
    null

  compileStream.once "end", ()-> deferred.resolve()

  deferred.promise


module.exports =
  watch      : watch
  compileDev : compileDev
