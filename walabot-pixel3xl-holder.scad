// Copyright (C) 2020, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

// phone dimensions
// Typically only these should need to be adjusted based on phone
p_wid=83;
p_ht=158;
p_radius=6.7;

// common dimensions
$fn=100;
shell=2;
container_extra_wid=18;
grip_r=50;
grip_d=5;
top_cutout_r=20;

// walabot dimensions
w_radius=6.5;
w_wid=83;
w_ht=145;
w_gel_pad=0;
w_base_depth=19;
w_back_pocket_w=62;
w_back_zpos = 70;

// cable holes
c_wid=14;
c_radius=3.5;

// computed dimensions
w_depth = w_base_depth + w_gel_pad;
w_back_extra = w_depth - (2 * w_radius);
p_depth = 2 * p_radius;
f_ht = max(w_ht, p_ht);
f_wid = max(w_wid, p_wid);
container_total_wid=f_wid + container_extra_wid;
c_ht=shell+2;
f_depth = w_depth + p_depth + (3 * shell);
w_ht_diff = f_ht - w_ht;
p_ht_diff = f_ht - p_ht;


module rounded_body(r, w, h, center=false)
{
    y_off = center ? 0 : r;

    hull() {
        translate([-w/2 + r, y_off, 0]) cylinder(r=r, h=h);
        translate([w/2 - r, y_off, 0]) cylinder(r=r, h=h);
    }
}

module cable_hole(extra=0)
{
	rounded_body(c_radius, c_wid, c_ht + extra, center=true);
}

module top_cutout()
{
	rotate([90, 0, 0])
		rounded_body(top_cutout_r, w_back_pocket_w, shell + 2, center=true);
}

module bot_slot()
{
	hull() {
		translate([-w_back_pocket_w/2, 0, f_ht])
			cube([w_back_pocket_w, w_back_extra + 1, 1]);
		translate([0, w_back_extra + 1, w_back_zpos + w_ht_diff])
			rotate([90, 0, 0])
				cylinder(r=w_back_pocket_w/2, h=w_back_extra + 1);
	}
}

module bot()
{
	translate([0, w_back_extra, w_ht_diff])
		rounded_body(w_radius, w_wid, w_ht+1);
	bot_slot();
    translate([0, w_back_extra + w_radius, -c_ht+1])
        cable_hole(w_ht_diff);
    
}

module phone()
{
    translate([0, 0, p_ht_diff])
        rounded_body(p_radius, p_wid, p_ht+1);
    translate([0, p_depth/2 - 0.5, -c_ht+1])
        cable_hole(p_ht_diff);
}

module main_shell()
{
    h = f_ht + shell;
    w = container_total_wid;
    d = f_depth;
    r = d/2;
    
    rounded_body(r, w, h, center = true);
}

module grips()
{
	for (i = [1:2:3]) {
		for (j = [-1:2:1]) {
			x_off = (container_total_wid/2 + grip_r - grip_d);
			y_off = (w_back_extra)/2;
			z_off = f_ht/4;

			translate([j * x_off, y_off, i * z_off])
				sphere(grip_r);
		}
	}
}

module final()
{
	difference() {
		translate([0, (w_back_extra)/2, 0]) main_shell();
		translate([0, shell/2, shell]) bot();
		translate([0, -(shell/2 + p_depth), shell]) phone();
		translate([-container_total_wid/2, -(2 * shell + p_depth + 0.5), -1])
			cube([container_total_wid, shell + 2, f_ht + shell + 2]);
		translate([-container_total_wid/2, w_depth, -1])
			cube([container_total_wid, shell + 2, f_ht + shell + 2]);
		grips();
		translate([0, shell/2 + 1, f_ht + shell])
			top_cutout();
	}
}

final();
