set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
$n1  color red
$n1 shape square

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down

$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up

$ns duplex-link $n2 $n3 0.5Mb 10ms DropTail
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link-op $n3 $n4 orient right-up

$ns duplex-link $n4 $n6 1Mb 10ms DropTail
$ns duplex-link-op $n4 $n6 orient right

$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link-op $n3 $n5 orient right-down

$ns duplex-link $n5 $n7 1Mb 10ms DropTail
$ns duplex-link-op $n5 $n7 orient right

$ns queue-limit $n2 $n3 7
$ns duplex-link-op $n2 $n3 queuePos 0.5
 
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n6 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n7 $null
$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}

$ns at 1.0 "$ftp start"
$ns at 5.0 "$ftp stop"
$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"

$ns at 5.5 "finish"
$ns run


