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

$ns duplex-link $n0 $n1 2MB 10ms DropTail
$ns duplex-link-op $n0 $n1 orient Right

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1000
$cbr set interval_ 0.005
$cbr attach-agent $udp0

set null0 [new Agent/NULL]
$ns attach-agent $n0 $null0 

$ns connect $udp0 $null0

$ns at 5.0 "finish"
$ns at 0.1 "cbr start"

$ns run
