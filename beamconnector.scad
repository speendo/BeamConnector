// Beamconnector
$fn = 200;

beamADiameter = 40;
beamBDiameter = 30;

widthA = 20;
widthB = 8;

screwDiameter = 5;

thickness = 5;

offset = 2;

// Part A
//   Top Part

color("red") {
  difference() {
    ringPart(beamADiameter, widthA, thickness, 180);
    translate([0,0,-1]) {
      linear_extrude(height=(widthA + offset)/2 + 1) {
        polygon(points=[
          [-(beamADiameter/2 + 1.5 * thickness + offset),-1],
          [-(beamADiameter/2 + 1.5 * thickness + offset),thickness + offset],
          [-(beamADiameter/2 + thickness),thickness + offset],
          [-(beamADiameter/2),offset],
          [-(beamADiameter/2) + 1,offset],
          [-(beamADiameter/2) + 1,-1],
          [-(beamADiameter/2),-1]
        ]);
      }
    }
  }
  translate([0,beamADiameter/2 + thickness,0]) {
    screwPart(beamADiameter, widthA, beamADiameter/2 + thickness, thickness);
  }
  difference() {
    cube([beamADiameter/2 + thickness, beamADiameter/2 + thickness, widthA]);
    translate([0, 0, -1]) {
      cylinder(d=beamADiameter, h=widthA + 2);
    }
  }

  // connector
  rotate([0, 0, -angle(thickness, beamADiameter/2 + 1.5 * thickness)/2]) {
    translate([-(beamADiameter/2 + 1.5 * thickness + offset),0,(widthA + offset)/2]) {
      difference() {
        cylinder(h=(widthA - offset)/2, d=thickness*3);
        translate([0,0,-1]) {
          cylinder(h=widthA/2 + 2, d = thickness + 2 * offset);
        }
      }
    }
  }
}


//   Bottom Part

color("green") {
  difference() {
    ringPart(beamADiameter, widthA, thickness, -180);
    // part from the connector
    rotate([0, 0, -angle(thickness, beamADiameter/2 + 1.5 * thickness + offset)/2]) {
      translate([-(beamADiameter/2 + 1.5 * thickness + offset),0,(widthA - offset)/2]) {
        cylinder(h=(widthA + offset)/2 + 1, d=thickness*3 + 2 * offset);
      }
    }
  }
  screwPart(beamADiameter, widthA, thickness, thickness);

  // connector
  union() {
    rotate([0, 0, -angle(thickness, beamADiameter/2 + 1.5 * thickness + offset)/2]) {
      translate([-(beamADiameter/2 + 1.5 * thickness + offset),0,0]) {
        cylinder(h=widthA, d=thickness);
      }
    }
    linear_extrude(height=(widthA-offset)/2) {
      polygon(points=[
        [-(beamADiameter/2 + 1.5 * thickness + offset),0],
        [-(beamADiameter/2 + 1.5 * thickness + offset),thickness],
        [-(beamADiameter/2 + thickness),thickness],
        [-(beamADiameter/2),0]
      ]);
    }
  }
}


// Functions
function angle(thickness, total_outer_radius) = atan(thickness / (total_outer_radius));

// HelperModules
module ringPart(beamDiameter, width, thickness, angle=360) {
  difference() {
    if (angle==360) {
      cylinder(d=beamDiameter + 2 * thickness, h=width);
    } else {
      pie((beamDiameter + 2 * thickness) / 2, angle, width);
    }
    translate([0, 0, -1]) {
      cylinder(d=beamDiameter, h=width + 2);
    }
  }
}

module screwPart(beamDiameter, width, thickness, stdThickness) {
  rotate([90, 0, 0]) {
    translate([(beamADiameter + screwDiameter) / 2 + stdThickness, widthA/2, 0]) {
      difference() {
        union() {
          cylinder(d=screwDiameter + 2 * stdThickness, h=thickness);
          linear_extrude(height=thickness) {
            polygon(points=[
              [-(screwDiameter / 2 + stdThickness), widthA/2],
              [-(screwDiameter / 2), widthA/2],
              [screwDiameter / 2 + stdThickness, 0],
              [-(screwDiameter / 2), -widthA/2],
              [-(screwDiameter / 2 + stdThickness), -widthA/2]
            ]);
          }
        }
        translate([0, 0, -1]) {
          cylinder(d=screwDiameter, h=thickness + 2);
        }
      }
    }
  }
}

/**
* pie.scad
*
* Use this module to generate a pie- or pizza- slice shape, which is particularly useful
* in combination with `difference()` and `intersection()` to render shapes that extend a
* certain number of degrees around or within a circle.
*
* This openSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
* project.
*
* @copyright Chris Petersen, 2013
* @license http://creativecommons.org/licenses/LGPL/2.1/
* @license http://creativecommons.org/licenses/by-sa/3.0/
*
* @see http://www.thingiverse.com/thing:109467
* @source https://github.com/dotscad/dotscad/blob/master/pie.scad
*
* @param float radius Radius of the pie
* @param float angle Angle (size) of the pie to slice
* @param float height Height (thickness) of the pie
* @param float spin Angle to spin the slice on the Z axis
*/
module pie(radius, angle, height, spin=0) {
  // Negative angles shift direction of rotation
  clockwise = (angle < 0) ? true : false;
  // Support angles < 0 and > 360
  normalized_angle = abs((angle % 360 != 0) ? angle % 360 : angle % 360 + 360);
  // Select rotation direction
  rotation = clockwise ? [0, 180 - normalized_angle] : [180, normalized_angle];
  // Render
  if (angle != 0) {
    rotate([0,0,spin]) linear_extrude(height=height)
    difference() {
      circle(radius);
      if (normalized_angle < 180) {
        union() for(a = rotation)
        rotate(a) translate([-radius, 0, 0]) square(radius * 2);
      }
      else if (normalized_angle != 360) {
        intersection_for(a = rotation)
        rotate(a) translate([-radius, 0, 0]) square(radius * 2);
      }
    }
  }
}
