var Figlet = require("./lib/asciimo").Figlet;

var puts = require("sys").puts;
Figlet.write("Figlet JS", "doh", function(str) {
	puts(str);
});

