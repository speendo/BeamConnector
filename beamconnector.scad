// Beamconnector
$fn = 200;

beamADiameter = 40;
beamBDiameter = 30;

widthA = 20;
widthB = 8;

screwDiameter = 3;

thickness = 2;

hirthWidth = 5;
hirthHeight = 3;
snaps = 10;

offset = 0.2;

// Part A
//   Top Part
color("red") {
  topPartMaleHirth(beamADiameter, widthA, hirthWidth, hirthHeight, snaps, screwDiameter, thickness, offset);
}


//   Bottom Part
color("green") {
  bottomPart(beamADiameter, widthA, screwDiameter, hirthWidth, thickness, offset);
}

// Main Modules
module topPartMaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, thickness, offset) {
  union() {
    topPartNoHirth(beamDiameter, width, screwDiameter, hirthWidth, thickness, offset);
    translate([(beamDiameter + screwDiameter)/2 + thickness,beamDiameter/2 + thickness - 1,width/2]) {
      rotate([-90,0,0]) {
        snapsWithPlate(snaps, hirthHeight, 0, 2 * hirthWidth + screwDiameter, $fn, 0, 1, screwDiameter/2);
      }
    }
  }
}

module topPartFemaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, thickness, offset) {
  difference() {
    topPartNoHirth(beamDiameter, width, screwDiameter, hirthWidth, thickness, offset);
    translate([(beamDiameter + screwDiameter)/2 + thickness,beamDiameter/2 + thickness + 1,width/2]) {
      rotate([90,0,0]) {
        snapsWithPlate(snaps, hirthHeight + offset, 0, 2 * (hirthWidth + offset) + screwDiameter, $fn, 0, 1, screwDiameter/2);
      }
    }
  }
}

module topPartNoHirth(beamDiameter, width, screwDiameter, hirthWidth, thickness, offset) {
  difference() {
    union() {
      difference() {
        ringPartOuter(beamDiameter, width, thickness, 180);
        translate([0,0,-1]) {
          linear_extrude(height=(width + offset)/2 + 1) {
            polygon(points=[
              [-(beamDiameter/2 + 1.5 * thickness + offset),-1],
              [-(beamDiameter/2 + 1.5 * thickness + offset),thickness + offset],
              [-(beamDiameter/2 + thickness),thickness + offset],
              [-(beamDiameter/2),offset],
              [-(beamDiameter/2) + 1,offset],
              [-(beamDiameter/2) + 1,-1],
              [-(beamDiameter/2),-1]
            ]);
          }
        }
      }
      translate([0,beamDiameter/2 + thickness,0]) {
        screwPart(beamDiameter, width, beamDiameter/2 + thickness, thickness, hirthWidth, offset);
      }
      difference() {
        cube([beamDiameter/2 + thickness, beamDiameter/2 + thickness, width]);
      }

      // connector
      rotate([0, 0, -angle(thickness, beamDiameter/2 + 1.5 * thickness)/2]) {
        translate([-(beamDiameter/2 + 1.5 * thickness + offset),0,(width + offset)/2]) {
          difference() {
            cylinder(h=(width - offset)/2, d=3 * thickness + 2 * offset);
            translate([0,0,-1]) {
              cylinder(h=width/2 + 2, d = thickness + 2 * offset);
            }
          }
        }
      }
    }
    translate([0, 0, -(offset + 1)]) {
      cylinder(d=beamDiameter, h=width + 2 * offset + 2);
    }
  }
}

module bottomPart(beamDiameter, width, screwDiameter, hirthWidth, thickness, offset) {
  difference() {
    union() {
      difference() {
        ringPartOuter(beamDiameter, width, thickness, -180);
        // part from the connector
        rotate([0, 0, -angle(thickness, beamDiameter/2 + 1.5 * thickness + offset)/2]) {
          translate([-(beamDiameter/2 + 1.5 * thickness + offset),0,(width - offset)/2]) {
            cylinder(h=(width + offset)/2 + 1, d=3 * thickness + 4 * offset);
          }
        }
      }
      screwPart(beamDiameter, width, thickness, thickness, hirthWidth, offset);

      // connector
      union() {
        rotate([0, 0, -angle(thickness, beamDiameter/2 + 1.5 * thickness + offset)/2]) {
          translate([-(beamDiameter/2 + 1.5 * thickness + offset),0,0]) {
            cylinder(h=width, d=thickness);
          }
        }
        linear_extrude(height=(width-offset)/2) {
          polygon(points=[
            [-(beamDiameter/2 + 1.5 * thickness + offset),0],
            [-(beamDiameter/2 + 1.5 * thickness + offset),thickness],
            [-(beamDiameter/2 + thickness),thickness],
            [-(beamDiameter/2),0]
          ]);
        }
      }
    }
    translate([0, 0, -(offset + 1)]) {
      cylinder(d=beamDiameter, h=width + 2 * offset + 2);
    }
  }
}

// Functions
function angle(thickness, total_outer_radius) = atan(thickness / (total_outer_radius));

// Helper Modules
module ringPartOuter(beamDiameter, width, thickness, angle=360) {
  if (angle==360) {
    cylinder(d=beamDiameter + 2 * thickness, h=width);
  } else {
    pie((beamDiameter + 2 * thickness) / 2, angle, width);
  }
}

module screwPart(beamDiameter, width, thickness, stdThickness, hirthWidth, offset) {
  rotate([90, 0, 0]) {
    translate([(beamDiameter + screwDiameter) / 2 + stdThickness, width/2, 0]) {
      difference() {
        union() {
          cylinder(d=screwDiameter + 2 * (stdThickness + hirthWidth + offset), h=thickness);
          linear_extrude(height=thickness) {
            polygon(points=[
              [-(screwDiameter / 2 + stdThickness), width/2],
              [-(screwDiameter / 2), width/2],
              [screwDiameter / 2 + stdThickness, 0],
              [-(screwDiameter / 2), -width/2],
              [-(screwDiameter / 2 + stdThickness), -width/2]
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

// Hirth Joint (my own project)
module singleSnap(snaps, h, ct, d, res, gpt) {
  // full height
  fh = h + ct;

  // original size
  angle = 180 / snaps;
  side = tan(angle) * d / 2;

  // adjusted size (necessary to overcome compilation issues)
  aH = fh + gpt / 2;
  ratio = aH / fh;
  aSide = side * ratio;

  translate([d/2,0,0]) {
    rotate([0,-90,0]) {
      linear_extrude(height = d/2,center = false, twist = 0, scale = [1,0], slices = res) {
        polygon(
          points=[[aH, 0],[0, aSide],[0, -aSide]],
          paths=[[0,1,2]]
        );
      }
    }
  }
}

module allSnaps(snaps, h, ct, d, res, snapfree, gpt) {
  translate([0, 0, - ct / 2]) {
    difference() {
      intersection() {
        for(i = [0:snaps - 1]) {
          rotate((360 / snaps) * i, [0, 0, 1]) {
            singleSnap(snaps, h, ct, d, res, gpt);
          }
        }
        translate([0, 0, ct / 2]) {
          cylinder(h = h + gpt / 2, r = d / 2);
        }
      }
      translate([0, 0, -1]) {
        cylinder(h = h + ct + gpt / 2 + 2, r = snapfree);
      }
    }
  }
}

module snapsWithPlate(snaps, h, ct, d, res, snapfree, gpt, screw) {
  difference() {
    union() {
      // 0.5 * gpt because of the necessary adjustment in singleSnap
      translate([0, 0, 0.5 * gpt]) {
        allSnaps(snaps, h, ct, d, res, snapfree, gpt);
      }
      cylinder(h = gpt, r = d / 2);
    }
    translate([0, 0, -1]) {
      cylinder(h = h + gpt + 2, r = screw);
    }
  }
}
