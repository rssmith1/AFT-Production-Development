package Analytics;
use strict;
use warnings;

my %actions;

sub new {
    my $class = shift;
    my $self = bless {}, $class;    
    $self->{timeStamp} = "";
    $self->{position} = 0;
    $self->{reqPosition} = 0;
    $self->{shortFall} = 0;
    $self->{datasetId} = 0;
    return $self;
}

sub timeStamp {
    my $self = shift;
    if (@_) {
        $self->{_timeStamp} = shift;
    }
    return $self->{_timeStamp};
}

sub position {
    my $self = shift;
    if (@_) {
        $self->{_position} = shift;
    }
    return $self->{_position};
}

sub reqPosition {
    my $self = shift;
    if (@_) {
        $self->{_reqPosition} = shift;
    }
    return $self->{_reqPosition};
}

sub shortFall {
    my $self = shift;
    if (@_) {
        $self->{_shortFall} = shift;
    }
    return $self->{_shortFall};
}

sub datasetId {
    my $self = shift;
    if (@_) {
        $self->{_datasetId} = shift;
    }
    return $self->{_datasetId};
}

1;
