/*
asciimo - build.js

Copyright (c) 2010 Marak Squires

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/


/* use this file to build the font.json file based on the fonts directory */
var util = require('util');
var fs = require('fs');

var files = fs.readdirSync('../fonts/');
var out = [];

files.forEach(function(i){
  var k = i.replace('.flf','');
  out.push(k);
});


var code = "Figlet.fontList = " + JSON.stringify(out,true,"  ") + ';';
fs.writeFile('../lib/fonts.js',code,function(err, data){
  if(err){
    util.puts('fonts.js couldn\'t generate');
  }
  else{
    util.puts('fonts.js written!');
  }
});
