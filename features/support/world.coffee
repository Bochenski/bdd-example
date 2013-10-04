assert = require 'assert'
webdriver = require 'selenium-webdriver'
protractor = require 'protractor'

worldDefinition = () ->

  ptor = null
  driver = null

  class World
    constructor: (callback) ->
      @browser = ptor
      @By = protractor.By
      @assert = assert
      callback()

  capabilities = webdriver.Capabilities.chrome().merge
    username: process.env.SAUCE_USERNAME
    accessKey: process.env.SAUCE_ACCESS_KEY
    name: 'Angular Cuke protractor test'
    browserName: 'Chrome'
    platform: 'Windows 7'
    'record-video': true
    'tunnel-identifier': process.env.DRONE_BUILD_NUMBER

  @BeforeFeatures (event, callback) ->
    driver = new webdriver.Builder().
    usingServer('http://localhost:4445/wd/hub').
    withCapabilities(capabilities).build()

    ptor = protractor.wrapDriver driver
    callback()

  @AfterFeatures (event, callback) ->
    driver.quit().then (err) ->
      callback err

  @World = World

module.exports = worldDefinition