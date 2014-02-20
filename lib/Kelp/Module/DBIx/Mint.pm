package Kelp::Module::DBIx::Mint;
use DBIx::Mint;
use Carp;
use parent 'Kelp::Module';
use 5.010000;
use strict;
use warnings;

our $VERSION = 0.01;

sub build {
    my ($self, %args) = @_;
    my $mint = $self->build_mint( \%args );
    $self->register( mint => $mint );
}

sub build_mint {
    my ($self, $settings) = @_;

    if (not exists $settings->{dsn} && not exists $settings->{driver}) {
        croak 'You must specify either the dsn or the driver for Kelp::Module::DBIx::Mint';
    }

    if (not exists $settings->{username} || not exists $settings->{password}) {
        croak 'You must specify both username and password for  Kelp::Module::DBIx::Mint';
    }

    # The code below was modified from Dancer::Plugin::Database::Core
    
    # Assemble the DSN:
    my $dsn    = '';
    my $driver = '';
    if ($settings->{dsn}) {
        $dsn      = $settings->{dsn};
        ($driver) = $dsn =~ m{dbi:([^:]+)};
    } else {
        $dsn    = "dbi:" . $settings->{driver};
        $driver = $settings->{driver};
        my @extra_args;
 
        # DBD::SQLite wants 'dbname', not 'database', so special-case this
        # (DBI's documentation recommends that DBD::* modules should understand
        # 'database', but older versions of DBD::SQLite didn't
        if ($driver eq 'SQLite'
            && $settings->{database} && !$settings->{dbname}) {
            $settings->{dbname} = delete $settings->{database};
        }
 
        for (qw(database dbname host port sid)) {
            if (exists $settings->{$_}) {
                push @extra_args, $_ . "=" . $settings->{$_};
            }
        }
        $dsn .= ':' . join(';', @extra_args) if @extra_args;
    }
 
    # Kelp uses utf-8 by default
    my $auto_utf8 = exists $settings->{auto_utf8} ?  $settings->{auto_utf8} : 1;
 
    if ($auto_utf8) {
        # The option to pass to the DBI->connect call depends on the driver:
        my %param_for_driver = (
            SQLite => 'sqlite_unicode',
            mysql  => 'mysql_enable_utf8',
            Pg     => 'pg_enable_utf8',
        );
 
        my $param = $param_for_driver{$driver};
 
        if ($param && !$settings->{dbi_params}{$param}) {
            $settings->{dbi_params}{$param} = 1;
        }
    }

    $settings->{dbi_params}{RaiseError} = 1 if (!exists $settings->{ RaiseError });
    $settings->{dbi_params}{AutoCommit} = 1 if (!exists $settings->{ AutoCommit });
 
    my $mint = DBIx::Mint->connect($dsn,
        $settings->{username}, $settings->{password}, $settings->{dbi_params}
    );
    return $mint;
}

1;

=pod

=head1 NAME

Kelp::Module::DBIx::Mint - Add an ORM to your Kelp web application

=head1 SYNOPSIS

 # lib/Bloodbowl/Team.pm
 package Bloodbowl::Team;
 use Moo;
 with 'DBIx::Mint::Table';

 has id   => (is => 'rw' );
 has name => (is => 'rw' );
 ...


 # conf/config.pl
 {
    modules      => [qw/DBIx::Mint/],
    modules_init => {
        # Database connection
        'DBIx::Mint' => {
            dsn        => 'dbi:Pg:dbname=my_database',
            username   => 'username',
            password   => 'password',
            dbi_params => {
                AutoCommit => 1,
                RaiseError => 1,
            },
        },
    },
 };


 # lib/MyApp.pm:
 ...
 sub get_team {
     my ($self, $id) = @_;
     return Bloodbowl::Team->find( $id );
 }


=head1 DESCRIPTION

This L<Kelp> module will establish a database connection to feed your L<DBIx::Mint> classes and schema. The connection is lazy: it will be established only if you use it.

=head1 REGISTERED METHODS

=head2 mint

This method will be added to your Kelp object, and it will return the subjacent
L<DBIx::Mint> instance. Only the default instance is supported.

=head1 CONFIGURATION

After including 'DBIx::Mint' in the list of modules, the C<module_init> section may include the following keys:

=over

=item dsn

You can set directly the dsn for your database (see the synopsis). If you don't, then you must set the different parts of the dsn by themselves:

=over

=item driver

Mandatory

=item database or dbname, host, port, sid

Optional

=back

=item username, password

These are mandatory but can be empty strings.

=item dbi_params

A hash reference of parameters to pass to L<DBIx::Connector>, which will in turn pass them to L<DBI>. In particular, unless you set them to a false value, C<RaiseError> and C<AutoCommit> will be set to 1.

=item auto_utf8

By default, L<Kelp> sets the character set to utf-8. This is the default for this module, and unless you set C<auto_utf8> to a false value, the appropiate parameters will be set for PostgreSQL, MySQL and SQLite to work with this encoding too.

=back

=head1 SEE ALSO

L<Kelp>, L<DBIx::Mint>. For a different ORM, L<Rose::DB::Object>, see <Kelp::Module::RDBO> .

=head1 ACKNOWLEDGEMENTS

Thanks to Stefan G. (MINIMAL) for the creation of L<Kelp>.

A large portion of this module was forked from L<Dancer::Plugin::Database::Core>,
by David Precious. 

=head1 AUTHOR

Julio Fraire, E<lt>julio.fraire@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Julio Fraire

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut

