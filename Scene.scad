//w = 31.77;
//h = 7.9;

$fn = 50;

thickness_x = 2;
thickness_y = 0.4;
rounding_radius = 3;
spacing = 0.1;

hook_w = 10;
hook_h = 8;

airtag_w = 31.9;
airtag_h = 8;

distance = 0;

difference() {
    union() {
//        color("white") AirTag2D();
//        color("green") Case2D();
        color("white") AirTag();
        
        translate([0, 0, - distance / 2])
        color("green")
            Case_Half1(
                tx = thickness_x + spacing,
                ty = thickness_y + spacing,
                rr = rounding_radius,
                s = spacing,
                hw = hook_w, hh = hook_h);
                
        translate([0, 0, distance / 2])
        color("green")
            Case_Half2(
                tx = thickness_x + spacing,
                ty = thickness_y + spacing,
                rr = rounding_radius,
                s = spacing,
                hw = hook_w, hh = hook_h);
    }
    
    //translate([0, -30, -30]) cube(60);
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
        
        AirTag2D(part = 2, delta = s);
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

module Case(tx, ty, rr, s) {
    difference() {
        rotate_extrude(angle = 360)
            Case2D(tx = tx, ty = ty, rr = rr, s = s);
            
        linear_extrude(height = 10, convexity = 10)
            circle(d = 16);
            
        translate([0, 0, -10]) linear_extrude(height = 10, convexity = 10)
            scale(1.3) translate([0, -5, 0]) Key2D();
    }
}

module Hang(tx, ty, rr, s, hw, hh) {
    x = 0;
    y = - airtag_w / 2 - tx - hh / 2;
    z = 1 - 0.7415;
    rd = rr * 2 * 0 ;
    minkowski() {
        translate([x, y, z ])
            cube([hw - rd, hh - rd, airtag_h + ty * 2 - rd], center = true);
        sphere(rr);
    }
    
    /*translate([x, y, z ])
    linear_extrude(airtag_h + ty * 2, center = true)
    offset(r = -rr) offset(delta = rr)
    polygon([
        [-dx, hh / 2 + tx],
        [dx, hh / 2 + tx],
        [hw / 2, hh / 2],
        [hw / 2, 0],
        [-hw / 2, 0],
        [-hw / 2, hh / 2],
    ]);*/
}

module Hang2(tx, ty, rr, s, hw, hh) {
    rd = rr * 2;
    
    da = 360 / $fn;
    ang = round(35 / da) * da;
    dx = sin(ang) * (airtag_w / 2 + tx + rd);
    dy = cos(ang) * (airtag_w / 2 + tx + rd);
    dz = airtag_h / 2 + ty - 1 + 0.7415 - rr;
    
    #translate([-dx, -dy, -dz])
        rotate([0, 0, 0])
        rotate_extrude(angle = 90 - ang)
        //rotate_extrude()
            translate([rr * 3, 0, 0])
            circle(rr);
}

module Hang3(tx, ty, rr, s, hw, hh) {
    R = airtag_w / 2 + tx;
    rd = rr * 2;
    
    da = 360 / $fn;
    ang = round(35 / da) * da;
    dx = sin(ang) * R;
    dy = cos(ang) * R;
    dz = airtag_h / 2 + ty - 1 + 0.7415;
    
    minkowski() {
    linear_extrude(airtag_h + ty * 2)
    polygon([
        [-dx, -dy],
        [ dx, -dy],
        [  hw / 2, - R],
        [  hw / 2, - R - hh],
        [- hw / 2, - R - hh],
        [- hw / 2, - R],
    ]);
    sphere(rr);
    }
}


module Case_Half1(tx, ty, rr, s, hw, hh) {
    difference() {
        //hull()
        union()
        {
            Case(tx = tx, ty = ty, rr = rr, s = s);
            //translate([0, rr, 0]) 
            //Hang3(tx = tx, ty = ty, rr = rr, s = s, hw = hw, hh = hh);
        }
        
        translate([-100, -100, 0]) cube(200);
    }
    Hang3(tx = tx, ty = ty, rr = rr, s = s, hw = hw, hh = hh);
    rotate_extrude(angle = 360)
        translate([airtag_w / 2 + tx / 2, 0, 0]) square([0.8, 1.8], center = true);
}

module Case_Half2(tx, ty, rr, s, hw, hh) {
    difference() {
        Case(tx = tx, ty = ty, rr = rr, s = s);
        translate([-100, -100, -200]) cube(200);
        
        rotate_extrude(angle = 360)
            translate([airtag_w / 2 + tx / 2, 0, 0]) square([1, 2], center = true);
    }
    
}
