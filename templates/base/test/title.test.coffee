import { expect } from '@esm-bundle/chai'

describe 'App', ->
  before () ->
    appDiv = document.createElement 'div'
    document.body.appendChild appDiv
    appDiv.id = 'app'

    `await import('../src/index.coffee')`
    await return

  describe 'title', ->
    it "equals 'Create Coffee App'", ->
      expect document.querySelector('#app h1').innerText
        .to.equal 'Create Coffee App'