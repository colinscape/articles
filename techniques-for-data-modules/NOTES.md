Data gathered from [US Census Bureau](http://www.census.gov/genealogy/names/names_files.html).
Specifically, it is the [list of surnames](http://www.census.gov/genealogy/names/dist.all.last)
including only the first (name) column and third (cumulative frequency) column.

Wanted to get this data into CoffeeScript so I could play around with it and use it.

88799 pieces of data.

My initial thought was that yes, I could grab the raw data and parse it appropriately but it
would surely be faster to actually convert it into a module format and require it directly.
I soon learned my lesson.

To convert the raw data into a CoffeeScript module I used a spot of sed:
sed -e's/\t/\", \"cf\": /g' data.txt | sed -e 's/^/\  {\"name\": \"/g' | sed -e 's/$/\},/g' > data.coffee
which just replaces the tabs with commas, wraps names in quotes, makes each line an object, and
creates fields of "name" and "cf" (cumulative frequency). With this done, just need to add an extra line at 
the top of the form "module.exports = [", remove the final comman and an extra line at the bottom of "]"
to make a fully-fledged module.

This will convert something of the form
SMITH   1.006
JOHNSON 1.816
WILLIAMS        2.515
JONES   3.136
BROWN   3.757
DAVIS   4.237

to something of the form 

  {"name": "SMITH", "cf": 1.006},
  {"name": "JOHNSON", "cf": 1.816},
  {"name": "WILLIAMS", "cf": 2.515},
  {"name": "JONES", "cf": 3.136},
  {"name": "BROWN", "cf": 3.757},
  {"name": "DAVIS", "cf": 4.237},

Adding the necessary header and footer and not forgetting the last comma then leads to

module.exports = [
  {"name": "SMITH", "cf": 1.006},
  {"name": "JOHNSON", "cf": 1.816},
  {"name": "WILLIAMS", "cf": 2.515},
  {"name": "JONES", "cf": 3.136},
  {"name": "BROWN", "cf": 3.757},
  {"name": "DAVIS", "cf": 4.237}
]



Some stats:

Curious about the best way to get a module of data into node using CoffeeScript.

Seemed to be that it was faster to parse raw data than to arrange the data as a module.
Though this might have been a coffeescript issue - try again with just node.


Time required to compile the coffeescript into javascript:
time coffee -c data.coffee

real    101m10.187s



Time to read 88799 entries from ./rawWrapper: 189ms
Time to read 88799 entries from ./data.js: 1255ms
Time to read 88799 entries from ./jsonWrapper: 129ms
Time to read 88799 entries from ./data.coffee: 7434647ms

Ouch. Compiling the data.coffee file into JavaScript first would help, unfortunately
that seemed to be what took the vast majority of the time, taking over 100 minutes.



All of these are much faster than my original idea. But the parsing from JSON option
is the fastest, marginally beating parsing the raw data. The javascript module version
is slow but nowhere near as slow as the coffeescript module version.

Reasons? Well, the speed of parsing the raw data is nice. But what makes the
module versions so slow? Coffeescript is slower than JavaScript because it is
parsing in JavaScript while the JavaScript version is parsing in C (confusing!).
Because JSON is such a small subset of JavaScript probably explains the faster
parsing compared to the JavaScript module.

Raw parsing is quick because we just loop over the lines, and make a very
simple object - there is no great amount of computation required. Compare that
to building a complete parse tree for a 88799 line source file - there is 
a significant amount of computation required then. Likewise with JSON, while
I don't know how it works, there is probably no need for a parse tree to be
constructed and single pass over the contents is sufficient to create the
final object.

Lessons learned? If you want a pile of data in easily accessible module format
you might be better off wrapping the raw data with a script to construct
the object rather than coercing the data into a module form directly. If you
do go for the coercion route, convert it to a javascript module else you
might find yourself waiting a lot longer than you expect for a require to
complete.


Some more results:

Time to read 1 entries from ./rawWrapper: 5ms
Time to read 1 entries from ./data.js: 0ms
Time to read 1 entries from ./jsonWrapper: 4ms
Time to read 1 entries from ./data.coffee: 1ms


Time to read 10 entries from ./rawWrapper: 7ms
Time to read 10 entries from ./data.js: 0ms
Time to read 10 entries from ./jsonWrapper: 5ms
Time to read 10 entries from ./data.coffee: 3ms


Time to read 100 entries from ./rawWrapper: 4ms
Time to read 100 entries from ./data.js: 1ms
Time to read 100 entries from ./jsonWrapper: 2ms
Time to read 100 entries from ./data.coffee: 27ms


Time to read 1000 entries from ./rawWrapper: 5ms
Time to read 1000 entries from ./data.js: 9ms
Time to read 1000 entries from ./jsonWrapper: 5ms
Time to read 1000 entries from ./data.coffee: 326ms


Time to read 2000 entries from ./rawWrapper: 10ms
Time to read 2000 entries from ./data.js: 17ms
Time to read 2000 entries from ./jsonWrapper: 5ms
Time to read 2000 entries from ./data.coffee: 706ms


Time to read 3000 entries from ./rawWrapper: 10ms
Time to read 3000 entries from ./data.js: 30ms
Time to read 3000 entries from ./jsonWrapper: 7ms
Time to read 3000 entries from ./data.coffee: 1277ms


Time to read 4000 entries from ./rawWrapper: 12ms
Time to read 4000 entries from ./data.js: 43ms
Time to read 4000 entries from ./jsonWrapper: 7ms
Time to read 4000 entries from ./data.coffee: 2091ms


Time to read 10000 entries from ./rawWrapper: 18ms
Time to read 10000 entries from ./data.js: 108ms
Time to read 10000 entries from ./jsonWrapper: 28ms
Time to read 10000 entries from ./data.coffee: 9484ms


Time to read 20000 entries from ./rawWrapper: 39ms
Time to read 20000 entries from ./data.js: 233ms
Time to read 20000 entries from ./jsonWrapper: 52ms
Time to read 20000 entries from ./data.coffee: 131986ms


Time to read 40000 entries from ./rawWrapper: 71ms
Time to read 40000 entries from ./data.js: 396ms
Time to read 40000 entries from ./jsonWrapper: 77ms
Time to read 40000 entries from ./data.coffee: 1065446ms


Time to read 88799 entries from ./rawWrapper: 189ms
Time to read 88799 entries from ./data.js: 1255ms
Time to read 88799 entries from ./jsonWrapper: 129ms
Time to read 88799 entries from ./data.coffee: 7434647ms

Minimising the coffeescript module helps a lot too!

