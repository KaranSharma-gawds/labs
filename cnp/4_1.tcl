set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
proc finish {} {
	global ns nf
	close $nf
	exec nam out.nam &
	exit 0
}
set n0 [$ns
