path = require 'path'

{
    series,
    parallel,
    src,
    dest,
    watch,
} = require 'gulp'

coffee = require 'gulp-coffee'
clean = require 'gulp-clean'
less = require 'gulp-less'
pug = require 'gulp-pug'

build_styles = ()->
    src('src/styles/*.less')
        .pipe(
            less
               paths: [
                    path.join __dirname, 'src/vendor'
               ]

        )
        .pipe dest 'public/css/'

build_scripts = ()->
    src('src/scripts/*.coffee')
        .pipe(
            coffee
                bare: true
        )
        .pipe dest 'public/js/'

build_templates = ()->
    src([
        'src/templates/*.pug'
        '!src/templates/_base.pug'
    ])
        .pipe(
            pug {}
        )
        .pipe dest 'public/'

copy_css_assets = ()->
    src(['assets/css/*.css'])
        .pipe dest 'public/css/'

copy_font_assets = ()->
    src(['assets/fonts/*.ttf'])
        .pipe dest 'public/fonts/'

copy_assets = parallel copy_css_assets,
                       copy_font_assets

build = parallel build_styles,
                 build_templates,
                 build_scripts,
                 copy_assets

exports.copy_assets = copy_assets

clean = ()->
    src(['public/js/*.js'], {read: false})
        .pipe(clean())


exports.build = build
exports.watch = ()->
    watch ['src/scripts/*', 'src/templates/*', 'src/styles/*'], (cb)->
        do build
        cb()

exports.default = series build
