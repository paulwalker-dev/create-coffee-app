degit = require 'degit'
fs = require 'fs'
prompts = require 'prompts'

repos = [
  {
    title: 'Coffeescript'
    value: 'base'
  }
  {
    title: 'Coffeescript-React'
    value: 'react'
  }
  {
    title: 'Coffeescript-Svelte'
    value: 'svelte'
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
    name: 'type'
    message: 'Type'
    choices: repos
    initial: 0
  }
]

bootstrap = ({ name, type }) ->
  repo = degit "LegoLoverGo/create-coffee-app/templates/#{type}",
    cache: off
    verbose: off
    force: off

  assets = degit 'LegoLoverGo/create-coffee-app/templates/assets',
    cache: off
    verbose: off
    force: off

  console.log 'Cloning template'
  await repo.clone name

  console.log 'Getting assets'
  await assets.clone "#{name}/src/assets"

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

  return if !responce.type?
  
  if fs.existsSync "./#{responce.name}"
    confirm "OVERRIDE '#{responce.name}'", ->
      fs.rmSync "./#{responce.name}",
        force: on
        recursive: on
      clone(responce)
  else
    clone(responce)

main()