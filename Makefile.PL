use inc::Module::Install;

name 'Class-Accessor-Lite-Lazy';
all_from 'lib/Class/Accessor/Lite/Lazy.pm';

requires 'Class::Accessor::Lite';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_set_repository;
auto_include;

WriteAll;
