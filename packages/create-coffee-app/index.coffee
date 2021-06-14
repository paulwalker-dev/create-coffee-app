{ hideBin } = require 'yargs/helpers'
degit = require 'degit'
fs = require 'fs'
prompts = require 'prompts'
util = require 'util'
yargs = require 'yargs/yargs'

argv = yargs hideBin process.argv
  .usage 'Usage: npm init coffee-app@latest -- [directory] [options]'
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
      default: 'add-testing'
      group: 'Dev:'
      desc: 'Branch of the repo to use'
      hidden: yes
    'a':
      alias: 'add-testing'
      type: 'boolean'
      group: 'General:'
      desc: 'Configure Testing'
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

if !argv.a?
  questions.push
    type: 'toggle'
    name: 'testing'
    message: 'Configure Testing'
    initial: no
    active: 'yes'
    inactive: 'no'

clone = ({ name, type, testing }) ->
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

  if testing
    console.log 'Configuring tests'

    pkg.devDependencies = {
      'vite-web-test-runner-plugin': '^0.0.3'
      '@web/test-runner-playwright': '^0.8.6'
      '@web/test-runner': '^0.13.11'
      "@esm-bundle/chai": '^4.3.4'
      ...pkg.devDependencies
    }

    pkg.scripts.test =
      'coffee -c test && wtr test/**/*.test.js --node-resolve'

    pkg.scripts['test:watch'] =
      "#{pkg.scripts.test} --watch"
  else
    console.log 'Removing test files'

    fs.rmSync "#{name}/test",
      force: on
      recursive: on
    fs.rmSync "#{name}/web-test-runner.config.js"

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
    initial: no
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
  responce.testing ?= argv.a

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