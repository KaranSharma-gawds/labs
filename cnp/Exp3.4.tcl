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

$ns simplex-link $n0 $n2 0.5Mb 40ms DropTail
$ns simplex-link $n2 $n0 0.5Mb 40ms DropTail
$ns duplex-link $n1 $n2 1Mb 100ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail

$ns duplex-link-op $n2 $n1 orient left-up
$ns duplex-link-op $n2 $n0 orient right-up
$ns duplex-link-op $n2 $n3 orient down

$ns queue-limit $n2 $n3 40
$ns duplex-link-op $n2 $n3 queuePos 0.1

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
$udp set fid_ 1

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
$tcp set packet_size_ 512
$tcp set window_size_ 8000
$tcp set fid_ 2

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink

set null [new Agent/Null]
$ns attach-agent $n3 $null

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set interval_ 10ms

$ns connect $udp $null
$ns connect $tcp $sink

$ns at 0.5 "$ftp start"
$ns at 0.1 "$cbr start"
$ns at 4.5 "$cbr stop"
$ns at 5.0 "$ftp stop"

$ns at 5.5 "finish"

$ns run
