// Copyright (C) 2024, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

// Mount for the Aqara Presence Sensor FP2
// Use on an electrical box faceplate or similar
// This angles the sensor at 45 degrees.

$fn=200;

id = 49.05;
wall = 4;
ht = 11.2;

cube_y = 20;
cube_x = 10;
cube_z = 10;

screw_d = 3.9;
head_d = 10;
head_h = 9;

module shroud()
{
    cylinder(d = id + wall, h = ht + wall);
}

module mount()
{
    translate([(id + wall)/2 - cube_x + 1, -cube_y / 2, 0])
        rotate([0, 45, 0])
            cube([cube_x, cube_y, cube_z]);
}

module hole()
{
    translate([0, 0, wall])
        cylinder(d = id, h = ht + 4);
}

module screw_hole()
{
    translate([(id + wall)/2 - cube_x + 1, -cube_y / 2, 0])
        rotate([0, 45, 0])
            translate([-3, cube_y / 2, cube_z / 2])
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = cube_x + 4);
}

module screw_cavity()
{
    translate([(id + wall)/2 - cube_x + 1, -cube_y / 2, 0])
        rotate([0, 45, 0])
            translate([-6, cube_y / 2, cube_z / 2])
                rotate([0, 90, 0])
                    cylinder(d = head_d, h = head_h);
}

difference() {
    union() {
        shroud();
        mount();
    }
    hole();
    screw_hole();
    screw_cavity();
}