// Copyright (C) 2020, Vishal Verma
// SPDX-License-Identifier: GPL-2.0-only

$fn=100;

len = 155;
hbase = 102;
htop = 60;
wall = 2;
box_y = 32 + wall;
wid = 84 - box_y;
radius = 10;
part1 = 50;
lpart = 64;
ant_d = 18;
mid_cut_r = 40;

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
        // lower and upper main boxes
        curve_box(len, wid, htot, radius, wall);
        translate([len, wall, hbase])
            rotate([0, 0, 180])
                curve_box(len, box_y, htop, 1, wall);
        
        // upper main partition
        translate([lpart, -box_y + wall, hbase])
            cube([wall, box_y - wall, htop]);
        
        // upper antenna x partition
        translate([lpart, -box_y + ant_d + 2 * wall, hbase])
            cube([len - lpart - ant_d - ant_d + 3 * wall, wall, htop]);
        
        // upper antenna y partitions
        for ( i = [1 : 3] ){
            if (i == 3) {
                translate([lpart + ((wall + ant_d) * i), -box_y + wall, hbase])
                    cube([wall, box_y - wall, htop]);
            } else {
                translate([lpart + ((wall + ant_d) * i), -box_y + wall, hbase])
                    cube([wall, box_y + 2 * wall - ant_d, htop]);
            }
        }
        
        // lower main partition
        translate([lpart, 0, 0])
            cube([wall, wid, htot]);
    }
    
    // angle cut radio side
    translate([-1, wall, htot])
        rotate([-70, 0, 0])
            cube([lpart + 1, len+100, len]);
    
    // angle cut mic side
    translate([lpart - 1, wall, htot])
        rotate([-45, 0, 0])
            cube([len - lpart + 2, len+100, len]);
}