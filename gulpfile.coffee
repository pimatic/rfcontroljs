gulp = require('gulp')
watch = require('gulp-watch')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')
mocha = require('gulp-mocha')
coffeelint = require('gulp-coffeelint')
istanbul = require('gulp-coffee-istanbul')

gulp.task('default', ->
  watch('src/**/*.coffee', verbose: true)
    .pipe(plumber()) # This will keeps pipes working after error event
    .pipe(coffeelint({
      no_unnecessary_fat_arrows: {
        level: 'ignore'
      },
      max_line_length: {
        value: 120
      }
    }))
    .pipe(coffeelint.reporter())
    .pipe(coffee(bare: yes))
    .pipe(gulp.dest('lib'))
)


gulp.task 'build', ->
  gulp.src('src/**/*.coffee')
  .pipe(plumber()) # This will keeps pipes working after error event
  .pipe(coffeelint({
    no_unnecessary_fat_arrows: {
      level: 'ignore'
    },
    max_line_length: {
      value: 120
    }
  }))
  .pipe(coffeelint.reporter())
  .pipe(coffee(bare: yes))
  .pipe(gulp.dest('lib'))


gulp.task 'test', ->
  gulp.src('test/*.coffee', read: false)
    .pipe(mocha(
      reporter: 'spec'
    ))

gulp.task 'coverage', ->
  gulp.src('src/**/*.coffee')
  .pipe istanbul({includeUntested: true}) # Covering files
  .pipe istanbul.hookRequire()
  .on 'finish', ->
    gulp.src 'test/*.coffee'
    .pipe mocha reporter: 'spec'
    .pipe istanbul.writeReports() # Creating the reports after tests run


gulp.task 'docs', ->
  controller = require './src/controller'
  protocols = controller.getAllProtocols()
  header = """
    <!-- This file is generated automatically don't edit it -->
    Supported Protocols
    ===================

  """


  main = ""
  table = "<table><tr><th>Protocol</th><th>Type</th><th>Brands</th></tr>"
  for p in protocols
    supports = {
      temperature: p.values.temperature
      humidity: p.values.humidity
      state: p.values.state
      all: p.values.all
      battery: p.values.battery
      presence: p.values.presence
    }

    for k, v of supports
      if v?
        delete p.values[k]
      else
        delete supports[k]

    brands = JSON.stringify(p.brands)
    brands = brands.substring(1, brands.length-1).replace(/\"/g, '').replace(/\,/g, ', ')
    if brands.length is 0 then brands = '?'

    options = ""
    for name, info of p.values
      options += """  * **#{name}** (#{info.type})\n"""
    
    if options.length is 0 then options = "none\n"
    else options = "\n#{options}\n"

    supportsList = ""
    for name, info of supports
      supportsList += """  * #{name}\n"""
    
    if supportsList.length is 0 then supportsList = "none\n"
    else supportsList = "\n#{supportsList}\n"

    table += """
      <tr><td>#{p.name}</td><td>#{p.type}</td><td>#{brands}</td></tr>
    """
    main += """
      #{p.name}
      ---------
      __Type__: #{p.type}

      __Brands__: #{brands}

      __Protocol Options__:
      #{options}
      __Supports__:
      #{supportsList}

    """

  table += "</table>\n"
  require('fs').writeFileSync('./protocols.md', header + table + main)

