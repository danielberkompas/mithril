<% MixTemplates.ignore_file_unless(assigns[:asset_bundler] == "webpack") %>
var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var webpack = require('webpack')
var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

module.exports = {
  entry: {
    'app': ['./js/app.js', './css/app.<%= assigns[:sass_syntax] %>']
  },
  output: {
    path: path.resolve(__dirname, '../priv/static/'),
    filename: 'js/[name].js'
  },
  devtool: 'source-map',
  resolve: {
    extensions: ['.js', '.jsx']
  },
  module: {
    rules: [{
      test: /\.(sass|scss)$/,
      include: /css/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [{
          loader: 'css-loader'
        }, {
          loader: 'sass-loader',
          options: {
            sourceComments: !isProduction
          }
        }]
      })
    }, {
      test: /\.(js|jsx)$/,
      include: /js/,
      use: [
        { loader: 'babel-loader' }
      ]
    }]
  },
  plugins: [
    new CopyWebpackPlugin([{ from: './static' }]),
    new ExtractTextPlugin('css/app.css'),
  ]
}