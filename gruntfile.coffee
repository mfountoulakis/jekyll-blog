"use strict"

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-bower-task"
  grunt.loadNpmTasks "grunt-jekyll"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-exec"

  grunt.initConfig

    copy:
      jquery:
        files: [{
          expand: true
          cwd: "bower_components/jquery/dist/"
          src: "jquery.min.js"
          dest: "vendor/js/"
        }]
      materialize:
        files: [{
          expand: true
          cwd: "bower_components/materialize/dist/css/"
          src: "materialize.min.css"
          dest: "vendor/css/"
        },
        {
          expand: true
          cwd: "bower_components/materialize/dist/js/"
          src: "materialize.min.js"
          dest: "vendor/js/"
        }]

    exec:
      jekyll:
        cmd: "jekyll build --trace"

    watch:
      options:
        livereload: true
      source:
        files: [
          "_drafts/**/*"
          "_includes/**/*"
          "_layouts/**/*"
          "_posts/**/*"
          "css/**/*"
          "js/**/*"
          "_config.yml"
          "*.html"
          "*.md"
        ]
        tasks: [
          "exec:jekyll"
        ]

    jekyll:
      server:
        options:
          port: 4000
          base: '_site'
          baseurl: '/manos'

  grunt.registerTask "build", [
    "copy"
    "exec:jekyll"
  ]

  grunt.registerTask "serve", [
    "build"
    "jekyll:server"
    "watch"
  ]

  grunt.registerTask "default", [
    "serve"
  ]