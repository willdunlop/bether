const path = require('path');

module.exports = {
  //  The source code
  entry: path.join(__dirname, 'src/js', 'index.js'),
  //  The compiled code
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'buid.js'
  },
  module: {
    loaders: [{
      test: /\.css$/,
      loader: ['style-loader', 'css-loader'],
      include: /src/
    }, {
      test: /\.jsx?$/,
      loader: 'babel-loader',
      exclude: /node_modules/,
      query: {
        presets: ['es2015', 'react', 'stage-2']
      }
    }, {
      test: /\.json$/,
      loader: 'json-loader'
    }]
  }
}
