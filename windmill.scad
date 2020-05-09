// Copyright (C) 2020, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

$fn = 100;

blade_r = 2;
blade_len = 80;
shaft = 7;
motor_len = 25;
motor_r = 8;
base_wid = 30;
base_h = 5;

pole_h = 2 * blade_len + 20;
pole_base_r = motor_r;
pole_top_r = motor_r/2;
cap_r = motor_r;

module blade(r, len)
{
	rotate([180, 0, -10])
		translate([0, 0, -len])
			hull() {
				cylinder(r1=0.5, r2=r, h=len);
				translate([0, 0, 0])
					rotate([0, 10, 0])
						cylinder(r=0.5, h=len - 20);
			}
}

module triblade()
{
	rotate([0, 0, 0])
		blade(r=blade_r, len=blade_len);
	rotate([0, 120, 0])
		blade(r=blade_r, len=blade_len);
	rotate([0, 240, 0])
		blade(r=blade_r, len=blade_len);
}

module blade_ring()
{
	difference() {
		union() {
			triblade();
			rotate([90, 90, 0])
				translate([0, 0, -blade_r])
					cylinder(r = motor_r, h = 2 * blade_r);
		}
		rotate([90, 90, 0])
			translate([0, 0, -blade_r -1])
				cylinder(r = 2.25, h = 2 * blade_r + 2);
	}
}

module motor()
{
	hull() {
		cylinder(r = motor_r, h = 1);
		translate([0, 0, motor_len])
			sphere(6);
	}
	translate([0, 0, -shaft])
		cylinder(r = 2, h = motor_len - 5);
}

module cap(r)
{
	difference() {
		hull() {
			sphere(r);
			translate([0, 0.75 * r, 0])
				sphere(r/2);
		}
		translate([-r, -(2 * r), -r])
			cube(2*r);
		rotate([90, 0, 0])
			translate([0, 0, -0.5])
				cylinder(r = 2.2, h = 1.5);
	}
}

module pole()
{
	cylinder(r1 = pole_base_r, r2 = pole_top_r, h = pole_h);
}

module top_assy()
{
	translate([0, 3, 0])
		blade_ring();
	translate([0, 0, 0])
		rotate([90, 0, 0])
			motor();
	translate([0, shaft - 1, 0])
		cap(cap_r);
}

module base()
{
	translate([0, 0, base_h/2])
		cylinder(r1=base_wid, r2=base_wid-5, h=base_h, center=true);
}

module stand()
{
	pole();
	base();
}

module final()
{
    stand();
    translate([0, 8, pole_h])
        top_assy();
}

final();