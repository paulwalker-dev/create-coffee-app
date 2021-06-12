degit = require 'degit'
fs = require 'fs'
prompts = require 'prompts'

repos = [
  {
    title: 'Coffeescript-Vanilla'
    value: 'LegoLoverGo/vite-coffee'
  }
  {
    title: 'Coffeescript-React'
    value: 'LegoLoverGo/vite-coffee-react'
  }
]

questions = [
  {
    type: 'text'
    name: 'name'
    message: 'Project Name'
    initial: 'coffee-project'
  },
  {
    type: 'select'
    name: 'repo'
    message: 'Type'
    choices: repos
    initial: 0
  }
]

clone = ({ name, repo }) ->
  emitter = degit repo,
    cache: off
    verbose: off
    force: off

  await emitter.clone name
  console.log 'Done'

confirm = (msg, callback) ->
  { confirmed } = await prompts [
    type: 'toggle'
    name: 'confirmed'
    message: ''
    initial: false
    active: 'yes'
    inactive: 'no'
    onRender: (kleur) ->
      @msg = kleur.red msg
  ]
  
  return if !confirmed
  callback()

main = ->
  responce = await prompts(questions)

  return if !responce.repo?
  
  if fs.existsSync "./#{responce.name}"
    confirm "OVERRIDE '#{responce.name}'", ->
      fs.rmSync "./#{responce.name}",
        force: on
        recursive: on
      clone(responce)
  else
    clone(responce)

main()