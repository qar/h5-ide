(function() {
  var delimeterMap, es, indexOf, path;

  path = require("path");

  es = require("event-stream");

  indexOf = require("./indexof");

  delimeterMap = {
    ".coffee": "### env ###",
    ".js": "/* env */",
    ".html": "<!-- env -->",
    ".hbs": "<!-- env -->",
    ".partials": "<!-- env -->"
  };

  module.exports = function(isProduction) {
    var replaceKey;
    replaceKey = isProduction ? "dev" : "prod";
    return es.through(function(file) {
      var buffer, delimeter, e_delimeter, endIndex, found, index, s_delimeter;
      delimeter = delimeterMap[path.extname(file.path)];
      if (!delimeter) {
        return this.emit("data", file);
      }
      s_delimeter = delimeter.replace("env", "env:" + replaceKey);
      e_delimeter = delimeter.replace("env", "env:" + replaceKey + ":end");
      buffer = file.contents;
      index = 0;
      found = 0;
      while ((index = indexOf(buffer, s_delimeter, index)) !== -1) {
        if (GLOBAL.gulpConfig.verbose) {
          console.log("[EnvProdFound]", file.relative);
        }
        endIndex = indexOf(buffer, e_delimeter, index + s_delimeter.length);
        if (endIndex === -1) {
          console.log("[Missing EnvProdEnd]");
          break;
        } else if (GLOBAL.gulpConfig.verbose) {
          console.log("[EnvProdEndFound]", file.relative);
        }
        index += s_delimeter.length - 3;
        endIndex += 3;
        while (index <= endIndex) {
          buffer[index] = 32;
          ++index;
        }
        index += e_delimeter.length - 3;
        ++found;
      }
      if (found) {
        file.extra = "EnvProdFound";
        if (found > 1) {
          file.extra += " x" + found;
        }
      }
      this.emit("data", file);
      return null;
    });
  };

}).call(this);
