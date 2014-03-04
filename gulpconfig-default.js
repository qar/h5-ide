
// Config that will be used by gulp
module.exports = {

  // The port that will be used by the static file server
  staticFileServerPort : 3000

  // The port that will be used by the livereload server
  , livereloadServerPort : 35729

  // If true, the livereload server will reload the page when js/coffee/html changes.
  , reloadJsHtml : false

  // If true, the compiler will generate coffee source map in the same folder
  , coffeeSourceMap : false

  // If true, the compiler will print additional infomation
  , verbose : false

  // If true, it will use notifier of the system to show error info.
  , enbaleNotifier : true

  // If true, gulp will only compile files that changes content.
  // If false, gulp will compile when a file is saved, even if the content is not modified.
  , enableCache : true

  // If pollingWatch is true, it will force to use polling when watching file changes.
  // If pollingWatch is false, it will force to use native file event
  // Pros of using native file event:
  //   Sometimes changes will not be detected. For example, git checkout.
  // Cons of using native file event:
  //   Fast, CPU-friendly, Won't open too many files at the same time.
  , pollingWatch : false


};
