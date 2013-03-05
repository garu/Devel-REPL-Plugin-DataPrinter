#!/usr/bin/env perl

{
    package Mock::Stringify;
    use overload ('""' => \&stringify);
    sub new { my $s = "internal data"; bless \$s; }
    sub stringify { "stringified" }
}

{
    package Term::ReadLine::Mock;
    sub ReadLine {'Term::ReadLine::Mock'};
    sub readline { 'my $s = Mock::Stringify->new' }
    sub new { bless {} }
    sub string {
        my ($self) = @_;
        unless ( $self->{string} ) {
            my $string;
            $self->{string} = \$string;
        }
        $self->{string};
    }
    sub OUT {
        my ($self) = @_;
        unless($self->{OUT}) {
            open($self->{OUT}, '>', \${$self->{string}})
                or die "Could not open string for writing";
        }
        $self->{OUT};
    }
}


use Test::More tests => 4;

use_ok('Devel::REPL');

my $repl_default = get_repl();
$repl_default->run_once();
is(${$repl_default->term->string}, "stringified", "stringified by default");

my $repl_stringify_on = get_repl();
$repl_stringify_on->dataprinter_config({
    stringify => {
        'Mock::Stringify' => 1,
    },
});
$repl_stringify_on->run_once();
is(${$repl_stringify_on->term->string}, "stringified", "stringified by setting 'stringify' to true");

my $repl_stringify_off = get_repl();
$repl_stringify_off->dataprinter_config({
    stringify => {
        'Mock::Stringify' => 0,
    },
});
$repl_stringify_off->run_once();
like(${$repl_stringify_off->term->string}, qr/internal data/s, "not stringified by setting 'stringify' to false");

sub get_repl {
    my $repl = Devel::REPL->new;
    $repl->load_plugin('DataPrinter');
    $repl->term(Term::ReadLine::Mock->new());
    $repl;
}

1;
