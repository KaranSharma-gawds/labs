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

$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link-op $n0 $n1 orient right

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
$udp set fid_ 1

set sink [new Agent/Null]
$ns attach-agent $n1 $sink

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1000
$cbr set interval_ 0.005
$cbr attach-agent $udp

$ns connect $udp $sink

$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"

$ns at 5.0 "finish"

$ns run

