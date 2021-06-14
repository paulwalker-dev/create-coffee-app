{ hideBin } = require 'yargs/helpers'
degit = require 'degit'
fs = require 'fs'
prompts = require 'prompts'
util = require 'util'
yargs = require 'yargs/yargs'

argv = yargs hideBin process.argv
  .usage 'Usage: $0 [directory] [options]'
  .options
    't':
      alias: 'template'
      type: 'string'
      group: 'General:'
      desc: 'Template Name'
    'f':
      alias: 'force'
      type: 'boolean'
      group: 'General:'
      desc: 'Bypass override prompt'
    'r':
      alias: 'repo'
      type: 'string'
      default: 'LegoLoverGo/create-coffee-app'
      group: 'Dev:'
      desc: 'Repo on Github to use'
      hidden: yes
    'b':
      alias: 'branch'
      type: 'string'
      default: 'main'
      group: 'Dev:'
      desc: 'Branch of the repo to use'
      hidden: yes
  .showHidden 'show-dev', 'Show dev flags'
  .help 'h'
  .alias 'h', 'help'
  .argv

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

questions = []

if !argv._[0]?
  questions.push
    type: 'text'
    name: 'name'
    message: 'Project Name'
    initial: 'coffee-project'

if !argv.t?
  questions.push
    type: 'select'
    name: 'type'
    message: 'Type'
    choices: repos
    initial: 0

clone = ({ name, type }) ->
  repo = degit "#{argv.r}/templates/#{type}##{argv.b}",
    cache: off
    verbose: off
    force: off

  assets = degit "#{argv.r}/templates/assets##{argv.b}",
    cache: off
    verbose: off
    force: off

  console.log 'Cloning template'
  await repo.clone name

  console.log 'Getting assets'
  await assets.clone "#{name}/src/assets"

  console.log 'Editing package.json'
  pkg = JSON.parse fs.readFileSync("#{name}/package.json").toString()
  pkg.name = name
  pkg.version = '0.0.0'
  fs.writeFileSync "#{name}/package.json",
    JSON.stringify(pkg, null, 2)

  console.log 'Done'
  process.exit()

confirm = (msg, callback) ->
  if argv.f
    callback()
    return

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
  responce.name ?= argv._[0]
  responce.type ?= argv.t

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