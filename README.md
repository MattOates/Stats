Stats [![Build Status](https://travis-ci.org/MattOates/Stats.svg?branch=master)](https://travis-ci.org/MattOates/Stats)
=====

Perl6 statistics modules. Long term aim is to make a partial clone/ripoff of basic R functionality or Pandas from Python. Currently has some basic statistics functions revolving around averages.

##Contributing
Feel free to PR anything you want. Please add some tests to t/ for any new classes/features.
You can run the tests by doing:

```bash
prove -e 'perl6 -I ./lib' -lrv t/
```

##Examples

```perl6
use v6;
use Stats;

my @data = (1,2,3,4,5,6,6,3,2,9);

#Get some summary statistics similar to R
summary @data;

#Get the mean/median/mode
mean @data; median @data; mode @data;

#Get the quartiles/standard deviation of the data
iqr @data; sd @data;

```
