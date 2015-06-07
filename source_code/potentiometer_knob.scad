// Based on:
// https://www.youmagine.com/designs/knob-for-potentiometer-parametric
// By John Ridley

// Increase the resolution of default shapes
$fa = 5; // Minimum angle for fragments [degrees]
$fs = 0.5; // Minimum fragment size [mm]

od = 18;
odt = 10;
mainh = 12;
th = 17.5-mainh;

// knurling
kd = (od-14)/2;
kn = 10;

shaftd = 7;

rotate([180,0,0])
difference()
{
    translate([0,0,0.01])
	union()
	{
		cylinder(d=od, h=mainh);
		translate([0,0,mainh])
		cylinder(d1=od, d2=odt, h=th);
	}

	// knurling
	for (x=[0:kn])
        rotate([0,0,x * (360/kn)])
            translate([0,od/2 + kd*.2,0])
                cylinder(d=kd*1.5, h=mainh+th);

	// shaft hole
	cylinder(d=shaftd, h=mainh+th - 1.5, $fn = 8);

	// relief at bottom
	cylinder(d=od - kd*2, h=5);

}