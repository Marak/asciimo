var Figlet = require("./lib/figlet-node").Figlet;

var puts = require("sys").puts;
Figlet.write("Figlet JS", "doh", function(str) {
	puts(str);
});

