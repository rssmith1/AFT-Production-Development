package Position;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{_mtmPnL} = 0;
    $self->{_quantity} = 0;
    $self->{_markPrice} = 0;
    $self->{_portfolio} = "UNK";
    $self->{_tradedQuantity} = 0;
    $self->{_totalCommission} = 0;
    return $self;
}


sub symbol {
    my $self = shift;
    if (@_) {
        $self->{_symbol} = shift;
    }
    return $self->{_symbol};
}

sub mtmPnL {
    my $self = shift;
    if (@_) {
        $self->{_mtmPnL} = shift;
    }
    return $self->{_mtmPnL};
}

sub tradedQuantity {
    my $self = shift;
    if (@_) {
        $self->{_tradedQuantity} = shift;
    }
    return $self->{_tradedQuantity};
}

sub totalCommission {
    my $self = shift;
    if (@_) {
        $self->{_totalCommission} = shift;
    }
    return $self->{_totalCommission};
}

sub mtmPnLWeek {
    my $self = shift;
    if (@_) {
        $self->{_mtmPnLWeek} = shift;
    }
    return $self->{_mtmPnLWeek};
}

sub quantity {
    my $self = shift;
    if (@_) {
        $self->{_quantity} = shift;
    }
    return $self->{_quantity};
}

sub markPrice {
    my $self = shift;
    if (@_) {
        $self->{_markPrice} = shift;
    }
    return $self->{_markPrice};
}

sub portfolio {
    my $self = shift;
    if (@_) {
        $self->{_portfolio} = shift;
    }
    return $self->{_portfolio};
}

1;
