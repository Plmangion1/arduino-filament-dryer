// =========================================================
// BOX — tier 3 sleeve
// Open tube, two open ends, no floor and no cap.
//   Z = depth -> LIP end (10mm rim, 4 x O3.82 bolt holes)
//   Z = 0     -> plain open end; the catwalk mounts here
//
// In use the tube axis (Z) lies HORIZONTAL, the lip stands
// vertical at the far end, the catwalk runs flat out of the
// Z = 0 end along the bottom face (Y = 0), and the two struts
// bolt to the standoffs on the upper left/right outside faces.
//
// Print: stand it on the Z = 0 end, lip up. No supports needed.
// =========================================================

$fn = 64;
eps = 0.01;

// --- Tier 3 stack it must swallow ---
tier3_x = 97.22;
tier3_y = 75.13;

// --- Fit ---
clearance = 2.0;      // total, 1mm per side
wall      = 2.0;
depth     = 28.0;     // hard cap

// --- Lip ---
lip_overhang = 10.0;
lip_height   = 3.0;
lip_bolt_d   = 3.82;

// --- Derived ---
inner_x = tier3_x + clearance;       //  99.22
inner_y = tier3_y + clearance;       //  77.13
outer_x = inner_x + wall * 2;        // 103.22
outer_y = inner_y + wall * 2;        //  81.13
lip_x   = outer_x + lip_overhang * 2;
lip_y   = outer_y + lip_overhang * 2;
bolt_ring = lip_overhang / 2;

// --- Catwalk mounting pads (outside the bottom face, Y = 0) ---
pad_t     = 6.0;
pad_w     = 18.0;
pad_len   = 22.0;
pad_x     = [14.0, outer_x - 14.0];
pad_pilot = 3.2;
mount_z   = [7.0, 17.0];

// --- Strut standoffs (upper left & right, outside the side walls) ---
so_d    = 13.0;
so_out  = 6.0;
so_hole = 3.4;
so_y    = outer_y - 12.0;
so_z    = 10.0;

echo("cavity", inner_x, inner_y);
echo("outer", outer_x, outer_y, depth);
echo("lip footprint", lip_x, lip_y);

module tube() {
    cube([outer_x, outer_y, depth]);
}

module lip_plate() {
    translate([-lip_overhang, -lip_overhang, depth])
        cube([lip_x, lip_y, lip_height]);
}

// One continuous opening through the tube AND the lip
module cavity() {
    translate([wall, wall, -eps])
        cube([inner_x, inner_y, depth + lip_height + eps * 2]);
}

module lip_bolt_holes() {
    for (x = [-lip_overhang + bolt_ring, outer_x + lip_overhang - bolt_ring])
        for (y = [-lip_overhang + bolt_ring, outer_y + lip_overhang - bolt_ring])
            translate([x, y, depth - eps])
                cylinder(h = lip_height + eps * 2, d = lip_bolt_d);
}

// Pads hang off the OUTSIDE of the bottom face at the no-lip end,
// so the bottom opening stays completely clear.
module catwalk_pads() {
    for (x = pad_x)
        translate([x - pad_w / 2, -pad_t, 0])
            cube([pad_w, pad_t + wall, pad_len]);
}

module catwalk_pilots() {
    for (x = pad_x)
        for (z = mount_z)
            translate([x, -pad_t - eps, z])
                rotate([-90, 0, 0])
                cylinder(h = pad_t + wall + eps * 2, d = pad_pilot);
}

module strut_standoffs() {
    translate([wall, so_y, so_z]) rotate([0, -90, 0])
        cylinder(h = so_out + wall, d = so_d);
    translate([outer_x - wall, so_y, so_z]) rotate([0, 90, 0])
        cylinder(h = so_out + wall, d = so_d);
}

module strut_standoff_holes() {
    translate([-so_out - eps, so_y, so_z]) rotate([0, 90, 0])
        cylinder(h = so_out + wall * 2 + eps * 2, d = so_hole);
    translate([outer_x - wall - eps, so_y, so_z]) rotate([0, 90, 0])
        cylinder(h = so_out + wall * 2 + eps * 2, d = so_hole);
}

difference() {
    union() {
        tube();
        lip_plate();
        catwalk_pads();
        strut_standoffs();
    }
    cavity();
    lip_bolt_holes();
    catwalk_pilots();
    strut_standoff_holes();
}
