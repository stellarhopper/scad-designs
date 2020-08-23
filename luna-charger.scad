// Copyright (C) 2020, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

$fn = 100;

chg_w = 208;
chg_d = 58;
chg_h = 91;
wall = 2.4;
lip = 5;
cable_d = 10;
cable_in = 13;
screw_d = 4;
screw_hd = 8.5;

out_w = chg_w + (2 * wall);
out_d = chg_d + (2 * wall);
out_h = chg_h + (2 * wall);

module angle_cut(with_cutout)
{
    difference() {
        union() {
            cylinder(r = out_d - wall, h = lip + wall);
            translate([0, 0, lip + wall])
                cylinder(r1 = out_d - wall, r2 = wall/2, h = out_h - (2*wall)-lip);
        }
        translate([-out_d, -out_d, -1])
            cube([2 * out_d, out_d, out_h + 2]);
        translate([wall/2, -1, -1])
            cube([out_d, out_d+2, out_h + 2]);
        translate([-(wall/2 + out_d), -1, -1])
            cube([out_d, out_d+2, out_h + 2]);
        if (with_cutout == "small") {
            hull() {
                // main knob
                translate([-wall, out_d - 17, 17])
                    rotate([0, 90, 0]) cylinder(r=13, h=wall + 2);
                // elongation - up
                translate([-wall, out_d - 10, 26])
                    rotate([0, 90, 0]) cylinder(r=13, h=wall + 2);
                // elongation - front
                translate([-wall, out_d - 10, 19])
                    rotate([0, 90, 0]) cylinder(r=13, h=wall + 2);
            }
        }
        if (with_cutout == "large") {
            translate([-wall, chg_d/2 + 3*wall, chg_h/2])
                rotate([0, 90, 0]) cylinder(r=26, h=wall + 2);
        }
    }
}

module main_body()
{
    difference() {
        cube([out_w, out_d, out_h]);
        translate([-1, wall, wall])
            cube([chg_w + 4*wall, chg_d + 2*wall, chg_h + 2*wall]);
    }
}

module lip()
{
    cube([out_w, wall, lip + wall]);
    translate([0, wall/2, wall + lip])
        rotate([0, 90, 0])
            cylinder(r=wall/2, h=out_w);
}

module cable_hook()
{
    scale([0.6, 1, 1])
    difference() {
        cylinder(r = out_d/2, h = wall);
        hull() {
            translate([out_d/2, 0, -1]) cylinder(r = cable_d/2, h=wall+2);
            translate([out_d/2 - 12, 0, -1]) cylinder(r = cable_in/2, h=wall+2);
        }
    }
}

module cable_support()
{
    difference() {
        cube([wall, out_d, 2*wall]);
        translate([wall, out_d + 1, 2*wall])
            rotate([90, 0, 0])
                cylinder(r = wall, h = out_d + 2);
    }  
}

module screw_hole(counter)
{
    translate([0, wall + 1, 0])
        rotate([90, 0, 0])
            if (counter == true)
                cylinder(r2 = screw_d/2, r1 = screw_hd/2 + 1, h = wall + 2);
            else
                cylinder(r = screw_d/2, h = wall + 2);
}

module weight_hole_h(rad, dist)
{
    hull() {
        translate([0, 0, -1])
            cylinder(r = rad, h = wall + 2);
        translate([rad + dist, 0, -1])
            cylinder(r = rad, h = wall + 2);
    }
}

module weight_hole_v(rad, dist)
{
    hull() {
        translate([0, wall+1, rad])
            rotate([90, 0, 0])
                cylinder(r = rad, h = wall + 2);
        translate([0, wall+1, (2*rad) + dist])
            rotate([90, 0, 0])
                cylinder(r = rad, h = wall + 2);
    }
}

module body()
{
    main_body();
    translate([wall/2, wall, wall])
        angle_cut(with_cutout="small");
    translate([chg_w + wall + wall/2, wall, wall])
        angle_cut(with_cutout="large");
    translate([0, chg_d + wall, wall])
        lip();
    translate([out_w+wall, out_d/2, 0])
        cable_hook();
    translate([out_w, 0, 0])
        cable_support();
}

module final() {
    difference() {
        body();
        translate([out_w/2, 0, out_h/2])
            screw_hole(counter=true);
        translate([out_w-10, 0, 10])
            screw_hole(counter=true);
        translate([10, 0, 10])
            screw_hole(counter=true);
        // 3x horizontal base holes
        translate([30, out_d/2, 0])
            weight_hole_h(15, 17);
        translate([out_w - 60, out_d/2, 0])
            weight_hole_h(15, 17);
        translate([out_w - 113, out_d/2, 0])
            weight_hole_h(15, 0);
        // strap slots
        translate([out_w - 118, wall + 3, 0])
            weight_hole_h(1.5, 25);
        translate([out_w - 118, out_d - wall -3, 0])
            weight_hole_h(1.5, 25);
        // 2x vertical backplate holes
        translate([55, 0, 15])
            weight_hole_v(20, 5);
        translate([160, 0, 15])
            weight_hole_v(20, 5);
    }
}

final();