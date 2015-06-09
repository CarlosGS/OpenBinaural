// Based on:
// https://www.youmagine.com/designs/knob-for-potentiometer-parametric
// By John Ridley

// Increase the resolution of default shapes
$fa = 5; // Minimum angle for fragments [degrees]
$fs = 0.5; // Minimum fragment size [mm]

od = 18;
odt = 10;
mainh = 0;
th = 17.5-mainh;

// knurling
kd = 7/2;
kn = 10;

shaftd = 6.5;

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
            translate([0,od/2,0])
                hull() {
                    //rotate([10,0,0]) cylinder(d1=kd, d2=kd, h=mainh+th-1);
                    cylinder(d=2*od/kn, h=0.01);
                    translate([0,(odt-od)/2,mainh+th-1])
                        cylinder(d=2*odt/kn, h=0.01);
                }

	// shaft hole
	cylinder(d=shaftd, h=mainh+th - 1.5, $fn = 8);

	// relief at bottom
	cylinder(d1=12,d2=od - kd*2, h=5);

}