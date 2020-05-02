// Copyright (C) 2020, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

$fn=100;

len = 140;
hbase = 102;
htop = 60;
wall = 2;
box_y = 32 + wall;
wid = 90 - box_y;
radius = 10;

htot = hbase + htop;

module curve_box(x, y, h, r, w)
{
    difference() {
        hull() {
            cube([x, 10, h]);
            translate([r, y-r, 0]) cylinder(r=r, h=h);
            translate([x-r, y-r, 0]) cylinder(r=r, h=h);
        }
            hull() {
                translate([w, w, w]) cube([x-(2*w), 10, h]);
                translate([r+w, y-r-w, w]) cylinder(r=r, h=h);
                translate([x-r-w, y-r-w, w]) cylinder(r=r, h=h);
        }
    }
}

difference() {
    union() {
        curve_box(len, wid, htot, radius, wall);
        translate([len, wall, hbase])
            rotate([0, 0, 180])
                curve_box(len, box_y, htop, 1, wall);
        translate([50, -box_y + wall, hbase])
            cube([wall, box_y - wall, htop]);
    }
    translate([-1, wall, htot])
        rotate([-20, 0, 0])
            cube([len + 2, len, len]);
}