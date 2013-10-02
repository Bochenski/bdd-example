path = require 'path'

module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    env:
      test:
        src: '.env'

    clean:
      reset:
        src: ['bin']
      temp:
        src: ['temp']
      bin:
        src: ['bin/client']

    coffeeLint: 
      scripts:
        files: [
          {
            expand: true
            src: ['client/**/*.coffee']
          }
          {
            expand: true
            src: ['server/**/*.coffee']
          }
        ]
        options:
          indentation:
            value: 2
            level: 'error'
          no_plusplus: 
            level: 'error'
      tests:
        files: [
          {
            expand: true
            src: ['test/**/*.coffee']
          }
        ]
        options:
          indentation:
            value: 2
            level: 'error'
          no_plusplus: 
            level: 'error'
    coffee:
      scripts:
        expand: true
        cwd: 'client/coffee'
        src: ['**/*.coffee']
        dest: 'temp/client/js/'
        ext: '.js'
        options:
          bare: true

    ngTemplateCache:
      views:
        files:
          './temp/client/js/views.js': './client/views/*.html'
        options:
          trim: './client'

    copy:
      dev:
        expand: true
        cwd: 'temp/'
        src: ['**']
        dest: 'bin'
      components:
        flatten: true
        expand: true
        cwd: 'bower_modules'
        src: [
          'angular/angular.js'
        ]
        dest: 'temp/client/js/libs'
    template:
      dev:
        dest: 'bin/client/index.html'
        src: 'client/index.template'
        environment: 'dev'
      prod:
        dest: 'temp/client/index.html'
        src: '<%= template.dev.src %>'
        environment: 'prod'
      test:
        dest: '<%= template.dev.dest %>'
        src: '<%= template.dev.src %>'
        environment: 'test'   

    # optimizes files managed by RequireJS
    requirejs:
      scripts:
        options:
          baseUrl: 'temp/client/js/'
          findNestedDependencies: true
          logLevel: 0
          mainConfigFile: 'temp/client/js/main.js'
          name: 'main'
          onBuildWrite: (moduleName, path, contents) ->
            modulesToExclude = ['main']
            shouldExcludeModule = modulesToExclude.indexOf(moduleName) >= 0

            if (shouldExcludeModule)
              return ''

            return contents
          # optimize: 'uglify'
          optimize: 'none'
          out: 'bin/client/js/scripts.min.js'
          preserveLicenseComments: false
          skipModuleInsertion: true
          uglify:
            no_mangle: false  

    connect:
      dev:
        options:
          hostname: '*'
          keepalive: true
          port: 9001
          base: 'bin/client'
      test:
        options:
          hostname: '*'
          port: 9001
          base: 'bin/client'
    cucumberjs:
      files: 'features/*.feature'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-cucumber'
  grunt.loadNpmTasks 'grunt-gint'

  grunt.registerTask 'server', [
    'connect:dev'
  ]

  grunt.registerTask 'build', [
    'clean'
    'coffeeLint'
    'coffee'
    'ngTemplateCache'
    'copy:components'
    'requirejs'
    'template:dev'
    'clean:temp'
  ]

  grunt.registerTask 'test', [
    'env:test'
    'connect:test'
    'cucumberjs'
  ]

  grunt.registerTask 'default', [
    'build'
    'test'
    'clean:bin'
  ]
