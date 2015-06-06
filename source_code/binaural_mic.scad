
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

ear_base_diameter = 100;
ear_canal_len_1 = 12;
ear_canal_len_2 = 8;
ear_canal_diam_1 = 5;
ear_canal_diam_2 = 6;
ear_canal_bump_height = 2;

mic_diam = 10.5;
mic_len = 8;
mic_transition_len = 1.5;

ear_base_thickness = ear_canal_len_1 + ear_canal_len_2 + mic_len;


screw_head_diam = 8;
screw_diam = 4;
screw_holder_thickness = 5;

screw_separation = 40;

ear_scale = 60/73.54;

module screw_hole() {
    rotate([0,90,0]) cylinder(r=screw_diam/2,h=ear_base_thickness);
    translate([screw_holder_thickness,0,0])
        rotate([0,90,0]) cylinder(r=screw_head_diam/2,h=ear_base_thickness-screw_holder_thickness);
}

module ear_left() {
    rotate([0,90,0])
        rotate([0,0,90+3+ear_rotation])
            scale(ear_scale)
                translate([8,10,-3.01])
                    import("ear_left.stl");
}

module ear_left_full() {
    difference() {
        union() {
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
                // Define the ear circular base
                translate([-ear_base_thickness,0,0])
                    sphere(r=ear_base_diameter/2);
                // Bevel
                translate([-ear_base_thickness+ear_base_diameter/2,0,0])
                    sphere(r=ear_base_diameter/2+20);
            }
        }
        
        // Ear canal
        difference() {
            union(){
                // Curved inner ear
                //translate([0,2,0.5])
                //    scale([0.5,1,1])
                //        sphere(r=8/2);
                hull() {
                    rotate([ear_rotation,0,0])
                        scale([0.5,0.5,1])
                            sphere(r=9/2);
                    translate([-ear_canal_len_1,0,ear_canal_bump_height])
                        sphere(r=ear_canal_diam_1/2);
                }
                hull() {
                    translate([-ear_canal_len_1,0,ear_canal_bump_height])
                        sphere(r=ear_canal_diam_1/2);
                    translate([-ear_canal_len_1-ear_canal_len_2,0,0])
                        sphere(r=ear_canal_diam_2/2);
                }
                translate([-ear_canal_len_1-ear_canal_len_2,0,0])
                        rotate([0,20,0]) {
                            // Transition
                            hull() {
                                sphere(r=ear_canal_diam_2/2);
                                translate([-mic_transition_len,0,0])
                                    rotate([0,90,0]) cylinder(r=mic_diam/2,h=0.01);
                            }
                            // Hole for the microphone
                            translate([-mic_transition_len,0,0])
                                rotate([0,-90,0]) cylinder(r=mic_diam/2, h=mic_len*1.5);
                            // Bevel
                            //translate([-mic_len,0,0])
                            //    rotate([0,-20,0])
                            //        translate([-3,0,0])
                            //            sphere(r=mic_diam/2+1.5);
                        }
            }
            // Bump to limit microphone depth
            //translate([-ear_canal_len_1-ear_canal_len_2,0,mic_diam/2+0.3])
            //    rotate([90,0,0]) cylinder(r=1.5/2,h=mic_diam,center=true);
        }
        
        translate([-ear_base_thickness-0.1,0,0]) {
            translate([0,-screw_separation/2,screw_separation/2])
                screw_hole();
            translate([0,-screw_separation/2,-screw_separation/2])
                screw_hole();
            translate([0,screw_separation/2,-screw_separation/2])
                screw_hole();
        }
    }
}

module ear_right_full() {
    mirror([1,0,0])
        ear_left_full();
}



ear_separation = 136;


// Draw the canal section
//!projection(cut=true) rotate([-90,0,0]) ear_left_full();

// Draw the head (assuming it is a sphere)
//#sphere(r=140/2);

translate([ear_separation/2,0,0])
    ear_left_full();
translate([-ear_separation/2,0,0])
    ear_right_full();


ear_base_separation = ear_separation-ear_base_thickness*2;

// Wood parts
tripod_hole_diam = 5.9;

wood_thickness = 3;
wood_length = ear_base_separation;

wood_radius = screw_head_diam/2 + 4;

font = "Comfortaa:style=Bold";
brand = "OpenBinaural";
letter_size = 7.5;


module wood_support_left(laser_cutter_offset=0) {
    translate([ear_base_separation/2,0,0])
        rotate([0,-90,0])
            difference() {
                union() {
                    hull() {
                        translate([screw_separation/2,-screw_separation/2,0])
                            cylinder(r=wood_radius,h=wood_thickness);
                        translate([-screw_separation/2,-screw_separation/2,wood_thickness/2])
                                cube([wood_radius*2,wood_radius*2,wood_thickness],center=true);
                    }
                    hull() {
                        translate([-screw_separation/2,-screw_separation/2,wood_thickness/2])
                                cube([wood_radius*2,wood_radius*2,wood_thickness],center=true);
                        translate([-screw_separation/2,screw_separation/2,0])
                                cylinder(r=wood_radius,h=wood_thickness);
                    }
                }
                // Screw holes
                translate([screw_separation/2,-screw_separation/2,0])
                    cylinder(r=screw_diam/2-laser_cutter_offset,h=wood_thickness*4,center=true);
                translate([-screw_separation/2,-screw_separation/2,0])
                    cylinder(r=screw_diam/2-laser_cutter_offset,h=wood_thickness*4,center=true);
                translate([-screw_separation/2,screw_separation/2,0])
                    cylinder(r=screw_diam/2-laser_cutter_offset,h=wood_thickness*4,center=true);
                // Wood "interlock" slots
                translate([wood_thickness,-screw_separation/2-wood_radius,0])
                    cube([15,wood_thickness*2,wood_thickness*2],center=true);
                translate([-screw_separation/2-wood_radius,0,0])
                    cube([wood_thickness*2,15,wood_thickness*2],center=true);
            }
}

module wood_support_right(laser_cutter_offset=0) {
    mirror([1,0,0])
        wood_support_left(laser_cutter_offset);
}



module wood_support_param(laser_cutter_offset=0,top=false) {
    difference() {
        translate([-ear_base_separation/2+0.005,-screw_separation/2-wood_radius+0.005,-screw_separation/2-wood_radius+0.005])
            cube([wood_length-0.01,screw_separation-0.01,wood_thickness-0.01]);
        wood_support_left(laser_cutter_offset);
        wood_support_right(laser_cutter_offset);
        if(top) {
            // Text
            translate([0,-15,-screw_separation/2-wood_radius])
                rotate([0,180,0])
                    linear_extrude(height=2,center=true)
                        text(brand, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
            // Hole for potentiometer
            translate([0,0,-screw_separation/2-wood_radius]) {
                    cylinder(r=7.2/2-laser_cutter_offset,h=10,center=true);
                    translate([7.8,0,0])
                        cube([1.6-laser_cutter_offset,3.5-laser_cutter_offset,10],center=true);
                }
            // Hole for LED
            translate([15,0,-screw_separation/2-wood_radius])
                cylinder(r=5.9/2-laser_cutter_offset,h=10,center=true);
            // Hole for switch
            translate([15+5+7,0,-screw_separation/2-wood_radius]) {
                    cylinder(r=6.2/2-laser_cutter_offset,h=10,center=true);
                    translate([6.5,0,0])
                        cube([1.1-laser_cutter_offset,2.5-laser_cutter_offset,10],center=true);
                }
        } else {
            // Hole for tripod mount
            translate([0,0,-screw_separation/2-wood_radius]) {
                cylinder(r=tripod_hole_diam/2-laser_cutter_offset,h=10,center=true);
                translate([10,0,0])
                    cylinder(r=tripod_hole_diam/2-laser_cutter_offset,h=10,center=true);
                translate([-10,0,0])
                    cylinder(r=tripod_hole_diam/2-laser_cutter_offset,h=10,center=true);
                translate([0,-10,0])
                    cylinder(r=tripod_hole_diam/2-laser_cutter_offset,h=10,center=true);
            }
        }
    }
}

module wood_support_bottom(laser_cutter_offset=0) {
    wood_support_param(laser_cutter_offset,top=false);
}

module wood_support_top(laser_cutter_offset=0) {
    translate([0,0,wood_thickness])
        rotate([90,0,0])
            rotate([0,180,0])
                wood_support_param(laser_cutter_offset,top=true);
}

module wood_support_full() {
    wood_support_left();
    wood_support_right();
    wood_support_bottom();
    wood_support_top();
}

color("brown")
    wood_support_full();

module wood_support_flat(laser_cutter_offset=0) {
    translate([10,-59,-ear_base_separation/2+0.1])
        rotate([0,0,90])
            rotate([0,-90,0])
                wood_support_left(laser_cutter_offset);
    
    translate([-10,-59,-ear_base_separation/2+0.1])
        rotate([0,90,0])
            wood_support_right(laser_cutter_offset);
    
    translate([0,0,-screw_separation/2-wood_radius+0.1])
        rotate([0,180,0])
            wood_support_bottom(laser_cutter_offset);
    
    translate([0,40,-screw_separation/2-wood_radius+0.1])
        rotate([-90,0,0])
            wood_support_top(laser_cutter_offset);
}

module wood_support_lasercut() {
    projection(cut=true) wood_support_flat(laser_cutter_offset = 0.5);
}

//!wood_support_flat();
//!wood_support_lasercut();

echo("Wood piece length:");
echo(wood_length);
echo("mm");