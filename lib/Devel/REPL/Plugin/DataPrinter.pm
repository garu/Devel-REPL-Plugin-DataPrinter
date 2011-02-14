package Devel::REPL::Plugin::DataPrinter;
# ABSTRACT: Format results with Data::Printer
use strict;
use warnings;

1;
__END__

=head1 SYNOPSIS

In your re.pl config file (usually C<< ~/.re.pl/repl.rc >>):

    $_REPL->load_plugin('DataPrinter');

That's about it. Your re.pl should now give you nicer outputs :)

=head1 SEE ALSO

=for :list
* L<Devel::REPL>
* L<Devel::REPL::Plugin::DDS>
