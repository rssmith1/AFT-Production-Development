#!/usr/bin/perl -w
use strict qw(vars subs);

sub f { return 11; }
my $action = 'f';
print $action->();


my $t = test->new();
$t->indirectAdd(4,5);

package test;
my %dispatch;
my $value = "";

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $value = 10;
    $dispatch{add} = \&{$self->add()};
    return $self;
}

sub add {
    my $self = shift;
    return $value * 3;
}

sub indirectAdd {
    my $self = shift;
    my $op1 = shift;
    my $op2 = shift;
    my $name = "add";
    return &{$dispatch{$name}->($op1,$op2)};
}