use v6;
use Test;
plan 18;

#Basic sanity tests for the stats functions, no real coverage of edge cases
use Stats;

{
    my @list_x = 1,2,3,3,4,5,5,6,7;
    my $baggy_x = @list_x.Bag;
    ok mean(@list_x) == 4.0, 'Mean was correctly calculated.';
    ok median(@list_x) == 4.0, 'Median was correctly calculated.';
    ok mode(@list_x) eqv (3, 5), 'Mode was correctly calculated.';
    ok iqr(@list_x) == 3.0, 'Inter-quartile range correctly calculated.';
    ok quartiles(@list_x) eqv $(2.5, 4.0, 5.5), 'Quartiles correctly calculated.';
    ok variance(@list_x) == 10/3, 'Variance correctly calculated.';
    ok sd(@list_x) == sqrt(10/3), 'Standard deviation correctly calculated.';
    ok mean-ad(@list_x) == 14/9, 'Mean Absolute Deviation correctly calculated.';
    ok median-ad(@list_x) == 1, 'Median Absolute Deviation correctly calculated.';
    ok mean(@list_x) == mean($baggy_x), 'Mean for Bag and List is identical.';
    ok median(@list_x) == median($baggy_x), 'Median for Bag and List is identical.';
    ok mode(@list_x) eqv mode($baggy_x), 'Mode for Bag and List is identical.';
    ok variance(@list_x) == variance($baggy_x), 'Variance for Bag and List is identical.';
    ok sd(@list_x) == sd($baggy_x), 'Standard deviation for Bag and List is identical.';
    ok mean-ad(@list_x) == mean-ad($baggy_x), 'Mean Absolute Deviation for Bag and List is identical.';
    ok median-ad(@list_x) == median-ad($baggy_x), 'Median Absolute Deviation for Bag and List is identical.';
    ok zscores(@list_x) == zscores($baggy_x), 'Z-scores for Bag and List is identical.';
    ok zscore(10,@list_x) == zscore(10,$baggy_x), 'Z-score given background for Bag and List is identical.';
}

done;
