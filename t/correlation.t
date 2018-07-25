use v6;
use Test;
use Stats;

# Simplest covariance/correlation tests
{
    my @x = 1,2,3,4;
    my @y = 4,3,2,1;
    my @z = 1,1,1,1;

    is cov(@x,@x), variance(@x), 'Covariance of same values is equal to variance';
    is-approx corrcoef(@x,@x), 1, 'Correlation coefficient is 1 for same values';
    is-approx corrcoef(@x,@y), -1, 'Correlation correctly calculated';
    is cov(@x,@z), 0, 'No linear dependency';
    is cov(@y,@z), 0, 'No linear dependency';
    ok corrcoef(@x,@z) ~~ Failure, 'Dies because of 0 standard deviation';
}
done-testing;
