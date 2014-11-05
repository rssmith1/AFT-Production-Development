package Account;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{_totalEquity} = 0.0;
    $self->{_equityChange} = 0.0;
    return $self;
}

sub totalEquity {
    my $self = shift;
    if (@_) {
        $self->{_totalEquity} = shift;
    }
    return $self->{_totalEquity};
}

sub date {
    my $self = shift;
    if (@_) {
        $self->{_date} = shift;
    }
    return $self->{_date};
}

sub equityChange {
    my $self = shift;
    if (@_) {
        $self->{_equityChange} = shift;
    }
    return $self->{_equityChange};
}

sub weekEquityChange {
    my $self = shift;
#    if (@_) {
#        $self->{_weekEquityChange} = shift;
#    }
#    return $self->{_weekEquityChange};
    my $result;
    if ($self->weekBeginEquity == 0) {
        $result = $self->equityChange;
    } else {
        $result = $self->totalEquity - $self->weekBeginEquity;
    }
    return sprintf "%0.2f", $result;
}

sub weekBeginEquity {
    my $self = shift;
    if (@_) {
        $self->{_weekBeginEquity} = shift;
    }
    return $self->{_weekBeginEquity};
}




1;
