module.exports = {
  productionSourceMap: false,
  transpileDependencies: ['crc'],
  devServer: {
    proxy: {
      '/api': {
        target: 'http://localhost:8800'
      },
      '/ws': {
        target: 'http://localhost:8801',
        ws: true,
        changeOrigin: true
      }
    }
  },
  configureWebpack: {
    devtool: process.env.NODE_ENV=='development' &&
      'cheap-module-eval-source-map',
    output: { globalObject: 'this' }
  },
  chainWebpack: (config) => {
    config.plugins.delete('prefetch')
    config.plugins.delete('preload')
    config.module
      .rule('html')
      .test(/\.html$/)
      .use('html-loader')
      .loader('html-loader')
  }
}
