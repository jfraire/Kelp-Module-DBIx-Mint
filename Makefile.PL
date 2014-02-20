use 5.010000;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Kelp::Module::DBIx::Mint',
    VERSION_FROM      => 'lib/Kelp/Module/DBIx/Mint.pm', # finds $VERSION
    PREREQ_PM         => {
    	Kelp         => 0.456,
		'DBIx::Mint' => 0.06,
    },
    BUILD_REQUIRES   => {
        'DBD::SQLite'         => 1.39,
    },
    META_MERGE     => {
        resources  => {
            repository => 'https://github.com/jfraire/DBIx-Mint',
        },
    },
    ABSTRACT_FROM  => 'lib/Kelp/Module/DBIx/Mint.pm', # retrieve abstract from module
    AUTHOR         => 'Julio Fraire <julio.fraire@gmail.com>',
);
