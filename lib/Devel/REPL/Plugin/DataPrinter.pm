package Devel::REPL::Plugin::DataPrinter;
# ABSTRACT: Format REPL results with Data::Printer
use strict;
use warnings;

use Devel::REPL::Plugin;
use Data::Printer colored => 1, use_prototypes => 1;

around 'format_result' => sub {
   my $orig = shift;
   my $self = shift;
   my @to_dump = @_;
   my $out;
   if (@to_dump != 1 || ref $to_dump[0]) {
      if (@to_dump == 1) {
         if ( overload::Method($to_dump[0], '""') ) {
            $out = "@to_dump";
         }
         else {
             $out = p $to_dump[0];
         }
      } else {
         $out = p @to_dump;
      }
   } else {
      $out = $to_dump[0];
   }
   $self->$orig($out);
};


1;
__END__

=head1 SYNOPSIS

In your re.pl config file (usually C<< ~/.re.pl/repl.rc >>):

    load_plugin('DataPrinter');

That's about it. Your re.pl should now give you nicer outputs :)

=head1 SEE ALSO

* L<Devel::REPL>
* L<Devel::REPL::Plugin::DDS>

