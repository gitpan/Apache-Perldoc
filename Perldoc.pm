package Apache::Perldoc;
use vars qw( $VERSION );
$VERSION = '0.02';

sub handler
{
     my $r = shift;
     $r->content_type('text/html');
     $r->send_http_header;
     my $pod = $r->path_info;
     $pod =~ s|/||;
     $pod =~ s|/|::|g;

     $pod = 'perl' unless $pod; 

     use Cwd 'chdir';
     chdir "/tmp";
     my $html = qx(perldoc -u $pod | pod2html --htmlroot=/perldoc);

     if(length($html) > 194) {
	     print $html;
     } else {
	     print "No such perldoc. Either you havent installed the module or the author neglected to provide documentation.";
     }
}

1;

=head1 NAME

Apache::Perldoc - mod_perl handler to spooge out HTML perldocs

=head1 DESCRIPTION

A simple mod_perl handler to give you Perl documentation on installed
modules.

The following configuration should go in your httpd.conf

  <Location /perldoc>
  SetHandler perl-script
  PerlHandler Apache::Perldoc
  </Location>

=head1 Author

Rich Bowen <rbowen@cre8tivegroup.com>

http://www.cre8tivegroup.com/

=cut

