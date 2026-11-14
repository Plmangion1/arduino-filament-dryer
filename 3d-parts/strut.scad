// =========================================================
// STRUT — diagonal brace, PRINT 2 OFF
// Runs from the box's upper left/right standoff down to the
// eyelet tab at the catwalk's tip.
//
// Drawn flat in the XY plane for printing: lay it on the bed as
// modelled, no supports, no rotation needed.
//
// Hole-to-hole span is derived from the box and catwalk numbers
// below, so if either part changes, update them here to match.
// =========================================================

$fn = 64;
eps = 0.01;

// --- Geometry it has to span (must match box.scad / catwalk.scad) ---
outer_y = 81.13;      // box.scad
so_y    = outer_y - 12.0;   // standoff height on the box
so_z    = 10.0;             // standoff position along the tube axis

pad_t   = 6.0;        // box.scad
plate_t = 9.0;        // catwalk.scad
arm_len = 158.0;      // catwalk.scad
plate_ymid = -pad_t - plate_t / 2;
eye_z   = -(arm_len - 9.0);

// --- Strap ---
strap_w = 14.0;       // width
strap_t = 5.0;        // thickness
strap_end = 9.0;      // material beyond each hole centre
hole_d  = 3.4;        // M3 clearance

span = sqrt(pow(plate_ymid - so_y, 2) + pow(eye_z - so_z, 2));

echo("hole-to-hole span", span);
echo("strap overall length", span + strap_end * 2);
echo("bed check: needs <= 200mm on the long axis");

module strap() {
    difference() {
        hull() {
            cylinder(h = strap_t, d = strap_w);
            translate([span, 0, 0]) cylinder(h = strap_t, d = strap_w);
        }
        translate([0, 0, -eps]) cylinder(h = strap_t + eps * 2, d = hole_d);
        translate([span, 0, -eps]) cylinder(h = strap_t + eps * 2, d = hole_d);
    }
}

strap();
