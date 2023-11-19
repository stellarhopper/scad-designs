// Copyright (C) 2023, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

// Mount for the Philips One toothbrush (Sonicare)
// to mount to a mirror. Use suction tape such as:
//   https://www.amazon.com/dp/B08DCWQJ9R
// on the flat side to attach to a smooth flat surface.

$fn=200;

in_d = 17;
ht = 85;
wall = 1.5;
curve_r = 1;
curve_ends = true;

flat_x = in_d + wall * 2;
flat_y = in_d / 2 + wall;

end_cap_ht = in_d / 2 + wall;

module torus(cs_r, r)
{
    rotate_extrude()
        translate([r + cs_r, 0, 0])
            circle(cs_r);
}

module body()
{
    difference() {
        cylinder(d = in_d + 2 * wall, h = ht);
        translate([0, 0, wall])
            cylinder(d = in_d, h = ht);
    }

    translate([0, 0, ht])
        torus(wall / 2, in_d / 2);
}

module flat_side()
{
    difference() {
        translate([-in_d / 2 - wall, 0, 0]) {
            if (curve_ends == true) {
                // cube with curved sides
                hull() {
                    translate([curve_r, 0, 0])
                        cylinder(r = curve_r, h = ht);
                    translate([flat_x - curve_r, 0, 0])
                        cylinder(r = curve_r, h = ht);
                    translate([curve_r, flat_y - curve_r, 0])
                        cylinder(r = curve_r, h = ht);
                    translate([flat_x - curve_r, flat_y - curve_r, 0])
                        cylinder(r = curve_r, h = ht);
                }
            } else {
                cube([flat_x, flat_y, ht]);
            }
        }
        translate([0, 0, -1])
            cylinder(d = in_d + 2 * wall, h = ht - (wall / 2) + 2);
    }
}

module end_cap()
{
    difference() {
        cylinder(d = in_d + 2 * wall, h = end_cap_ht);
        translate([0, 0, end_cap_ht])
            sphere(d = in_d);
    }
}

module drain()
{
    translate([0, 0, -1])
        cylinder(r = wall, h = wall + 2);
}

module main()
{
    difference() {
        union() {
            body();
            flat_side();
            end_cap();
        }
        drain();
    }
}

main();