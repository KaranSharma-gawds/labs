set ns [new Simulator]

$ns color 1 Red
$ns color 2 Blue

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

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n3 2Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-down
$ns duplex-link-op $n2 $n1 orient right-up
$ns duplex-link-op $n1 $n3 orient right

$ns queue-limit $n1 $n3 7
$ns duplex-link-op $n1 $n3 queuePos 1

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
$tcp set fid_ 1

set udp [new Agent/UDP]
$ns attach-agent $n2 $udp
$udp set fid_ 2

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set rate_ 1.5mb

set null [new Agent/Null]
$ns attach-agent $n3 $null

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

$ns connect $tcp $sink
$ns connect $udp $null

$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 4.5 "$cbr stop"
$ns at 4.5 "$ftp stop"

$ns at 5.0 "finish"

$ns run
