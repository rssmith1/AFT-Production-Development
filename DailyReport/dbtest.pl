#!/usr/bin/perl -w
use strict;
use DBI;
use warnings;
#!/usr/bin/perl -w use DBI;

# "dbi:$driver:database=$db;host=$host;port=$port"
my $dsn = 'DBI:mysql:database=daily_report;host=AFT-INT-1;port=3306';
my $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
my $sql = "select * from report";
my $sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
print "printing rows\n";
while (my @row = $sth->fetchrow_array) {
    print "@row\n";
    }
print "done\n";
