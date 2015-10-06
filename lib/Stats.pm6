use v6;
package Stats {

    #Mean average
    proto sub mean($ --> Real) is export {*}
    multi sub mean(Baggy $x --> Real) {
        ( [+] $x.pairs.map({.key * .value}) ) / $x.total;
    }
    multi sub mean(List $x --> Real) {
        ( [+] $x.list ) / $x.elems;
    }

    #Median average
    proto sub median($ --> Real) is export {*}
    multi sub median(Baggy $x --> Real) {
        #TODO Can do a lot better here by sorting by key and consuming half by value
        return median($x.kxxv.flat.list);
        my $n = ceiling $x.total / 2;
        if ($x.total % 2) {
            for $x.pairs.sort>>.kv -> $val, $freq {
                $n -= $freq;
                return $val if $n <= 0;
            }
        } else {
            my Real $prev;
            for $x.pairs.sort>>.kv -> $val, $freq {
                if $n - $freq <= 0 {
                    return $val if $n > 1;
                    say "On boundary of two bins using both values";
                    return ($val + $prev) / 2.0;
                }
                $n -= $freq;
                $prev = $val;
            }
        }

    }
    multi sub median(List $x --> Real) {
        my $data = $x.sort.list;
        if ($data.elems % 2) {
            return 0.0 + $data[$data.elems / 2];
        } else {
            return 0.0 + ($data[($data.elems / 2) -1] + $data[$data.elems / 2]) / 2.0
        }
    }

    #Mode average
    proto sub mode($ --> List) is export {*}
    multi sub mode(Baggy $x --> List) {
        my $mode_freq = $x.values.max;
        return $x.pairs.grep({.value == $mode_freq}).map({.key}).sort.list;
    }
    multi sub mode(List $x --> List) {
        return mode($x.Bag);
    }

    #Quartiles (Q1, Q2/Median, Q3)
    proto sub quartiles($ --> List) is export {*}
    multi sub quartiles(List $x --> List) {
        my $data = $x.sort.list;
        (
        median($data[0 .. floor($data.elems/2)-1]),
        median($data),
        median($data[ceiling($data.elems/2) .. $data.elems-1])
        )
    }

    #Inter-quartile range
    proto sub iqr($ --> Real) is export {*}
    multi sub iqr(List $x --> Real) {
        my ($q1,Any,$q2) = quartiles($x);
        return $q2-$q1;
    }

    #Variance
    proto sub variance($ --> Real) is export {*}
    multi sub variance(Baggy $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.pairs.map({ (.key - $mean)**2 * .value}) ) / $x.total;
    }
    multi sub variance(List $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.map({($_ - $mean)**2}) ) / $x.elems;
    }

    #Standarad Deviation
    proto sub sd($ --> Real) is export {*}
    multi sub sd(Baggy $x --> Real) {
        sqrt(variance($x));
    }
    multi sub sd(List $x --> Real) {
        sqrt(variance($x));
    }

    #Mean Absolute Deviation
    proto sub mean-ad($ --> Real) is export {*}
    multi sub mean-ad(Baggy $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.pairs.map({ abs(.key - $mean) * .value }) ) / $x.total;
    }
    multi sub mean-ad(List $x --> Real) {
        my $mean = mean($x);
        ( [+] $x.map({ abs($_ - $mean) }) ) / $x.elems;
    }

    #Median Absolute Deviation
    proto sub median-ad($ --> Real) is export {*}
    multi sub median-ad(Baggy $x --> Real) {
        my $median = median($x);
        #TODO look into using the Bag form of the median here too
        median( $x.pairs.map({ abs(.key - $median) xx .value }).list );
    }
    multi sub median-ad(List $x --> Real) {
        my $median = median($x);
        median( $x.map({ abs($_ - $median) }).list );
    }

    #Map data values to their zscores as a list of pairs
    proto sub zscores($ --> List) is export {*}
    multi sub zscores(Baggy $x --> List) {
        my $mean = mean($x);
        my $sd = sd($x);
        $x.pairs.map({$_.key => ($_.key - $mean) / $sd }).sort({$^a.value <=> $^b.value}).list;
    }
    multi sub zscores(List $x --> List) {
        my $mean = mean($x);
        my $sd = sd($x);
        $x.map({$_ => ($_ - $mean) / $sd }).sort({$^a.value <=> $^b.value}).squish(as => {.key}).list;
    }

    #Get the zscore for a new value given a previous sample of observations
    #This is a common way of ranking new observations on how over or under represented they are given a background
    proto sub zscore($,$ --> List) is export {*}
    multi sub zscore(Numeric $x, $X where $X.WHAT ~~ Baggy|List --> Real) {
        my $mean = mean($X);
        my $sd = sd($X);
        ($x - $mean) / $sd;
    }

    #Summary statistics Rlang style
    proto sub summary($ --> List) is export {*}
    multi sub summary(List $x --> List) {
        my $median = median($x);
        (
        'mean'=>mean($x),
        'sd'=>sd($x),
        'quartiles'=>quartiles($x),
        'min'=>$x.min,
        'max'=>$x.max,
        'median'=>median($x)
        )
    }

    #Calculate a binned histogram of the data
    proto sub hist($ --> List) is export {*}
    multi sub hist(List $x, :$breaks = '' --> List) {
        my $bin-width;
        given $breaks {
            when 'Doane' {*} #Looks cool but needs some other dist related functions
            when 'Square-root choice' { $bin-width = abs($x.max - $x.min) / sqrt($x.elems); }
            when 'Freedman-Diaconis' {*}
            when 'Rice' { $bin-width = abs($x.max - $x.min) / 2*($x.elems ** 1/3); }
            when 'Sturges' { $bin-width = abs($x.max - $x.min) / log($x.elems,2)+1; }
            when 'Scott' {*}
            default { fail "Unknown binning method."; }
        }
    }

}
