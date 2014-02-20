use Test::More tests => 2;
use strict;
use warnings;

# Build a Kelp app
{
    package ThisTest;
    use parent 'Kelp';
    
    1;
}

my $app = ThisTest->new;

# Make sure we get a DBIx::Mint object
my $mint;
eval {
    $mint = $app->mint;
};

ok( not($@), 'Survived calling $app->mint');
isa_ok $mint, 'DBIx::Mint';

done_testing();
