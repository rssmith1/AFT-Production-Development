#!/usr/bin/perl -w
use strict;
use DBI;
use warnings;
#!/usr/bin/perl -w use DBI;


my $dsn = 'DBI:mysql:daily_report';
my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
my $sql = "select * from report";
my $sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
print "printing rows\n";
while (my @row = $sth->fetchrow_array) {
    print "@row\n";
    }
print "done\n";
