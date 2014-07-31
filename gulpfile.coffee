gulp = require('gulp')
watch = require('gulp-watch')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')

gulp.task('default', ->
  watch(glob: 'src/**/*.coffee', verbose: true)
    .pipe(plumber()) # This will keeps pipes working after error event
    .pipe(coffee(bare: yes))
    .pipe(gulp.dest('lib'))
)