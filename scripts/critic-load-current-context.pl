#!/usr/bin/perl -w

use lib ".";

use BOSS::Config;
use Manager::Misc::Light;
use PerlLib::SwissArmyKnife;

use Digest::MD5 qw(md5 md5_hex md5_base64);

$specification = q(
	-d <context>		Current critic context
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-d'}) {
  die "Need to specify -d\n";
}

my $context = $conf->{'-d'};
if ($context eq 'Org::FRDCSA::CRITIC::Domain::UniLang') {

} elsif ($context eq 'Org::FRDCSA::CRITIC::Domain::ToDo') {
  # Do::ListProcessor4;
  my $light = Manager::Misc::Light->new();
  my $c2 = read_file("sample-to.do");
  # my $c2 = substr($c,0,10000);
  my $parsed = $light->Parse(Contents => '((('.$c2.')');
  # print Dumper($parsed);
  foreach my $entry (@{$parsed->[0][0][0]}) {
    my $result = $light->Generate(Structure => $entry);
    my $digest = md5_hex($result);
    # print Dumper([$digest,$result]);
    print 'Digest: '.$digest."\n";
    print 'Entry: '.$result."\n\n";
  }
} elsif ($context eq 'Org::FRDCSA::CRITIC::Domain::SPSE2') {

}
