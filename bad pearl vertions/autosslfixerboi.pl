#!/usr/bin/perl
use warnings;
use Socket;
use Sys::Hostname;

#some variables lol
$hostname = hostname();
$usrDomains_file = '/etc/userdomains';
$counterBoi = int 0;
$counterBoi2 = int 1;

print "[*] NOTICE: These following domains are going to be processed:\n";

# slurpe and use integerparse /etc/userdomains for userlist & domain names on each user
open(FILE, $usrDomains_file) or die "Could not read from $usrDomains_file, program halting.";
while(<FILE>)
{
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

#loop to do the requests to the api go brrr
while($counterBoi2 < $counterBoi){
    #save the output of whmapi1 so we can see raw response 
    $output = qx/whmapi1 --output=jsonpretty   add_autossl_user_excluded_domains   username='$users[$counterBoi2]'   domain='cpcalendars.${domains[$counterBoi2]}'   domain-1='cpanel.$domains[$counterBoi2]'   domain-2='webmail.$domains[$counterBoi2]'   domain-3='webdisk.$domains[$counterBoi2]'   domain-4='cpcontacts.$domains[$counterBoi2]'   domain-5='cpcalendars.$domains[$counterBoi2]'/;
    print "================================================================\n";
    print "[*] NOTICE: Results of the api request for: $domains[$counterBoi2]\n";
    print "$output";
    
    $counterBoi2++;
    print "Domains cleaned from autossl: $counterBoi2\n";
}
print "================================================================\n";
print "All Done Omegalul\n";