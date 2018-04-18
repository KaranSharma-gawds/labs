set ns [new Simulator]

$ns color 1 red
$ns color 2 blue

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

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 40ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 30ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n2 $n1 orient left-down
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

$ns queue-limit $n2 $n3 3
$ns duplex-link-op $n2 $n3 queuePos 0.5

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
$tcp set fid_ 2

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
$udp set fid_ 1

set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink

set null [new Agent/Null]
$ns attach-agent $n5 $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$ns connect $tcp $sink
$ns connect $udp $null

$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 4.5 "$ftp stop"
$ns at 5.0 "$cbr stop"

$ns at 5.5 "finish"

$ns run
