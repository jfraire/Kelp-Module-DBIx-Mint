use Test::More;

use strict;
use warnings;

# Make sure the module loads
# BEGIN { use_ok('Kelp::Module::DBIx::Mint') };

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
