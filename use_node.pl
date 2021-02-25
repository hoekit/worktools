#!/usr/bin/env perl
# ~/bin/use_node.pl v0.0.1
use strict; use warnings; use utf8; use 5.10.0;

# Dependencies
use Path::Tiny qw/path/;

## ARGUMENTS
my $ROOT = '~/my/node';
my $BIN  = '~/bin';
my $ver  = $ARGV[0] || '';
my $cmd  = $ARGV[1] || '';

my ($action, $v) = parse_args($ver, $cmd);

list_version()   if $action eq 'list';
use_version($v)  if $action eq 'use';


## HELPERS
sub parse_args {
    return ('list', '') if $ver eq '';

    return ('list', '') if $ver eq 'list';

    return ('show', '') if $ver eq 'show';

    return ('use', $ver) if $cmd eq '';

    #return ('install', $ver) if $cmd eq 'install';

    die "Unknown action: $cmd\n";
}
sub list_version {
    my $out = `ls -l $BIN/node`;
    my ($ver) = ($out =~ /node-v(.+?)-/);
    $ver = $ver || 'None';

    say "  Now using:\n    $ver\n";
    say "  Available version(s):";

    foreach my $p (path($ROOT)->children(qr/node-v\d/)) {
        my ($v) = ($p =~ /node-v(\d+.\d+.\d+)-.*$/);
        say "    $v";
    }
}
sub use_version {
    my $ver = shift;
    my $cmd
        = "ln -sf "
        . "$ROOT/node-v$ver-linux-x64/bin/node "
        . "$BIN/node";

    system($cmd) == 0 or die "Unable to create symlink $BIN/node";

    say "Now using: node-$ver";
}

# vim: ts=4 sts=4 sw=4 et:

__END__

=pod

=encoding UTF-8

=head1 NAME

use_node.pl - A simple node version selector

=head1 VERSION

version 0.0.1

=head1 SYNOPSIS

    use_node.pl                 # show version in use and available versions

    use_node.pl list            # ditto

    use_node.pl use VERSION     # select  node version to use

=head1 DESCRIPTION

This program simply creates a symlink at ~/bin/node to the selected node
version.

It assumes that the OS is linux, that the ~/bin directory exists and is
executable, that the various versions of node are installed in
~/my/node.

=head1 COPYRIGHT AND LICENSE

This software is dedicated to the L<public domain|https://en.wikipedia.org/wiki/Public_domain> and is free of copyright restrictions

=cut
