# Common settings
use strict;
use warnings;
{
    modules      => [qw/DBIx::Mint/],
    modules_init => {
        # Database connection
        'DBIx::Mint' => {
            dsn        => 'dbi:Pg:dbname=my_database',
            username   => 'username',
            password   => 'password',
            dbi_params => {
                AutoCommit => 0,  # For testing only (defaults to 1)
                RaiseError => 0,  # For testing only (defaults to 1)
            },
        },
    },
};
