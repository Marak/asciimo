var Figlet = require("./figlet").Figlet;

Figlet.loadFont = function(name, fn) {
	require("fs").readFile("./fonts/" + name + ".flf", "utf-8", function(err, contents) {
		fn(contents);
	});
};

exports.Figlet = Figlet;

