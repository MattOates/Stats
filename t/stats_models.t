use v6;
use Test;
plan 1;

#Basic sanity tests for statistical models
use Stats::Models::Linear;

{
    my $model = Stats::Models::Linear.new();
    isa_ok $model, Stats::Models::Linear, 'Created Linear model successfully.';
}

done;
