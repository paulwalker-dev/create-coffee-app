import { expect } from '@esm-bundle/chai'
import React from "react";
import ReactDOM from "react-dom";
import App from "../src/App.coffee";

describe 'App', ->
  before =>
    appDiv = document.createElement 'div'
    appDiv.id = 'app'
    document.body.appendChild appDiv

    ReactDOM.render React.createElement(App),
      appDiv

  describe 'title', ->
    it "equals 'Create Coffee App'", ->
      expect document.querySelector('#app main h1').innerText
        .to.equal 'Create Coffee App'