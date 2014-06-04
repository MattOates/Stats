use v6;
use Test;
plan 1;

#Basic sanity tests for DataFrames
use Stats::DataFrame;

{
    my $model = Stats::DataFrame.new();
    isa_ok $model, Stats::DataFrame, 'Created DataFrame successfully.';
}

done;
