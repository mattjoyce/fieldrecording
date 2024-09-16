$fn = $preview ? 0 : 150;
fragments = $preview ? 5 : 100;

// https://github.com/vsergeev/3d-simple-iso-thread
include <simple_iso_thread.scad>
epsilon=0.01;
e=epsilon;

//adjust this to suit you printer
thread_diameter=17.7;
td=thread_diameter;

internal_diameter=14;
id=internal_diameter;

outer_diameter=td+2;
od=outer_diameter;

thread_height=8;
th=thread_height;

//adjust this if you need a longer unit.
body_height=20;
bh=body_height;

cone_height=15;
ch=cone_height;

//adjust this to suit you printer
capsule_diameter=9.9;
cd=capsule_diameter;

capsule_height=6;

difference(){
  union(){
    cone();
    translate([0,0,ch-e])  body();
    translate([0,0,ch+bh-e]) thread();
  }
  if ($preview)  translate([0,0,-e]) cube([od,od,100]);
}
module thread(){
  difference(){
    simple_iso_thread(td, 1, th, type="external", chamfer_top=0.5, chamfer_bottom=0.0, fragments=fragments);
    
    //hollow
    translate([0,0,-e]) cylinder(h=100, d=id);
  }
}

module body(){
  difference(){
    //main cylinder, with hollow
    cylinder(h=bh, d=od);
    translate([0,0,-e]) cylinder(h=100, d=id);
  }

    //ring in centre to stop the XLR insert
  translate([0,0,bh-15]) difference(){
      cylinder(h=2, d=id);
      translate([0,0,-e]) cylinder(h=3, d1=id, d2=id-4);
  }

  
}

module cone(){
  difference(){
    union(){
      //main cone
      cylinder(h=ch,d1=12, d2=od);
      //ring
      difference(){
        cylinder(h=2, d=cd+5);  
        translate([0,0,-e]) cylinder(h=2, d=cd+2);  
      }
    }
    //capsule
    translate([0,0,-e]) cylinder(h=capsule_height,d=cd);
    
    slit_thickness=0.5;     
    translate([-slit_thickness/2,-od/2,0]) cube([0.5,od,6]);
    translate([-od/2,-slit_thickness/2,0]) cube([od,0.5,6]);
    
    //these stop the 1st layer merging
    translate([-od/2,0,0]) rotate([0,90,0]) cylinder(h=od, d=1);
    translate([0,od/2,0]) rotate([90,0,0]) cylinder(h=od, d=1);
    
    //cavity
    translate([0,0,7.5]) cylinder(h=cd, d=id); //main
    
    //capsule cone
    translate([0,0,6-e-e]) cylinder(h=2, d1=cd, d2=8);
  }
}