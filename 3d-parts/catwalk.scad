// =========================================================
// CATWALK — heatsink plate
// A FLAT PLATE. No vertical flange. It lies in the plane of the
// box's bottom face, laps under the box's two mounting pads at
// the no-lip end, and cantilevers straight out along the tube
// axis, away from the lip. Eyelet tabs at the tip take the struts.
//
// Frame matches box.scad:
//   X  0..103.22   box width
//   Y  plate thickness direction; the plate's top face meets the
//      underside of the box pads
//   Z  tube axis. Z = 0 is the box's open end; the arm runs -Z.
//
// Plate is 180mm total so the struts stay inside the 200mm bed.
// Print: flat on its face. No supports needed.
// =========================================================

$fn = 64;
eps = 0.01;

// --- Must match box.scad ---
outer_x = 103.22;
pad_t   = 6.0;
pad_len = 22.0;
pad_x   = [14.0, outer_x - 14.0];
mount_z = [7.0, 17.0];
mount_hole_d = 3.4;      // M3 clearance -> box's 3.2 pilot

// --- Plate ---
plate_t = 9.0;
arm_len = 158.0;         // cantilever past the box
lap_len = pad_len;       // overlap under the pads
                         // total plate length = 180.0

plate_y0   = -pad_t - plate_t;        // bottom face
plate_ymid = plate_y0 + plate_t / 2;

// --- Heatsink footprint ---
hs_x       = 61.20;
hs_y       = 60.48;
hole_inset = 7.0;
hole_d     = 6.0;        // oversized so a real heatsink can be found
hs_near    = 88.0;       // near edge, measured out from the box

// --- Strut eyelet tabs at the tip ---
tab_out  = 6.0;
tab_w    = 16.0;
tab_hole = 3.4;
eye_z    = -(arm_len - 9.0);

// --- Cable channel (underside snap-fit, prints without support) ---
channel_w = 10.0;
channel_h = 6.0;
throat_w  = 7.0;
throat_h  = 1.5;
chan_z0   = 8.0;
chan_z1   = hs_near - 5.0;
chan_len  = chan_z1 - chan_z0;

echo("plate total length", lap_len + arm_len);
echo("heatsink far hole at", -hs_near - (hs_y - hole_inset));
echo("material past far hs hole", arm_len - (hs_near + hs_y - hole_inset) - hole_d / 2);

module plate() {
    translate([0, plate_y0, -arm_len])
        cube([outer_x, plate_t, arm_len + lap_len]);
}

module eyelet_tabs() {
    translate([-tab_out, plate_y0, eye_z - tab_w / 2])
        cube([tab_out, plate_t, tab_w]);
    translate([outer_x, plate_y0, eye_z - tab_w / 2])
        cube([tab_out, plate_t, tab_w]);
}

module eyelet_holes() {
    translate([-tab_out - eps, plate_ymid, eye_z]) rotate([0, 90, 0])
        cylinder(h = tab_out + eps * 2, d = tab_hole);
    translate([outer_x - eps, plate_ymid, eye_z]) rotate([0, 90, 0])
        cylinder(h = tab_out + eps * 2, d = tab_hole);
}

// Clearance holes, up through the plate into the box pads
module mount_holes() {
    for (x = pad_x)
        for (z = mount_z)
            translate([x, plate_y0 - eps, z]) rotate([-90, 0, 0])
                cylinder(h = plate_t + eps * 2, d = mount_hole_d);
}

module heatsink_holes() {
    for (hx = [hole_inset, hs_x - hole_inset])
        for (hy = [hole_inset, hs_y - hole_inset])
            translate([outer_x / 2 - hs_x / 2 + hx, plate_y0 - eps, -hs_near - hy])
                rotate([-90, 0, 0])
                cylinder(h = plate_t + eps * 2, d = hole_d);
}

// Channel opens on the plate's underside; the narrow throat snaps
// the cable in, the wider pocket above holds it.
module cable_channel() {
    translate([outer_x / 2 - throat_w / 2, plate_y0 - eps, -chan_z1])
        cube([throat_w, throat_h + eps, chan_len]);
    translate([outer_x / 2 - channel_w / 2, plate_y0 + throat_h, -chan_z1])
        cube([channel_w, channel_h, chan_len]);
}

difference() {
    union() {
        plate();
        eyelet_tabs();
    }
    mount_holes();
    heatsink_holes();
    cable_channel();
    eyelet_holes();
}
