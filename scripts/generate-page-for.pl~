#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

$specification = q(
	--id <ID>		Entry ID
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'--id'}) {
  die "Need to specify ID\n";
}

print "  Mt : UniversalVocabularyMt
  isa : [Inf]Collection

  Mt : FRDCSAMt
  isa : [Def]Project  [Def]ResearchProject

  Mt : POSICommunityMt
  [Def](isa Politico-FRDCSAProject FRDCSAProject)

  Mt : UniversalVocabularyMt
  genls : [Inf]Thing

  Mt : FRDCSAMt
  [Inf](correspondingSpecificationOfProject
	(SpecificationOfProjectEventFn FRDCSAProject) FRDCSAProject)

  Mt : FRDCSAMt
  projectTeamSize : [Def]2
";
