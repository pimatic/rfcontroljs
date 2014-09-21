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