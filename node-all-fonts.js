/*
asciimo - node-demo.js

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

var sys = require('sys');
var fs = require('fs');
var asciimo = require('./lib/asciimo').Figlet;

var fonts,
    text = "hello, i am asciimo";

function display_font(font){
  var current_font = font.substr(0,font.length-4); // remove .flf extension
  asciimo.write(text, current_font, function(art, current_font){
      sys.puts(current_font + '\n');
      sys.puts(art);
      if(fonts.length){
        display_font(fonts.pop());
      }
  });
}

fs.readdir('./fonts', function ( err, files ) {
    fonts = files;
    // filter any files that aren't .flf files
    fonts = fonts.filter(function(e){
      if(e.substr(e.length-4,4)=='.flf'){
        return e;
      }
    }).reverse(); // reverse the collection so it prints in alphabet order
    
    var font = fonts.pop();
    display_font(font);
});