
<table>
  <tr valign = "middle">
    <td><img src = "http://imgur.com/kmbjB.png"/></td>
    <td>
      <br/>
      <h1>greetings, i am asciimo</h1>
      <h1>i create awesome ascii art with javascript!</h1>
      <h1>i work in node.js and the browser</h1>
    </td>    
  </tr>


</table>

<div align = "center"><img src = "http://i.imgur.com/CDKZc.png" border = "0"/></div>
### 100% open-source. the truth is in the commit logs. people don't like to read
### online demo @ <a href = "http://asciimo.com" target = "_blank">http://asciimo.com</a>
### font files are FIGlet .flf files <a href = "http://en.wikipedia.org/wiki/FIGlet">http://en.wikipedia.org/wiki/FIGlet</a>
## USAGE

### node.js - 
        var sys = require('sys');
        var asciimo = require('./lib/asciimo');
        var colors = require('./lib/colors'); // add colors for fun

        // pick the font file
        var font = 'soft.flf';
        // set text we are going to turn into leet ascii art
        var text = "hello, i am asciimo!";

        asciimo.text(font, text, function(art){
          sys.puts(art.magenta);
          var anotherFont = 'Banner.flf';
          var moreText = "i turn text into leet ascii art";

          asciimo.text(anotherFont, moreText, function(art){
            sys.puts(art.red);
            var anotherFont = 'Colossal.flf';
            var moreText = "300+ fonts supported";

            asciimo.text(anotherFont, moreText, function(art){
              sys.puts(art.green);  
              var anotherFont = 'Tinker_Toy.flf';
              var moreText = "Marak Squires 2010";

              asciimo.text(anotherFont, moreText, function(art){
                sys.puts(art.yellow);  
                sys.puts('if you can\'t see the text try making your console larger'.red.underline)
              });

            });

          });

        });

### browser - 

          // the current browser demo requires jQuery. you could easily make it work without jQuery.
          // we'll have to figure out a smarter way to make this library work dual-sided. 
          // also, i haven't included the DOM elements here so you really should just check out the index.html file

          <script type="text/javascript" src="./lib/asciimo.js"></script>

          <!-- fonts.js doesn't contain the fonts, just the font names. fonts are located in /asciimo/fonts/   -->
          <script type="text/javascript" src="./lib/fonts.js"></script>

          <!-- jquery not required, just use this this demo page -->
          <script type="text/javascript" src="./lib/jquery.js"></script>


          <script type="text/javascript">

            // not used, could be implemented, maybe AJAX browser cache is good enough? do some research!
            var fontCache = {};

            $(document).ready(function(){

              // populate the select box
              for(var i = 0; i<asciimoFonts.length; i++){
                var fontTitle = asciimoFonts[i].replace('.flf','').replace('.aol',''); // remove the file extentions for the title
                $('#fontSelector').append('<option value = "'+asciimoFonts[i]+'">'+fontTitle+'</option>');
              }
    
              // protip : understanding the following two blocks of code will make you jQuery ninja
    
              /***** NAMED EVENTS *****/

                // change the font and load a new font via jQuery async AJAX request
                $(document).bind('##CHANGE_FONT##', function(e, data){
                  var font = data.fontName; 
                  $.get('./fonts/' + font,function(rsp){
                    loadFont(rsp); // call asciimo API method, we can make this better. just file a support issue!
                    $(document).trigger('##RENDER_ASCII_ART##'); // the font has changed, lets call the render ascii art event
                  });
                });
  
                $(document).bind('##RENDER_ASCII_ART##', function(e){
                  $('#asciiArt').html('<pre>' + createLargeText($('#theCode').val()) + '</pre>');
                });

              /**** END NAMED EVENTS ****/

              /**** BIND UI EVENTS ****/

                // select box change
                $('#fontSelector').change(function(){
                  $(document).trigger('##CHANGE_FONT##', {"fontName":$(this).val()})
                });
    
                // you would think jQuery.change() would cover the keypress event on select boxes? 
                $("#fontSelector").keypress(function (){
                  $(document).trigger('##CHANGE_FONT##', {"fontName":$(this).val()})
                });

                // keyup on textarea
                $('#theCode').keyup(function(e){
                  $(document).trigger('##RENDER_ASCII_ART##');
                });
    
                $('#run').click(function(e){
                  $(document).trigger('##RENDER_ASCII_ART##');
                });

              /**** END UI BIND EVENTS ****/

              // little bit of a onReady hack. i'll fix the API a bit so this can be done better
              $(document).trigger('##CHANGE_FONT##', {"fontName":'Doh.flf'});
              $('#fontSelector').val('Doh.flf');

            });
          </script>


## Authors
#### Marak Squires, 
####AWESOME FIGlet parser by <a href = "http://github.com/scottgonzalez/figlet-js.git">Scott Gonzalez</a>

