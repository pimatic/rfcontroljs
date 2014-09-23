gulp = require('gulp')
watch = require('gulp-watch')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')
mocha = require('gulp-mocha')
coffeelint = require('gulp-coffeelint')

gulp.task('default', ->
  watch(glob: 'src/**/*.coffee', verbose: true)
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

gulp.task 'test', ->
  gulp.src('test/*.coffee', read: false)
    .pipe(mocha(
      reporter: 'spec'
    ))

gulp.task 'coverage', ->
  gulp.src('test/*.coffee', read: false)
    .pipe(coffee(bare: yes))
    .pipe(cover.instrument({
      pattern: ['**/test/*'],
      debugDirectory: 'debug'
    }))
    .pipe(mocha({}))
    .pipe(cover.report({
      outFile: 'coverage.html'
    }));


gulp.task 'docs', ->
  controller = require './src/controller'
  protocols = controller.getAllProtocols()
  output = """
    <!-- This file is generated automatically don't edit it -->
    Supported Protocols
    ===================

  """
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

    output += """
      #{p.name}
      ---------
      __Type__: #{p.type}

      __Brands__: #{brands}
      
      __Protocol Options__:
      ```json
      #{JSON.stringify(p.values, null, '  ')}
      ```
      __Supports__:\n
      ```json
      #{JSON.stringify(supports, null, '  ')}
      ```

    """

    require('fs').writeFileSync('./protocols.md', output)

