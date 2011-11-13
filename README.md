This module provides a simple wrapper around the new web service set up by the Greek
Information Systems department for validating or obtaining information on a given
AFM number for companies. You can find more information by reading the online documentation
at L<http://www.gsis.gr/wsnp.html> which is, for the moment at least, only in Greek.

```perl
my $Object = WebService::GSISCompanyAFM->new();

my $afm = '094422282';
    
my $rv = $Object->is_valid( $afm);     
    
my $rh_information = $Object->get_info ( $afm );
```

Alternatively, there is also an example script in /example which you can use.

```
fruit:WebService-GSISCompanyAFM spiros$ perl ./example/get_info.pl --afm=094422282
Company name : NIKH AΠΟΛΛΩΝΙΟΝ ΑΕΒΕ ΕΣΤΙΑΣΕΩΣ
Postal address : ΝΙΚΗΣ
AFM : 094422282   
Company commercial name : ΑΠΟΛΛΩΝΙΟΝ ΝΙΚΗ ΑΕΒΕ
Post code : 10563
Phone number : 3312590
Description : ΠΑΡΑΓΩΓΗ ΨΩΜΙΟΥ, ΝΩΠΩΝ ΕΙΔΩΝ ΖΑΧΑΡΟΠΛΑΣΤΙΚΗΣ ΚΑΙ ΓΛΥΚΙΣΜΑΤΩΝ
Residence : ΑΘΗΝΑ
Registration date : 1995-01-09T00:00:00.000+02:00
DOY : Φ.Α.Ε. ΑΘΗΝΩΝ
```