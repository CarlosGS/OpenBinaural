
// 3D-printable Binaural Microphone
//
// by Carlos Garcia Saura (http://www.carlosgs.es)
// License: CC-BY-SA (http://creativecommons.org/licenses/by-sa/4.0/)
//
// The awesome ear model was designed by Jonathan March
// http://www.thingiverse.com/thing:499001
// http://professorgreenscreen.com/


// Increase the resolution of default shapes
$fa = 5; // Minimum angle for fragments [degrees]
$fs = 0.5; // Minimum fragment size [mm]

ear_rotation = -20;

ear_base_diameter = 110;
ear_canal_len_1 = 12;
ear_canal_len_2 = 8;
ear_canal_diam_1 = 7;
ear_canal_bump_height = 2;

mic_diam = 6.5;
mic_len = 8;

ear_base_thickness = ear_canal_len_1 + ear_canal_len_2 + mic_len;


screw_head_diam = 8;
screw_diam = 4;
screw_holder_thickness = 5;

screw_separation = 22;

module screw_hole() {
    rotate([0,90,0]) cylinder(r=screw_diam/2,h=ear_base_thickness);
    translate([screw_holder_thickness,0,0])
        rotate([0,90,0]) cylinder(r=screw_head_diam/2,h=ear_base_thickness-screw_holder_thickness);
}

module ear_left() {
    rotate([0,90,0])
        rotate([0,0,90+3+ear_rotation])
            translate([6.1,9.3,-3.01])
                import("ear_left.stl");
}

module ear_left_full() {
    difference() {
        union() {
            translate([0,0,0])
                ear_left();
            intersection() {
                rotate([0,-90,0])
                    hull() {
                    linear_extrude(height=0.01,center=true)
                        projection(cut=true)
                            rotate([0,90,0]) ear_left();
                    translate([0,0,ear_base_thickness])
                        cylinder(r=ear_base_diameter/2+4,h=0.01,center=true);
                    }
                translate([-ear_base_thickness,0,0])
                    sphere(r=ear_base_diameter/2);
                translate([-ear_base_thickness+ear_base_diameter/2-3,0,0])
                    sphere(r=ear_base_diameter/2+20);
            }
        }
        
        // Ear canal
        difference() {
            union(){
                hull() {
                    sphere(r=5.5);
                    translate([-ear_canal_len_1,0,ear_canal_bump_height])
                        sphere(r=ear_canal_diam_1/2);
                }
                hull() {
                    translate([-ear_canal_len_1,0,ear_canal_bump_height])
                        sphere(r=ear_canal_diam_1/2);
                    translate([-ear_canal_len_1-ear_canal_len_2,0,0])
                        sphere(r=mic_diam/2);
                }
                
                translate([-ear_canal_len_1-ear_canal_len_2,0,0])
                        rotate([0,20,0]) 
                            rotate([0,-90,0]) cylinder(r=mic_diam/2, h=mic_len*1.5);
            }
            translate([-ear_canal_len_1-ear_canal_len_2,0,mic_diam/2+0.3])
                rotate([90,0,0]) cylinder(r=1.5/2,h=mic_diam,center=true);
        }
        
        translate([-ear_base_thickness-0.1,0,0]) {
            translate([0,-screw_separation,screw_separation])
                screw_hole();
            translate([0,-screw_separation,-screw_separation])
                screw_hole();
            translate([0,screw_separation,-screw_separation])
                screw_hole();
        }
    }
}

module ear_right_full() {
    mirror([1,0,0])
        ear_left_full();
}



ear_separation = 125;


// Draw the canal section
//projection(cut=true) rotate([-90,0,0]) ear_left_full();

// Draw the head (assuming it is a sphere)
//#sphere(r=140/2);

translate([ear_separation/2,0,0])
    ear_left_full();
translate([-ear_separation/2,0,0])
    ear_right_full();


// Wood parts
wood_thickness = 10;
color("brown")
union() {
    translate([0,0,-screw_separation])
        cube([ear_separation-ear_base_thickness*2,screw_separation*2+wood_thickness,wood_thickness], center=true);
    rotate([-90,0,0])
        translate([0,0,-screw_separation])
            cube([ear_separation-ear_base_thickness*2,screw_separation*2+wood_thickness,wood_thickness], center=true);
}