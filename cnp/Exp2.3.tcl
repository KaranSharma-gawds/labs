set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf
$ns color 1 red

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
#$ns queue-limit $n0 $n1 5
#$ns duplex-link-pos $n0 $n1 queuePos 0.5

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set ftp [new Application/FTP]
#$ftp set packet_size_ 1500
$ftp attach-agent $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$tcp set fid_ 1

$ns connect $tcp $sink

$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"

$ns at 5.0 "finish"

$ns run
