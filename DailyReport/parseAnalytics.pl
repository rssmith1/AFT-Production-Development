use DBI;

use Analytics;

my $dbh;
my @dataArray;
my $platName;
my $algoName;
my $algoVersion;
my $algoVersionDesc;
my $datasetDesc;
my $reportDate;
my $platId;
my $algoId;
my $algoVersionId;
my $datasetId;

my $tempAlgo;
my $market;
my $n =1;

sub parseIBData {
    my $line = shift;
    
    my $analytics = Analytics->new();
    
    my ($timeStamp, $bidSize, $bid, $midPrice, $ask, $askSize, $shortDl, $longDl, $direction, $distanceDownTr, $distanceupTr,
     $position, $requiredPosition, $shortfall, $workingOrderCount, $workingQty, $workingPrice, $totalExecutedQty)
    = split(',',$line);
    
    $analytics->{timeStamp} = $timeStamp;
    $analytics->{position} = $position;
    $analytics->{reqPosition} = $requiredPosition;
    $analytics->{shortFall} = $shortfall;
    $analytics->{datasetId} = $datasetId;
    
    return $analytics;
}

sub parseOrcData {
    my $line = shift;
    
    my $analytics = Analytics->new();
    
    my ($timeStamp, $milliSecs, $algoStr, $position, $requiredPosition, $shortfall)
    = split(',',$line);
    
    my ($Plat, $algoname, $mar1, $mar2, $mar3, $mar4) = split(' ',$algoStr);
    my $mar = $mar1.$mar2.$mar3.$mar4;;
    if (!defined $algoName) {
        $algoName = $algoname;
    }
    
    if ($tempAlgo eq "") {
        $tempAlgo = $algoStr;
        $market = $mar;
    }
    
    if ($tempAlgo ne $algoStr) {
        $n++;
        if ($algoname ne $algoName) {
            $algoName = $algoname;
            $algoId = storeAlgoDetails($platId, $algoName);
            my $algoVers = ("0.").$n;
            my $algoVersionDes = ("Orc Algo version ")." 0.".$n;
            $algoVersionId = storeAlgoVersionDetails($algoId, $algoVers, $algoVersionDes);
        }
        
        if ($market ne $mar) {
            my $datasetDes = $datasetDesc." 0.".$n;
            $datasetId = storeDatasetDetails($algoVersionId, $reportDate, $datasetDes);
        }
        
        $tempAlgo = $algoStr;
    }

    $analytics->{timeStamp} = $timeStamp.".".$milliSecs;
    $analytics->{position} = $position;
    $analytics->{reqPosition} = $requiredPosition;
    $analytics->{shortFall} = $shortfall;
    $analytics->{datasetId} = $datasetId;
    
    return $analytics;
}

sub getPlatformId {
    my $fileName = shift;
  
    my $platId;
    if (defined $platName) {
        my $sql = "SELECT id FROM platform WHERE name = \"" . $platName . "\"";
        my $sth  = $dbh->prepare($sql);
        $sth->execute();
        my @results = $sth->fetchrow_array;
        if (!defined($results[0])) {
            $platId = 0;
        } else {
            $platId = $results[0];
        }
        $sth->finish;
    }
    return $platId;
}

sub storeAlgoDetails {
    my $platId = shift;
    my $algoName = shift;
  
    if (defined $platId) {
        my $sql = "insert into algorithm (NAME,PLATFORM_ID) values (\"" . $algoName . "\"," . $platId . ");"; 
        my $sth  = $dbh->prepare($sql);
        $sth->execute();
        #my $algoId = $sth->execute()->insertid($sql);
        $algoId = $dbh->{'mysql_insertid'}
        or warn "SQL Error: $DBI::errstr\n";   
        if (!defined($algoId)) {
            $algoId = 0;
        } else {
            $algoId = $algoId;
        }
        $sth->finish;
    }
    return $algoId;
}

sub storeAlgoVersionDetails {
    my $algoId = shift;
    my $algoVersion = shift;
    my $algoVersionDesc = shift;
  
    if (defined $algoId) {
        my $sql = "insert into algo_version (ALGO_VERSION, DESCRIPTION, ALGO_ID) values (\"" . $algoVersion . "\",\"" . $algoVersionDesc . "\"," . $algoId . ");"; 
        my $sth  = $dbh->prepare($sql);
        $sth->execute();
        $algoVersionId = $dbh->{'mysql_insertid'}
        or warn "SQL Error: $DBI::errstr\n";   
        if (!defined($algoVersionId)) {
            $algoVersionId = 0;
        } else {
            $algoVersionId = $algoVersionId;
        }
        $sth->finish;
    }
    return $algoVersionId;
}

sub storeDatasetDetails {
    my $algoVersionId = shift;
    my $reportDate = shift;
    my $datasetDesc = shift;
  
    if (defined $algoVersionId) {
        my $sql = "insert into dataset (DATE, ALGO_VERSION_ID, DESCRIPTION) values (\"" . $reportDate . "\"," . $algoVersionId . ",\"" . $datasetDesc . "\");";  
        my $sth  = $dbh->prepare($sql);
        $sth->execute();
        $datasetId = $dbh->{'mysql_insertid'}
        or warn "SQL Error: $DBI::errstr\n";   
        if (!defined($datasetId)) {
            $datasetId = 0;
        } else {
            $datasetId = $datasetId;
        }
        $sth->finish;
    }
    return $datasetId;
}

sub connectToDB { 
    my $dsn = 'DBI:mysql:portfolio_report;host=AFT-INT-1;port=3306';
    $dbh = DBI->connect($dsn,'root','aftmysql') or die "Connection Error: $DBI::errstr\n";
    return;
}

sub disconnectFromDB {
    $dbh->disconnect;
}

sub storePortfolioData {
    my $dataset = shift;
    my $datasetId = shift;
    foreach my $data (@$dataset) {
        my $sql = "insert into portfolio_data values (\"" . $data->{timeStamp} . "\"," . $data->{datasetId} . "," . $data->{position} . ",". $data->{reqPosition} . "," . $data->{shortFall} . ");";
        print "sql is " . $sql . "\n";
        my $sth = $dbh->prepare($sql);
        print STDERR "inserting rows\n";
        $sth->execute or
        warn "SQL Error: $DBI::errstr\n";   
     }
    @{ $dataset };
}

####################  MAIN  #################
    my $inputFilename = "analytics_2015-02-11_120225.txt";
    #my $inputFilename = "orc-portfoliostats.log";
    open(INPUTFILE, "<$inputFilename") or die "could not open file $inputFilename";

    if ($inputFilename eq /Orc/i){
        $platName = "Orc";
    }
    #elsif ($inputFilename eq /analytics_/i){
      #  $platName = "ADL";    
    #}
    else {
        $platName = "IB";
    }
    
    connectToDB();
    $platId = getPlatformId($platName);
    #$algoName = "Orc algo";  
    $reportDate = "2015-02-11";

    if ($platName eq "IB") { 
        $_ = <INPUTFILE>;
    
        $algoName = "IB algo 2";
        $algoVersion = "0.3";
        $algoVersionDesc = "IB Algo version 0.3";
        $datasetDesc = "IB-".$inputFilename;
  
        my $algoId = storeAlgoDetails($platId, $algoName);
        my $algoVersionId = storeAlgoVersionDetails($algoId, $algoVersion, $algoVersionDesc);
        $datasetId = storeDatasetDetails($algoVersionId, $reportDate, $datasetDesc);
    
        foreach $line (<INPUTFILE>) {
            my $data = parseIBData($line);
            push @dataArray, $data ;
        }
    }
    elsif($platName eq "Orc"){
        
        $datasetDesc = "Orc: ".$inputFilename . " version 0.".$n;
        $algoVersion = "0.1";
        $algoVersionDesc = "Orc Algo version 0.1";
        
        #my ($timeStamp, $milliSecs, $algoStr, $position, $requiredPosition, $shortfall)
    #= split(',',$line);
    
   # if (!defined $algoName) {
      #  my ($Plat, $algoname) = split(' ',$algoStr);
        #$algoName = $algoname;
    #}
    
        $algoName = "AFT1";
        
        $algoId = storeAlgoDetails($platId, $algoName);
        $algoVersionId = storeAlgoVersionDetails($algoId, $algoVersion, $algoVersionDesc);
        $datasetId = storeDatasetDetails($algoVersionId, $reportDate, $datasetDesc);
    
        foreach $line (<INPUTFILE>) {
            my $data = parseOrcData($line);
            push @dataArray, $data ;
        }
    }

    my $arrSize = @dataArray;
    print "record count: $arrSize\n";

storePortfolioData(\@dataArray);
disconnectFromDB();