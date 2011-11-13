use strict;
use warnings;

package WebService::GSISCompanyAFM;
# ABSTRACT: Validate or obtain information on a company AFM number via the GSIS portal

use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;
use XML::Compile::Schema;
use Data::Dumper;
use Encode;
use Carp;

=head1 SYNOPSIS

This module provides a simple wrapper around the new web service set up by the Greek
Information Systems department for validating or obtaining information on a given
AFM number for companies. You can find more information by reading the online documentation
at L<http://www.gsis.gr/wsnp.html> which is, for the moment at least, only in Greek.

    my $Object = WebService::GSISCompanyAFM->new();
    
    my $afm = '094422282';
    
    my $rv = $Object->is_valid( $afm);     
    
    my $rh_information = $Object->get_info ( $afm );


=head1 METHODS

=head2 new 

Creates a new instance of the class. This method will return undef on error.

    my $Object = WebService::GSISCompanyAFM->new();

=cut

sub new {
    my $class = shift;
    my $self  = { };
    
    ##
    ## Use a local copy of the WSDL as the live one 
    ## has a minor problem with the remote address. This will
    ## be changed once the issue is resolved.
    
    $self->{wsdl} = 
        XML::Compile::WSDL11->new( './wsdl/RgWsBasStoixN.wsdl' );
    
    unless ( $self->{wsdl} ) {
     croak "Could not create WSDL object with fetched data.";
    }
    
    ##
    ## For each operation defined in the WSDL file,
    ## pre-compile the client and cache it.
    
    my @operations = $self->{wsdl}->operations();
    foreach my $op ( @operations ) {
       my $name   = $op->{name};
       my $op     = $self->{wsdl}->operation( operation => $name );
       my $client = $op->compileClient( );
       $self->{clients}->{ $name } = $client;
    }
                    
    return bless $self, $class;    
}

=head2 is_valid

Given a AFM number, this method will return true if the number appears to be valid
and undef if not. This method will return I<undef> on error.

    my $rv = $Object->is_valid( $afm );     

=cut

sub is_valid {
    my $self = shift;
    my $afm  = shift;
    
    return undef 
        unless defined $afm;
    
    my $rh_request = 
        $self->_create_stub_request( $afm );
    
    my $rh_response = 
        $self->_send_request( $rh_request );
    
    if ( $rh_response->{'pErrorRec_out'}->{'errorCode'} eq 'RG_WRONG_AFM' ) {
        return undef;
    } else {
        return 1;
    }
    
}

=head2 get_info 

Given a AFM number, returns all information recorded for it from the service. This method
will return I<undef> on error.

    my $rh_information = $Object->get_info ( $afm );

Information on the actual keys returned can be found at the online resource (Greek) L<http://www.gsis.gr/wsnp.html>.
Note that the values are UTF8 encoded so you should use encode_utf8 from the Encode package before using them.

=cut

sub get_info {
    my $self = shift;
    my $afm  = shift;
    
    return undef
        unless defined $afm;
    
    my $rh_request = 
        $self->_create_stub_request( $afm );
    
    my $rh_response = 
        $self->_send_request( $rh_request );
    
    if ( $rh_response->{'pErrorRec_out'}->{'errorCode'} eq 'RG_WRONG_AFM' ) {
          return undef;
     } else {
          return $rh_response->{'pBasStoixNRec_out'};
     }
    
}


=head2 _send_request

Internal method used to send the request to the remote service. This method will die
on error.

=cut

sub _send_request {
    my $self    = shift;
    my $rh_request = shift;
    
    my $rh_response =  
        $self->{clients}->{'rgWsBasStoixN'}->( $rh_request );
    
    unless ( defined $rh_response ) {
        croak "There was a problem contacting the remote service.";
    }

    unless ( defined $rh_response->{'rgWsBasStoixNResponse'} ) {
        croak "Response object is missing.";
    }
    
    return $rh_response->{'rgWsBasStoixNResponse'}

}

=head2 _create_stub_request

Internal method used to create a request.

=cut

sub _create_stub_request {
    my $self = shift;
    my $afm  = shift;
    
    my %rh_req = (
        pAfm              => $afm,
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
    );
    
    return \%rh_req;
}

1;

 
# print encode_utf8($raw);
# print "\n";
