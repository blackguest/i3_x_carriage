// PRUSA iteration3
// X carriage
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

include <../configuration.scad>
use <inc/bearing.scad>

module x_carriage_base() {
  // Small bearing holder
  translate([-33/2,+2,0]) rotate([0,0,90]) horizontal_bearing_base(1);
  hull() {
    // Long bearing holder
    translate([-33/2,x_rod_distance+2,0]) rotate([0,0,90]) horizontal_bearing_base(2);
    // Belt holder base
    translate([-36,20,0]) cube([39,16,17]);
  }
  // Base plate
  translate([-38,-11.5,0]) cube([39+4,68,7+1.5]);
}

module x_carriage_beltcut(){
  position_tweak = -0.3;
  // Cut in the middle for belt
  /// slightly wider, and deeper cut
  ///translate([-2.5-16.5+1,19,7]) cube([4.5,13,15]);
  between_belt_ends_width = 5.5;
  translate([-between_belt_ends_width/2-16.5,20,6]) cube([between_belt_ends_width,12,15]);
  // extra angle cutout for end loop of belt
  //translate([-16.5-between_belt_ends_width/2,19,6])
  translate([-16.5,20,8.5+0.01])
    difference(){
     cylinder(r=between_belt_ends_width, h=15, $fn=6);
     translate([-between_belt_ends_width,-between_belt_ends_width-0.01,-1])
         cube([between_belt_ends_width*2, between_belt_ends_width, 18]);
    }

  // Cut clearing space for the belt
  translate([-39,5,7]) cube([50,13,15]);
  // Belt slit
  // 10% wider belt gap
  ////translate([-50,21.5+10,6]) cube([67,1,15]);
  translate([-50,21.5+10,6]) cube([67,1.10,15]);
  // Smooth entrance
  translate([-56,21.5+10,14]) rotate([45,0,0]) cube([67,15,15]);
  // Teeth cuts
  for (i=[2:25])
    /// slightly deeper teeth cuts
    ///translate([10-i*belt_tooth_distance+position_tweak,21.5+8.75,6.5]) cube([1.25,2,15]);
    translate([10-i*belt_tooth_distance+position_tweak,21.25+8.75,6.5]) cube([1.25,2,15]);
  /// extra belt teeth end cutouts
  translate([10-belt_tooth_distance+position_tweak,21.25+8.75,6.5]) cube([5.25,2,15]);
  translate([10-28*belt_tooth_distance+position_tweak,21.25+8.75,6.5]) cube([5.25,2,15]);
}

module x_carriage_holes(){
  // Small bearing holder holes cutter
  translate([-33/2,2,0]) rotate([0,0,90]) horizontal_bearing_holes(1);
  // Long bearing holder holes cutter
  translate([-33/2,x_rod_distance+2,0]) rotate([0,0,90]) horizontal_bearing_holes(2);

  // Extruder mounting holes
  // Inner holes
  center_x=-16.5;
  max_width=31;
  min_width=19.5;
  slot_width=(max_width-min_width)/2;
  r_offset = center_x + min_width/2;
  l_offset = center_x - min_width/2;
  cut_steps=4;
  offset=slot_width/cut_steps;
  for(v=[[-1,1.7,32],[10,3.2,6]])
    for(i=[0:cut_steps]){
      translate([r_offset + i*offset, 24.5,v[0]]) cylinder(r=v[1], h=20, $fn=v[2]);
      translate([l_offset - i*offset, 24.5,v[0]]) cylinder(r=v[1], h=20, $fn=v[2]);
    }
}

module x_carriage_fancy(){
 // Top right corner
 translate([13.5,-5,0]) translate([0,45+11.5,-1]) rotate([0,0,45]) translate([0,-15,0]) cube([30,30,20]);
 // Bottom right corner
 translate([0,5,0]) translate([0,-11.5,-1]) rotate([0,0,-45]) translate([0,-15,0]) cube([30,30,20]);
 // Bottom ĺeft corner
 translate([-33,5,0]) translate([0,-11.5,-1]) rotate([0,0,-135]) translate([0,-15,0]) cube([30,30,20]);
 // Top left corner
 translate([-33-13.5,-5,0]) translate([0,45+11.5,-1]) rotate([0,0,135]) translate([0,-15,0]) cube([30,30,20]);
}

module x_carriage_addons(xoffset, yoffset){
    difference(){
        translate([0,0,1]) {
            translate([-16.5+xoffset,-yoffset,-1]) cylinder(r=1.7+2, h=8.5, $fn=32);
            translate([-16.5-xoffset,-yoffset,-1]) cylinder(r=1.7+2, h=8.5, $fn=32);
        }
      translate([-16.5+xoffset,-yoffset,-1]) cylinder(r=1.7, h=20, $fn=32, center=true);
      translate([-16.5-xoffset,-yoffset,-1]) cylinder(r=1.7, h=20, $fn=32, center=true);
    }
}

module x_carriage(){
  difference(){
    x_carriage_base();
    x_carriage_beltcut();
    x_carriage_holes();
    x_carriage_fancy();
    }
}

// Two extra mounting holes
addon_offsets=20.0;
// Final part
union(){
 x_carriage();
 x_carriage_addons(addon_offsets, 5);
 x_carriage_addons(addon_offsets/2, 13);
}

