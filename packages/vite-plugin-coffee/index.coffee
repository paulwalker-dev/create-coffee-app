coffee = ({ jsx }) ->
  name: 'coffee'
  transform: (src, id) ->
    if /\.coffee$/.test id
      { js, sourceMap } = CoffeeScript.compile src,
        sourceMap: on
        transpile: if jsx
          presets: ['@babel/react']

      code: js
      map: sourceMap

export default coffee