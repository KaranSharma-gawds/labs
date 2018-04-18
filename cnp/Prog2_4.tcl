set ns [new Simulator]
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

$ns duplex-link $n0 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n3 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n2 1Mb 10ms DropTail

$ns duplex-link-op $n0 $n4 orient right-down      
$ns duplex-link-op $n1 $n4 orient right-up 
$ns duplex-link-op $n4 $n3 orient right-up
$ns duplex-link-op $n4 $n2 orient right-down
 
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 500
$ftp0 set rate_ 1.5mb
$ftp0 attach-agent $tcp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set rate_ 1.5mb
$cbr1 attach-agent $udp1

set null0 [new Agent/Null] 
$ns attach-agent $n2 $null0
set null1 [new Agent/TCPSink]
$ns attach-agent $n3 $null1 
$ns connect $tcp0 $null1 
$ns connect $udp1 $null0
$ns at 0.5 "$ftp0 start" 
$ns at 1.0 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 4.5 "$ftp0 stop"
$tcp0 set class_ 1
$udp1 set class_ 2
$n4 color Green
$ns color 1 Blue
$ns color 2 Red
$ns at 10.0 "finish"
$ns run
