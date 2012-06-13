use inc::Module::Install;

name 'Class-Accessor-Lite-Lazy';
all_from 'lib/Class/Accessor/Lite/Lazy.pm';

requires 'Class::Accessor::Lite', '0.05';
requires 'Carp';
requires 'parent';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More', '0.98';
test_requires 'Test::Fatal';

auto_set_repository;
auto_include_deps;

readme_markdown_from 'lib/Class/Accessor/Lite/Lazy.pm';

if ($Module::Install::AUTHOR) {
    require File::Copy;
    File::Copy::mv('README.mkdn', 'README.md');
}

WriteAll;
