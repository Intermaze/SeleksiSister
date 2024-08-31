#!/usr/bin/perl
use strict;
use warnings;
use feature 'bitwise'; #Memastikan '~' merupakan numberic bit operations

sub add {
    my ($a, $b) = @_;
    my $carry;

    ADD_LOOP:
    if ($b != 0) {
        $carry = $a & $b;
        $a = $a ^ $b;
        $b = $carry << 1;
        goto ADD_LOOP;
    }
    return $a;
}

sub subtract {
    my ($a, $b) = @_;
    my $borrow;

    SUBTRACT_LOOP:
    if ($b != 0) {
        $borrow = ~$a & $b;
        $a = $a ^ $b;
        $b = $borrow << 1;
        goto SUBTRACT_LOOP;
    }
    return $a;
}

sub multiply {
    my ($a, $b) = @_;
    my $result = 0;

    MULTIPLY_LOOP:
    if ($b > 0) {
        if ($b & 1) {
            $result = add($result, $a);
        }
        $a <<= 1;
        $b >>= 1;
        goto MULTIPLY_LOOP;
    }
    return $result;
}

sub divide {
    my ($dividend, $divisor) = @_;
    my $quotient = 0;
    my $temp_dividend = $dividend;
    my $temp;
    my $multiple;

    DIVIDE_OUTER_LOOP:
    if ($temp_dividend >= $divisor) {
        $temp = $divisor;
        $multiple = 1;

        DIVIDE_INNER_LOOP:
        if ($temp_dividend >= ($temp << 1)) {
            $temp <<= 1;
            $multiple <<= 1;
            goto DIVIDE_INNER_LOOP;
        }

        $temp_dividend = subtract($temp_dividend, $temp);
        $quotient = add($quotient, $multiple);
        goto DIVIDE_OUTER_LOOP;
    }
    return $quotient;
}

sub power {
    my ($base, $exponent) = @_;
    my $result = 1;

    POWER_LOOP:
    if ($exponent > 0) {
        $result = multiply($result, $base);
        $exponent = subtract($exponent, 1);
        goto POWER_LOOP;
    }
    return $result;
}

print "Welcome to klak-klak-klakulator!\n";
print "Input math expression (ex: 2+4*5/3^3): ";
my $input = <STDIN>;
chomp($input);

my @tokens = split(/(\D)/, $input);

my $result = shift @tokens;
while (@tokens) {
    my $operator = shift @tokens;
    my $operand  = shift @tokens;

    if ($operator eq '+') {
        $result = add($result, $operand);
    } elsif ($operator eq '-') {
        $result = subtract($result, $operand);
    } elsif ($operator eq '*') {
        $result = multiply($result, $operand);
    } elsif ($operator eq '/') {
        if ($operand == 0) {
            die "Error: division by 0\n";
        }
        $result = divide($result, $operand);
    } elsif ($operator eq '^') {
        $result = power($result, $operand);
    } else {
        die "Error: unknown operator '$operator'.\n";
    }
}

$result = unpack("l", pack("l", $result));
print "Result: $result\n";
