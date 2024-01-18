// Copyright (C) 2024, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

// Mount for the Aqara Presence Sensor FP2
// Use on an electrical box faceplate or similar

$fn=200;

id = 49.05;
wall = 4;
ht = 11.2;

cube_y = 20;
cube_x = 10;
cube_z = ht + wall;

screw_d = 3.9;
head_d = 10;
head_h = 4;

module shroud()
{
    cylinder(d = id + wall, h = ht + wall);
}

module mount()
{
    translate([(id + wall)/2 - cube_x + 5, -cube_y / 2, 0])
        cube([cube_x, cube_y, cube_z]);
}

module hole()
{
    translate([0, 0, wall / 2 - 1])
        cylinder(d = id, h = ht + 4);
}

module screw_hole()
{
    translate([(id + wall)/2 - cube_x + 5, -cube_y / 2, 1])
        translate([-3, cube_y / 2, cube_z / 2])
            rotate([0, 90, 0])
                cylinder(d = screw_d, h = cube_x + 4);
}

module screw_cavity()
{
    translate([(id + wall)/2 - wall + 1.5, -cube_y / 2, 1])
        translate([0, cube_y / 2, cube_z / 2])
            rotate([0, 90, 0])
                cylinder(d = head_d, h = head_h);
}

module screw_cavity2()
{
    translate([-(id + wall)/2 - wall + 2.5, -cube_y / 2, 1])
        translate([0, cube_y / 2, cube_z / 2])
            rotate([0, 90, 0])
                cylinder(d = head_d - 4, h = head_h);
}

difference() {
    union() {
        shroud();
        mount();
    }
    hole();
    screw_hole();
    screw_cavity();
    screw_cavity2();
}