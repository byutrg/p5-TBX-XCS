#Check that XCS.pm creates proper structure from an XCS file
use strict;
use warnings;
use Test::More 0.88;
plan tests => 1;
use TBX::XCS;
use Path::Tiny;
use FindBin qw($Bin);
use File::Slurp;
use JSON;

my $corpus_dir = path($Bin, 'corpus');
my $xcs_file = path($corpus_dir, 'small.xcs');
my $xcs_contents = read_file($xcs_file);

my $xcs = TBX::XCS->new();
$xcs->parse(file => $xcs_file);
my $expected = {
   'constraints' => {
      'refObjects' => {
         'Foo' => [
            'data'
         ]
      },
      'languages' => {
         'en' => 'English',
         'fr' => 'French',
         'de' => 'German'
      },
      'datCatSet' => {
         'xref' => [
            {
               'name' => 'xrefFoo',
               'targetType' => 'external',
               'datatype' => 'plainText'
            }
         ],
         'termCompList' => [
            {
               'forTermComp' => 1,
               'datCatId' => 'ISO12620A-020802',
               'name' => 'termElement'
            }
         ],
         'descrip' => [
            {
               'levels' => [
                  'term'
               ],
               'datCatId' => 'ISO12620A-0503',
               'name' => 'context',
               'datatype' => 'noteText'
            },
            {
               'levels' => [
                  'langSet',
                  'termEntry',
                  'term'
               ],
               'name' => 'descripFoo',
               'datatype' => 'noteText'
            }
         ],
         'termNote' => [
            {
               'forTermComp' => 1,
               'datCatId' => 'ISO12620A-020204',
               'name' => 'animacy',
               'choices' => [
                  'animate',
                  'inanimate',
                  'otherAnimacy'
               ],
               'datatype' => 'picklist'
            }
         ]
      }
   },
   'name' => 'Small',
   'title' => 'Example XCS file'
};
my $actual = decode_json $xcs->as_json();

is_deeply($actual, $expected, 'Correct JSON structure')
  or note explain $actual;