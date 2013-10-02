module.exports = ->

  @Given /^I am on the homepage$/, (callback) ->
    @browser.get('http://localhost:9001').then ->
      callback()

  @When /^I change my name to "(.*)"$/, (name, callback) ->
    el = @browser.findElement(@By.tagName 'input')
    el.clear()
    el.sendKeys(name).then ->
      callback()

  @Then /^I should see my name as "(.*)"$/, (name, callback) ->
    @browser.findElement(@By.tagName 'span').getText().then (text) =>
      @assert.equal text, name
      callback()
