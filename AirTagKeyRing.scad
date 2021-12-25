/*
 * AirTagKeyRing.
 *
 * Copyright 2021 Abdeslam MOKRANI - mokabdes-dev@yahoo.com
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * See <http://www.gnu.org/licenses/>.
 *
 */

// Number of fragments
fn = 50; // [10:1:360]

// Space between the two halves of the case and the AirTag
spacing = 0.2; // [0.1:0.1:1]

/* [Components] */

model = 0; // [0: Logo case, 1: Label case, 2: Closed case, 3: Open case, 4: Closed case section]

// Engraving on the metallic face (Apple logo)
logo = -1; // [-1: None, 0:Circle, 1:Key, 2: Car]

// Engraving on the white face
label = -1; // [-1: None, 0:Circle, 1:Key, 2: Car, 3: Bag]

engraving_depth = 0.2;  // [0.1:0.1:10]

engraving_side = 0;  // [0: Outside, 1: Inside <for transparent material>]

// Used to generate 2D projection images (use orthogonal Top view)
projection = "NONE"; // ["NONE", "DEFAULT", "FRONT", "BACK", "TOP", "BOTTOM", "LEFT", "RIGHT"]

/* [Case] */

thickness_x = 2; // [0:0.1:10]
thickness_y = 1; // [0:0.1:10]
rounding_radius = 5; // [0:0.1:10]

tenon_width = 0.8; // [0.2:0.1:1.4]

/* [Hook] */

add_hook = true;
hook_w = 12; // [0:1:24]
hook_h = 4; // [0:1:10]
hook_hole_d = 5; // [1:0.1:10]
hook_ring_d = 30; // [10:1:50]
hook_ring_orientation = 0; // [0: Coplanar, 1: Perpendicular]

/* [AirTag dimensions ] */

airtag_w = 31.9;
airtag_h = 8;

$fn = fn;

Projection(projection) {
    if (model == 0) {
        translate([0, 0, airtag_h / 2 + thickness_y + spacing + 1 - 0.7415])
            rotate([0, 180, 0])
                Logo();
    }
    else if (model == 1) {
        translate([0, 0, airtag_h / 2 + thickness_y + spacing - 1 + 0.7415])
            Label();
    }
    else if (model == 2) {
        LogoAndLabel(opening = 0.05);
    }
    else if (model == 3) {
        LogoAndLabel(opening = 12);
    }
    else if (model == 4) {
        difference() {
            LogoAndLabel(opening = 0.05);
            translate([0, -100, -100]) cube(200);
        }
    }
}

module projection(angle, label) {
    if (label != "DEFAULT")
    translate([-20, 35])
    text(label, font = "Menlo", size = 8);

    rotate(angle)
    children();
}

module Projection(projection) {
    if (projection == "NONE") {
        rotate([0, 0, 0])
        translate([0, 0, 0])
        children();
    }
    else {
        angles = [
            ["DEFAULT", [-70, 30, 0]],
            ["FRONT", [-90, 0, 0]], ["BACK", [90, 0, 180]],
            ["TOP", [0, 0, 0]], ["BOTTOM", [180, 0, 0]],
            ["LEFT", [-90, 90, 0]], ["RIGHT", [-90, -90, 0]]
        ];
        
        projection(angles[search([projection], angles)[0]][1], projection) children();
    }
}

module Logo() {
    Case_Logo(
        tx = max(thickness_x, (tenon_width * 2 + spacing) * 2) + spacing,
        ty = thickness_y + spacing,
        rr = min(rounding_radius, airtag_h / 2 + thickness_y + spacing - 0.1),
        tw = tenon_width,
        s = spacing,
        ah = add_hook, hw = hook_w, hh = hook_h, hhd = hook_hole_d, hrd = hook_ring_d, hro = hook_ring_orientation,
        lg = logo, ed = engraving_depth, es = engraving_side);
}

module Label() {
    Case_Label(
        tx = max(thickness_x, (tenon_width * 2 + spacing) * 2) + spacing,
        ty = thickness_y + spacing,
        rr = min(rounding_radius, airtag_h / 2 + thickness_y + spacing - 0.1),
        tw = tenon_width,
        s = spacing,
        ah = add_hook, hw = hook_w, hh = hook_h, hhd = hook_hole_d, hrd = hook_ring_d, hro = hook_ring_orientation,
        ll = label, ed = engraving_depth, es = engraving_side);
}

module LogoAndLabel(opening = 0) {
    color("white") AirTag();
    
    translate([0, 0, - opening / 2])
    color("#aaaaaa") Label();
    
    translate([0, 0, opening / 2])
    color("#aaaaaa") Logo();
}

module AirTag2D(part = 1, delta = 0) {
    polygon([
        for(a = [-90 : 360 / $fn : 0])
            [cos(a) ^ ((abs(a) + 38) / 128) * (airtag_w / 2 + delta), sin(a) * (3.7415 + delta)],
        for(a = [0.17 : 360 / $fn : 33.17])
            [cos(a) ^ ((abs(a) + 38) / 128) * (airtag_w / 2 + delta), sin(a) * (3.768 + delta)],
        if (part == 2) [12.83 + delta, sin(33.17) * (3.768 + delta)],
        if (part == 1) [11.64, sin(33.17) * (3.768 + delta)],
        if (part == 1) [11.64, 2.5],
        if (part == 1) [12.83, 2.5],
        if (part != 3) [12.83 + delta, sin(49) * (3.768 + delta) + 0.575],
        for(a = [50.5 : 360 / $fn : 77.5])
            [cos(a) ^ ((abs(a) + 38) / 128) * (airtag_w / 2 + delta) + 1, sin(a) * (3.768 + delta) + 0.575],
        [0, airtag_h - 3.7415 + delta],
    ]);
}

module AirTag() {
    rotate_extrude(angle = 360)
        AirTag2D();
}


module Case2D(tx, ty, rr, s) {
    difference() {
        translate([0, - airtag_h / 2 - ty + 1 - 0.7415, 0]) {
            offset(r = rr) offset(delta = -rr) square([ airtag_w / 2 + tx, airtag_h + ty * 2]);
            square([rr, airtag_h + ty * 2]);
        }
    }
}

module Key2D(details = true) {
    translate([0, -5, 0]) {
        difference() {
            circle(d = 10);
            if (details) translate([0, -2.5, 0]) circle(d = 2.5);
        }
        
        for (a = [0 : 90 : 0 /*270*/])
            rotate([0, 0, a]) translate([0, 3, 0])
                polygon([
                    [-2, 0], [2, 0], [2, 5], [1, 6], [2, 7], [1, 8], [2, 9], [0, 12], [-2, 11]
                ]);
    }
}

module Car2D(details = true) {
    translate([0, 1])
    difference() {
        union() {
            translate([0, -2])
            difference() {
                offset(r = 3) square([6, 5], center = true);
                if (details) offset(r = 2) square([5.8, 4.8], center = true);
            }
            offset(r = 3) square([9, 1], center = true);
            translate([-6, 3])
                offset(r = 1) square([0.5, 3], center = true);
            translate([6, 3])
                offset(r = 1) square([0.5, 3], center = true);
        }
        if (details) {
            offset(r = 0.5) square([6, 1], center = true);
            translate([-5, 0]) circle(r = 1);
            translate([5, 0]) circle(r = 1);
        }
    }
}

module Bag2D(details = true) {
    translate([0, 1])
    difference() {
        union() {
            translate([0, -4])
            difference() {
                offset(r = 3) square([2, 5], center = true);
                if (details) offset(r = 2) square([2, 4.8], center = true);
            }
            offset(r = 3) polygon([[-4, -4], [4, -4], [5, 4], [-5, 4]]);
        }
        if (details) {
            translate([0, 1]) difference() {
                offset(r = 2) square([8, 4], center = true);
                translate([0, -1, 0]) square([12, 1], center = true);
                translate([4, 0, 0]) offset(r = 0.5) square([0.1, 1], center = true);
            }
        }
    }
}

module label(l, details) {
    if (l == 0) {
        circle(d = 16);
    }
    else if (l == 1) {
        Key2D(details);
    }
    else if (l == 2) {
        Car2D(details);
    }
    else if (l == 3) {
        Bag2D(details);
    }
}

module Case(tx, ty, rr, s, ah, hw, hh, hhd, hrd, hro, ll, lg, ed, es) {
    difference() {
        hull() {
            rotate_extrude(angle = 360)
                Case2D(tx = tx, ty = ty, rr = rr, s = s);
                
            if (ah) {
                rd = rr * 2;
                translate([0, - airtag_w / 2 - tx - hh / 2 - hhd / 2, 1 - 0.7415 ]) minkowski() {
                    cube([max(0.1, hw - rd), max(0.1, hh + hhd - rd), airtag_h + ty * 2 - rd], center = true);
                    sphere(rr);
                }
            }
        }
        
        rotate_extrude(angle = 360)
            AirTag2D(part = 2, delta = s);
            
        translate([0, 0, airtag_h / 2 + ty * (1 - es) + 1 - 0.7415 - ed * (1 - es) - ty * es])
        linear_extrude(height = ed + ty, convexity = 10) {
            label(lg, ed < ty - s);
        }
        
        translate([0, 0, - airtag_h / 2 - ty * (1 - es) + 1 - 0.7415 - ed * es - ty * (1 - es)])
        linear_extrude(height = ed + ty, convexity = 10) {
            label(ll, ed < ty - s);
        }
        
        if (ah) {
            translate([0,  - hrd / 2 - airtag_w / 2 - tx - hhd / 2 - 1, 1 - 0.7415]) rotate([0, hro * 90, 0])
                rotate_extrude(angle = 360)
                    translate([hrd / 2, 0, 0])
                        circle(d = hhd);
        }
    }
}

module Case_Logo(tx, ty, rr, tw, s, ah, hw, hh, hhd, hrd, hro, lg, ed, es) {
    difference() {
        Case(tx = tx, ty = ty, rr = rr, s = s, ah = ah, hw = hw, hh = hh, hhd = hhd, hrd = hrd, hro = hro, ll = -1, lg = lg, ed = ed, es = es);
        
        w = airtag_w + tx * 2 + hro * (hh + hhd + 1) * 2;
        translate([- w / 2, - w / 2, -w]) cube(w);
        
        if (ah && hro == 0) {
            translate([- w + s / 2, - w - w / 2 + s / 2, - w / 2]) cube(w);
        }
        
        rotate_extrude(angle = 360)
            translate([airtag_w / 2 + tx / 2, 0, 0]) square([tw + s, (tw + s) * 2], center = true);
    }
    
}

module Case_Label(tx, ty, rr, tw, s, ah, hw, hh, hhd, hrd, hro, ll, ed, es) {
    difference() {
        Case(tx = tx, ty = ty, rr = rr, s = s, ah = ah, hw = hw, hh = hh, hhd = hhd, hrd = hrd, hro = hro, ll = ll, lg = -1, ed = ed, es = es);
        
        w = airtag_w + tx * 2 + hro * (hh + hhd + 1) * 2;
        translate([- w / 2, - w / 2, 0]) cube(w);
        
        if (ah && hro == 0) {
            translate([- s / 2, - w - w / 2 + s / 2, - w / 2]) cube(w);
        }
    }

    rotate_extrude(angle = 360)
        translate([airtag_w / 2 + tx / 2, 0, 0]) square([tw, tw * 2], center = true);
}
