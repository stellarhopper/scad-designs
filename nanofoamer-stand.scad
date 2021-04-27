// Copyright (C) 2021, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only
// For chamfer_extrude(), (C) 2019-02, Stewart Russell (scruss) - CC-BY-SA

$fn=200;
tube_d = 34.05;
ht = 30;
slot_w = 7;
slot_d = 27.5;
outer_r = 15;
base_side = 60;
ring_r = 1;

eq_ht = (base_side * sqrt(3))/2;
hole_pos = eq_ht/3 - eq_ht/8;
hole_ht = ht - 3;

module torus(r1, r2)
{
    rotate_extrude()
        translate([r1, 0, 0])
            circle(r2);
}

module chamfer_extrude(height = 2, angle = 10, center = false)
{
    /*
       chamfer_extrude - OpenSCAD operator module to approximate
        chamfered/tapered extrusion of a 2D path

       (C) 2019-02, Stewart Russell (scruss) - CC-BY-SA

       NOTE: generates _lots_ of facets, as many as

            6 * path_points + 4 * $fn - 4

       Consequently, use with care or lots of memory.

       Example:

            chamfer_extrude(height=5,angle=15,$fn=8)square(10);

       generates a 3D object 5 units high with top surface a
        10 x 10 square with sides flaring down and out at 15
        degrees with roughly rounded corners.

       Usage:
       
        chamfer_extrude (
            height  =   object height: should be positive
                            for reliable results               ,
            angle   =   chamfer angle: degrees                 ,
            center  =   false|true: centres object on z-axis [ ,
            $fn     =   smoothness of chamfer: higher => smoother
            ]
        ) ... 2D path(s) to extrude ... ;

       $fn in the argument list should be set between 6 .. 16:
            <  6 can result in striking/unwanted results
            > 12 is likely a waste of resources.
            
       Lower values of $fn can result in steeper sides than expected.
        
       Extrusion is not truly trapezoidal, but has a very thin
        (0.001 unit) parallel section at the base. This is a 
        limitation of OpenSCAD operators available at the time.
    */

    // shift base of 3d object to origin or
    //  centre at half height if center == true
    translate([ 0, 
                0, 
                (center == false) ? (height - 0.001) :
                                    (height - 0.002) / 2 ]) {
        minkowski() {
            // convert 2D path to very thin 3D extrusion
            linear_extrude(height = 0.001) {
                children();
            }
            // generate $fn-sided pyramid with apex at origin,
            // rotated "point-up" along the y-axis
            rotate(270) {
                rotate_extrude() {
                    polygon([
                        [ 0,                    0.001 - height  ],
                        [ height * tan(angle),  0.001 - height  ],
                        [ 0,                    0               ]
                    ]);
                }
            }
        }
    }
}

module slot_lip(r, w, l)
{
	difference() {
		chamfer_extrude(height = r, angle=45)
			square([l, w]);
		translate([0, 0, -1])
		cube([l, w, r+2]);
	}
}

module body()
{
    // main body
	hull() {
		translate([0, 0, 0])
			cylinder(r = outer_r, h = ht);
		translate([base_side, 0, 0])
			cylinder(r = outer_r, h = ht);
		translate([base_side/2, eq_ht, 0])
			cylinder(r = outer_r, h = ht);
	}

    // raised lip for main tube
	translate([base_side/2, hole_pos, ht])
		torus(tube_d/2 + ring_r, ring_r);

    // lips for screen slots
    // these are positioned in a brute-force way and not
    // calculated geometrically. Won't work well with edits
	translate([9.19, eq_ht - eq_ht/4 - 15.4, ht-0.05])
		rotate([0, 0, 60])
			slot_lip(1, slot_w, slot_d);
	translate([37.07, eq_ht - eq_ht/4 + 8.41, ht-0.05])
		rotate([0, 0, -60])
			slot_lip(1, slot_w, slot_d);
}

module tube_hole()
{
	translate([base_side/2, hole_pos, 4])
		cylinder(d = tube_d, h = hole_ht);
}

module slot(x_off, z_rot)
{
	translate([x_off, eq_ht - eq_ht/4, ht])
		rotate([90, 0, z_rot])
			cylinder(d = slot_d, h = slot_w);
}

difference() {
	body();
	tube_hole();
	slot(10, 60);
	slot(50, -60);
}
