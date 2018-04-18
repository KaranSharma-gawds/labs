set val(chan) Channel/WirelessChannel;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11;# MAC type
set val(ifq) Queue/DropTail;# interface queue type
set val(ll) LL;# link layer type
set val(ant) Antenna/OmniAntenna;# antenna model
set val(ifqlen) 50;# max packet in ifq
set val(nn) 10 ;# number of mobilenodes
set val(rp) AODV ;# routing protocol
set val(x) 670 ;# X dimension of topography
set val(y) 670 ;# Y dimension of topography
set val(stop) 200;# time of simulation end

set ns [new Simulator]

set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

set tracefile [open p6.tr w]
$ns trace-all $tracefile

set namfile [open p6.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

$ns node-config -adhocRouting $val(rp) \
	-llType $val(ll) \
	-macType $val(mac) \
	-ifqType $val(ifq) \
	-ifqLen $val(ifqlen) \
	-antType $val(ant) \
	-propType $val(prop) \
	-phyType $val(netif) \
	-channel $chan \
	-topoInstance $topo \
	-agentTrace ON \
	-routerTrace ON \
	-macTrace ON \
	-movementTrace ON

#Create 6 nodes with initial positions
set n0 [$ns node]
$n0 set X_ 150
$n0 set Y_ 300
$n0 set Z_ 0.0
$ns initial_node_pos $n0 40

set n1 [$ns node]
$n1 set X_ 300
$n1 set Y_ 500
$n1 set Z_ 0.0
$ns initial_node_pos $n1 40

set n2 [$ns node]
$n2 set X_ 500
$n2 set Y_ 500
$n2 set Z_ 0.0
$ns initial_node_pos $n2 40

set n3 [$ns node]
$n3 set X_ 300
$n3 set Y_ 100
$n3 set Z_ 0.0
$ns initial_node_pos $n3 40

set n4 [$ns node]
$n4 set X_ 500
$n4 set Y_ 100
$n4 set Z_ 0.0
$ns initial_node_pos $n4 40

set n5 [$ns node]
$n5 set X_ 650
$n5 set Y_ 300
$n5 set Z_ 0.0
$ns initial_node_pos $n5 40

set n6 [$ns node]
$n5 set X_ 700
$n5 set Y_ 300
$n5 set Z_ 0.0
$ns initial_node_pos $n6 40

set n7 [$ns node]
$n5 set X_ 750
$n5 set Y_ 300
$n5 set Z_ 0.0
$ns initial_node_pos $n7 40

set n8 [$ns node]
$n5 set X_ 800
$n5 set Y_ 300
$n5 set Z_ 0.0
$ns initial_node_pos $n8 40

set n9 [$ns node]
$n5 set X_ 850
$n5 set Y_ 300
$n5 set Z_ 0.0
$ns initial_node_pos $n9 40

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink9 [new Agent/TCPSink]

$ns attach-agent $n9 $sink9
$ns connect $tcp0 $sink9
$tcp0 set packetSize_ 1500

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 0.0 "$ftp0 start"
$ns at 60.0 "$ftp0 stop"

#$ns at 4.0 "$n3 setdest 300.0 500.0 5.0"

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam p6.nam &
	exec cat p6.tr | awk -f p6.awk &
	exit 0
}

for {set i 0} {$i < $val(nn) } { incr i } {
	$ns at $val(stop) "\$n$i reset"
}

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
