set ns [new Simulator]

$ns color 1 red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

$ns duplex-link $n0 $n1 0.5Mb 40ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 40ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 40ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 40ms DropTail
$ns duplex-link $n4 $n5 0.5Mb 40ms DropTail
$ns duplex-link $n5 $n6 0.5Mb 40ms DropTail
$ns duplex-link $n6 $n7 0.5Mb 40ms DropTail
$ns duplex-link $n7 $n8 0.5Mb 40ms DropTail
$ns duplex-link $n8 $n9 0.5Mb 40ms DropTail
$ns duplex-link $n9 $n0 0.5Mb 40ms DropTail

#$ns duplex-link-op $n0 $n1 orient right-up
#$ns duplex-link-op $n1 $n2 orient right
#$ns duplex-link-op $n2 $n3 orient right
#$ns duplex-link-op $n3 $n4 orient right
#$ns duplex-link-op $n4 $n5 orient right-down
#$ns duplex-link-op $n5 $n6 orient left-down
#$ns duplex-link-op $n6 $n7 orient left
#$ns duplex-link-op $n7 $n8 orient left
#$ns duplex-link-op $n8 $n9 orient left
#$ns duplex-link-op $n9 $n0 orient left-up



$ns at 5 "finish"

$ns run
