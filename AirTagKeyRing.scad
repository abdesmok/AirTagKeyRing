$fn = 100;

thickness_x = 2;
thickness_y = 1;
rounding_radius = 5;

tenon_width = 0.8;

spacing = 0.1;

hook_w = 12;
hook_h = 4;
hook_hole_d = 6;
hook_ring_d = 38;

airtag_w = 31.9;
airtag_h = 8;

distance = 0.1;

difference() {
    union() {
        color("white") AirTag();
        
        translate([0, 0, - distance / 2])
        color("green")
            Case_Half1(
                tx = max(thickness_x, (tenon_width + spacing) * 2) + spacing,
                ty = thickness_y + spacing,
                rr = rounding_radius,
                tw = tenon_width,
                s = spacing,
                hw = hook_w, hh = hook_h, hhd = hook_hole_d, hrd = hook_ring_d);
                
        translate([0, 0, distance / 2])
        color("green")
            Case_Half2(
                tx = max(thickness_x, (tenon_width + spacing) * 2) + spacing,
                ty = thickness_y + spacing,
                rr = rounding_radius,
                tw = tenon_width,
                s = spacing,
                hw = hook_w, hh = hook_h, hhd = hook_hole_d, hrd = hook_ring_d);
    }
    
    translate([0, -30, -30]) cube(60);
}


difference() {
    union() {
        //rotate([-90,0,0]) translate([-16,-4.3,-16]) color("#ffffff") import("apple-airtag-2.snapshot.2/Apple AirTag.STL");
        //translate([129.9,-30.7,5.28]) rotate([180,0,0]) color("#00ff00") import("Apple_AirTag_V2.stl");

        //color("#ffff00") import("Apple+AirTag+Case+vault/files/AT_LooseVault_RebelFacePlate.stl");
        //color("#ffff00") import("Apple+AirTag+Case+vault/files/AirTag_LooseVault_NamePlate.stl");
    }
    
    //cube(32);
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
            difference() {
                offset(r = rr) offset(delta = -rr) square([ airtag_w / 2 + tx, airtag_h + ty * 2]);
                translate([ - tx, - ty, 0]) square([tx, airtag_h + 2 * ty]);
            }
        }
    }
}

module Key2D() {
    circle(d = 10);
    
    for (a = [0 : 90 : 0 /*270*/])
        rotate([0, 0, a]) translate([0, 3, 0])
            polygon([
                [-2, 0], [2, 0], [2, 5], [1, 6], [2, 7], [1, 8], [2, 9], [0, 12], [-2, 11]
            ]);
}

module Case(tx, ty, rr, s, hw, hh, hhd, hrd) {
    difference() {
        hull() {
            rotate_extrude(angle = 360)
                Case2D(tx = tx, ty = ty, rr = rr, s = s);
            
            rd = rr * 2;
            translate([0, - airtag_w / 2 - tx - hh / 2 - hhd / 2, 1 - 0.7415 ]) minkowski() {
                cube([hw - rd, hh + hhd - rd, airtag_h + ty * 2 - rd], center = true);
                sphere(rr);
            }
        }
        
        rotate_extrude(angle = 360)
            AirTag2D(part = 2, delta = s);
            
        linear_extrude(height = 10, convexity = 10)
            circle(d = 16);
            
        translate([0, 0, -10]) linear_extrude(height = 10, convexity = 10)
            scale(1.3) translate([0, -5, 0]) Key2D();
            
        translate([0,  - hrd / 2 - airtag_w / 2 - tx - hhd / 2, 0])
            rotate_extrude(angle = 360)
                translate([hrd / 2, 0, 0])
                    circle(d = hhd);
    }
}

module Case_Half1(tx, ty, rr, tw, s, hw, hh, hhd, hrd) {
    difference() {
        Case(tx = tx, ty = ty, rr = rr, s = s, hw = hw, hh = hh, hhd = hhd, hrd = hrd);
        
        w = airtag_w + tx * 2;
        translate([- w / 2, - w / 2, 0]) cube(w);
        
        translate([- s / 2, - w - w / 2 + s / 2, - w / 2]) cube(w);
    }

    rotate_extrude(angle = 360)
        translate([airtag_w / 2 + tx / 2, 0, 0]) square([tw, tw * 2], center = true);
}

module Case_Half2(tx, ty, rr, tw, s, hw, hh, hhd, hrd) {
    difference() {
        Case(tx = tx, ty = ty, rr = rr, s = s, hw = hw, hh = hh, hhd = hhd, hrd = hrd);
        
        w = airtag_w + tx * 2;
        translate([- w / 2, - w / 2, -w]) cube(w);
        
        translate([- w + s / 2, - w - w / 2 + s / 2, - w / 2]) cube(w);
        
        rotate_extrude(angle = 360)
            translate([airtag_w / 2 + tx / 2, 0, 0]) square([tw + s, (tw + s) * 2], center = true);
    }
    
}