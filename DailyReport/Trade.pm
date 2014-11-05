package Trade;
use strict;
use warnings;


#"HEADER","TRNT","Symbol","TradeDate","TransactionType","Quantity","TradePrice","TradeMoney","Proceeds","Taxes","IBCommission","IBCommissionCurrency","ClosePrice","Open/CloseIndicator","Notes/Codes","CostBasis","FifoPnlRealized","MtmPnl","OrigTradePrice","OrigTradeDate","Buy/Sell","OrderReference","OpenDateTime","LevelOfDetail","ChangeInPrice","ChangeInQuantity","NetCash"

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub symbol {
    my $self = shift;
    if (@_) {
        $self->{_symbol} = shift;
    }
    return $self->{_symbol};
}


sub tradeDate {
    my $self = shift;
    if (@_) {
        $self->{_tradeDate} = shift;
    }
    return $self->{_tradeDate};
}

sub transactionType {
    my $self = shift;
    if (@_) {
        $self->{_transactionType} = shift;
    }
    return $self->{_transactionType};
}

sub quantity {
    my $self = shift;
    if (@_) {
        $self->{_quantity} = shift;
    }
    return $self->{_quantity};
}

1;
