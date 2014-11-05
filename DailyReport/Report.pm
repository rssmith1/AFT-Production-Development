package Report;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{_accountName} = "";
    return $self;
}

sub accountName {
    my $self = shift;
    if (@_) {
        $self->{_accountName} = shift;
    }
    return $self->{_accountName};
}

sub reportName {
    my $self = shift;
    if (@_) {
        $self->{_reportName} = shift;
    }
    return $self->{_reportName};
}


sub beginDate {
    my $self = shift;
    if (@_) {
        $self->{_beginDate} = shift;
    }
    return $self->{_beginDate};
}

sub endDate {
    my $self = shift;
    if (@_) {
        $self->{_endDate} = shift;
    }
    return $self->{_endDate};
}


1;
