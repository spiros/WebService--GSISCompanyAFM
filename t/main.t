#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use Data::Dumper;
use Encode;

use_ok('WebService::GSISCompanyAFM');

## new

my $GSIS = WebService::GSISCompanyAFM->new();

isa_ok( $GSIS, 'WebService::GSISCompanyAFM' );

## _create_stub_request

my $rh_expected_stub_req = {
    pAfm              => 123,
    pCallSeqId_out    => 1,
    pErrorRec_out     => { errorDescr => '', errorCode => '' },
    pBasStoixNRec_out => { 
        actLongDescr       => "",
        postalZipCode      => "",
        facActivity        => "0",
        registDate         => "2011-01-01T00:00:00Z",
        stopDate           => "2011-01-01T00:00:00Z",
        doyDescr           => "",
        parDescription     => "",
        deactivationFlag   => "1",
        postalAddressNo    => "",
        postalAddress      => "",
        doy                => "",
        firmPhone          => "",
        onomasia           => "",
        firmFax            => "",
        afm                => "",
        commerTitle        => ""  
    }
};

my $rh_obtained_stub_req = 
    $GSIS->_create_stub_request('123');

cmp_deeply(
    $rh_expected_stub_req,
    $rh_obtained_stub_req,
    '_create_stub_request'
);

## is_valid

ok( ! $GSIS->is_valid() );

my $rv = $GSIS->is_valid( '1234' );

ok( ! $rv, 'is_valid NO OK' );

$rv = $GSIS->is_valid( '094422282' );

ok( $rv, 'is_valid() OK');

## get_info

ok( ! $GSIS->get_info() );

ok( ! $GSIS->get_info('MOO123') );

my $rh_obtained_info = $GSIS->get_info( '094422282' );

my $rh_expected = {
    afm             => '094422282   ',   # whitespace is added by the service, probably a bug.
    commerTitle     => 'ΑΠΟΛΛΩΝΙΟΝ ΝΙΚΗ ΑΕΒΕ',
    facActivity     => '10711000',
    firmPhone       => '3312590',
    actLongDescr    => 'ΠΑΡΑΓΩΓΗ ΨΩΜΙΟΥ, ΝΩΠΩΝ ΕΙΔΩΝ ΖΑΧΑΡΟΠΛΑΣΤΙΚΗΣ ΚΑΙ ΓΛΥΚΙΣΜΑΤΩΝ',
    parDescription  => 'ΑΘΗΝΑ',
    onomasia        => 'NIKH AΠΟΛΛΩΝΙΟΝ ΑΕΒΕ ΕΣΤΙΑΣΕΩΣ',
    postalZipCode   => '10563',
    doyDescr        => 'Φ.Α.Ε. ΑΘΗΝΩΝ',
    doy             => '1159'    
};

foreach my $key ( keys %$rh_expected ) {
    my $raw_value  = $rh_obtained_info->{$key};
    my $encoded    = encode_utf8( $raw_value );
    is( $encoded, $rh_expected->{$key}, "$key check" );    
}

done_testing();