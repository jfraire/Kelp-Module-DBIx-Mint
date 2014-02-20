use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Kelp::Module::DBIx::Mint',
    VERSION_FROM      => 'lib/Kelp/Module/DBIx/Mint.pm', # finds $VERSION
    PREREQ_PM         => {
    	Kelp         => 0.456,
	'DBIx::Mint' => 0.06,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Kelp/Module/DBIx/Mint.pm', # retrieve abstract from module
       AUTHOR         => 'Julio Fraire <julio@>') : ()),
);
