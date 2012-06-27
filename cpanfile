requires 'URI';
requires 'Data::Dumper';
#requires 'Modern::Perl';
requires 'Mojolicious::Lite';

on 'test' => sub {
    requires 'Test::More', '>= 0.96, < 2.0';
    recommends 'Test::TCP', '1.12';
};

on 'develop' => sub {
    recommends 'Devel::NYTProf';
};