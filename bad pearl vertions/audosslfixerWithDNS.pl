#!/usr/bin/perl
use warnings;
use Socket;
use Sys::Hostname;
use Net::DNS ();

#some variables lol
$hostname = hostname();
$addr = inet_ntoa((gethostbyname(hostname))[4]);
$name_server = '8.8.8.8'; #google dns 
$usrDomains_file = '/etc/userdomains';
$counterBoi = int 0;
$counterBoi2 = int 1;

#set up DNS resolver obj
$res = Net::DNS::Resolver->new;
$res->nameservers($name_server);

print "[*] NOTICE: These following domains are going to be processed:\n";

# slurpe and use integerparse /etc/userdomains for userlist & domain names on each user
open(FILE, $usrDomains_file) or die "Could not read from $usrDomains_file, program halting.";
while(<FILE>){
  chomp;
  # read the fields in the current record into an array
  @fields = split(': ', $_);

  # write the first field (the domains) to an array
  $domains[$counterBoi] = $fields[0];

  #test line for domains being added to the array / also used for message to what domains are being processed
  print "$domains[$counterBoi]\n"; #write that its in the var to test

  # write the first field (the users) to an array
  $users[$counterBoi] = $fields[1];

  #test line for users being added to the array
  #print "$users[$counterBoi]\n"; #write that its in the var to test

  $counterBoi++;
}
close FILE;



#warning large gross loop incoming, could have done this in an easier/cleaner way but cant be asked



#This loop is used to loop through both the user as well as the domain name to look into
while($counterBoi2 < $counterBoi){
    
    print "================================================================\n";
    print "================================================================\n";
    print "==================   $domains[$counterBoi2]   =======================\n";
    print "================================================================\n";
    print "================================================================\n";

    #DNS verification logic 
    #www subdomain
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking www.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='www.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #webmail sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking webmail.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='webmail.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #webdisk sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking webdisk.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='webdisk.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";

    }
    #mail sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking mail.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='mail.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #cpanel sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking cpanel.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='cpanel.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #whm sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking whm.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='whm.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #cpcalendars sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking cpcalendars.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='cpcalendars.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }
    #cpcontacts sub
    #====================================================================
    print "================================================================\n";
    print "[*] - Now checking cpcontacts.$domains[$counterBoi2] ...\n";
    print "================================================================\n";
    $query = $res->search($domains[$counterBoi2]);
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
            }
        }
    }
    if ($result) {
        print "[*] $domains[$counterBoi2] --- $result\n";
        if ($result eq $addr){ print "[+] $domains[$counterBoi2] matches! Should pass DCV validation - Not removing from auto ssl\n";}
        else{
            $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]' domain='cpcontacts.$domains[$counterBoi2]'/;
            print"[-] FAILED DNS Validation - Removing...\n";
            print "[*] NOTICE: Results of the api request for: www.$domains[$counterBoi2]\n";
            print "$output";
        }
    } else {
        print "[-] $domains[$counterBoi2] --- FAILED - Does not resolve - Removing from auto ssl\n";
    }



    #save the output of whmapi1 so we can see raw response 
    #$output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]'   domain='cpcalendars.${domains[$counterBoi2]}'   domain-1='cpanel.$domains[$counterBoi2]'   domain-2='webmail.$domains[$counterBoi2]'   domain-3='webdisk.$domains[$counterBoi2]'   domain-4='cpcontacts.$domains[$counterBoi2]'   domain-5='cpcalendars.$domains[$counterBoi2]'/;
    #print "================================================================\n";
    
    
    $counterBoi2++;
    print "Domain roots cleaned from autossl: $counterBoi2\n";
}
print "================================================================\n";
print "All Done Omegalul\n";