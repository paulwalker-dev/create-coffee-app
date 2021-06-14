import { expect } from '@esm-bundle/chai'
import App from '../src/App.svelte'

describe 'App', ->
  before =>
    appDiv = document.createElement 'div'
    appDiv.id = 'app'
    document.body.appendChild appDiv

    app = new App
      target: appDiv

  describe 'title', ->
    it "equals 'Create Coffee App'", ->
      expect document.querySelector('#app main h1').innerText
        .to.equal 'Create Coffee App'