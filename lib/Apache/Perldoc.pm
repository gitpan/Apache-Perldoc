package Apache::Perldoc;
use vars qw( $VERSION );
$VERSION = '0.03';

sub handler {
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

    if ( length($html) > 194 ) {
        print $html;
      } else {
        print
"No such perldoc. Either you havent installed the module or the author neglected to provide documentation.";
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

You can then get documentation for a module C<Foo::Bar> at the URL
C<http://your.server.com/perldoc/Foo::Bar>

=head1 Author

Rich Bowen <rbowen@cre8tivegroup.com>

http://www.ApacheAdmin.com/

=head1 Caveat

Note that this is EXCEEDINGLY insecure. Run this at your own risk, and
only on internal web sites, if you know what's good for you.

If someone would like to make this a little more secure, I would be
delighted to apply any patches you would like to provide. This module
was written for my own benefit, and put back on CPAN because some folks
asked me to.

You have been warned.

=head1 Other neat trick - Bookmarklet

If you create a browser bookmark to the following URL, you can highlight
the name of a module on web page, then select the bookmark, and go
directly to the documentation for that module. Selecting the bookmark
without having anything highlighted will result in a pop-up dialog in
which you can type a module name.

 javascript:Qr=document.getSelection();if(!Qr){void(Qr=prompt('Module
 name',''))};if(Qr)location.href='http://localhost/perldoc/'+escape(Qr)

Note that that's all one line, split here for display purposes. I know
this works in Netscape and Mozilla. Can't vouch for IE.

=cut

