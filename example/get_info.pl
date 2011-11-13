#!/usr/bin/perl 

use strict;
use warnings;

use WebService::GSISCompanyAFM;
use Encode;
use Getopt::Long;
use Data::Dumper;

my $rh_options = { };

GetOptions( $rh_options,
    "afm:s",
    "help",
);

if ( $rh_options->{help} ) {
    help_and_exit();
}

unless ( defined $rh_options->{afm} ) {
    help_and_exit('error');
}

my $GSIS = WebService::GSISCompanyAFM->new();

my $rh_information = $GSIS->get_info( $rh_options->{afm} );

if ( ! defined $rh_information ) {
    die "Invalid AFM number."
} else {
    print_report( $rh_information );
}


########################################################################
########################################################################

sub print_report {
    my $rh = shift;
    
    my $rh_nicenames = { 
        'afm'            => 'AFM',
        'commerTitle'    => 'Company commercial name',
        'postalAddress'  => 'Postal address',
        'firmPhone'      => 'Phone number',
        'actLongDescr'   => 'Description',
        'onomasia'       => 'Company name',
        'postalZipCode'  => 'Post code',
        'doyDescr'       => 'DOY',
        'parDescription' => 'Residence',
        'registDate'     => 'Registration date'
    };
    
    foreach my $key ( keys %$rh_nicenames ) {
        printf "%s : %s\n", $rh_nicenames->{$key}, encode_utf8( $rh->{$key} );
    }    
    
}

sub help_and_exit {
    my $is_error = shift;
    
    print <<END
    
    $0: Obtain information on a company AFM number
    
    --afm  : the AFM number
    --help : print this help error and exit

END
;
    
    if ( $is_error ) {
        print "ERROR: please supply a AFM number using --afm\n";
    }
    
    exit(0);
}