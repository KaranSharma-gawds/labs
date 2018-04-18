set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 10Mb 2ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down

$ns duplex-link $n1 $n2 10Mb 3ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up

$ns duplex-link $n2 $n3 1.5Mb 20ms DropTail
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link $n3 $n4 10Mb 4ms DropTail
$ns duplex-link-op $n3 $n4 orient right-up

$ns duplex-link $n3 $n5 10Mb 5ms DropTail
$ns duplex-link-op $n3 $n5 orient right-down

$ns queue-limit $n2 $n3 7
$ns duplex-link-op $n2 $n3 queuePos 0.5
 
set tcp1 [new Agent/TCP]
$n0 set window_size_ 0
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

set tcp2 [new Agent/TCP]
$n1 set window_size_ 0
$ns attach-agent $n1 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink2
$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}

$ns at 0.2 "$ftp1 start"
$ns at 0.3 "$ftp2 start"
$ns at 4.0 "$ftp1 stop"
$ns at 4.5 "$ftp2 stop"

$ns at 5.0 "finish"
$ns run


