// Beamconnector
$fn = 200;

tube = "B";
part = "top";

female = false;

beamADiameter = 40;
beamBDiameter = 30;

widthA = 20;
widthB = 8;

screwDiameter = 2;
screwHeadDiameter = 5;

thickness = 2;

hirthWidth = 20;
hirthHeight = 4;
snaps = 10;

offset = 0.2;

// Main Modules
module topPartMaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  union() {
    topPartNoHirth(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
    translate([(beamDiameter + max(screwDiameter, screwHeadDiameter))/2 + thickness,beamDiameter/2 + thickness - 1,width/2]) {
      rotate([-90,0,0]) {
        snapsWithPlate(snaps, hirthHeight, 0, hirthWidth, $fn, 0, 1, screwDiameter/2);
      }
    }
  }
}

module topPartFemaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  difference() {
    topPartNoHirth(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
    translate([(beamDiameter + max(screwDiameter, screwHeadDiameter))/2 + thickness,beamDiameter/2 + thickness + 1,width/2]) {
      rotate([90,0,0]) {
        snapsWithPlate(snaps, hirthHeight + offset, 0, hirthWidth + 2 * offset, $fn, 0, 1, screwDiameter/2);
      }
    }
  }
}

module topPartNoHirth(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset) {
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
        screwPart(beamDiameter, width, screwDiameter, screwHeadDiameter, beamDiameter/2 + thickness, thickness, hirthWidth, offset);
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
    translate([0, 0, -(width + offset + 1)]) {
      cylinder(d=beamDiameter, h=width + 2 * (width + offset) + 2);
    }
  }
}

module bottomPart(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset) {
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
      screwPart(beamDiameter, width, screwDiameter, screwHeadDiameter, thickness, thickness, hirthWidth, offset);

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
    translate([0, 0, -(width + offset + 1)]) {
      cylinder(d=beamDiameter, h=width +  2 * (width + offset) + 2);
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

module screwPart(beamDiameter, width, screwDiameter, screwHeadDiameter, thickness, stdThickness, hirthWidth, offset) {
  rotate([90, 0, 0]) {
    translate([(beamDiameter + max(screwDiameter, screwHeadDiameter)) / 2 + stdThickness, width/2, 0]) {
      difference() {
        union() {
          cylinder(d=max(hirthWidth, screwDiameter, screwHeadDiameter) + 2 * (stdThickness + offset), h=thickness);
          linear_extrude(height=thickness) {
            polygon(points=[
              [-(max(screwDiameter, screwHeadDiameter) / 2 + stdThickness), width/2],
              [-(max(screwDiameter, screwHeadDiameter) / 2), width/2],
              [max(screwDiameter, screwHeadDiameter) / 2 + stdThickness + offset, 0],
              [-(max(screwDiameter, screwHeadDiameter) / 2), -width/2],
              [-(max(screwDiameter, screwHeadDiameter) / 2 + stdThickness), -width/2]
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

// Print Modules
module printTopPart(female, beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  translate([0,0,max(width, (width + max(hirthWidth, screwDiameter, screwHeadDiameter))/2 + (thickness + offset))]) {
    rotate([0,180,0]) {
      if (female) {
        topPartFemaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
      } else {
        topPartMaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
      }
    }
  }
}

module printBottomPart(beamADiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset) {
  translate([0,0,max(0, (max(hirthWidth, screwDiameter, screwHeadDiameter) - width)/2 + (thickness + offset))]) {
    bottomPart(beamADiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
}
}

module printPart(part, female, beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  if (part == "top") {
    printTopPart(female, beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  } else if (part == "bottom") {
    printBottomPart(beamADiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
  } else {
    translate([0,thickness + offset,0]) {
      printTopPart(female, beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
    }
    translate([0,-(thickness + offset),0]) {
      bottomPart(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
    }
  }
}

module printParts(tube, part, beamADiameter, widthA, beamBDiameter, widthB, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  if (tube == "A") {
    printPart(part, false, beamADiameter, widthA, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  } else if (tube == "B") {
    printPart(part, true, beamBDiameter, widthB, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  } else {
    translate([-(beamADiameter/2 + max(screwDiameter, screwHeadDiameter, hirthWidth) + 3.5 * thickness + 2 * offset),0,0]) {
      printPart(part, false, beamADiameter, widthA, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
    }
    translate([beamBDiameter/2 + max(screwDiameter, screwHeadDiameter, hirthWidth) + 3.5 * thickness + 2 * offset,0,0]) {
      printPart(part, true, beamBDiameter, widthB, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
    }
  }
}

// Example Modules
module completeExample(beamADiameter, widthA, beamBDiameter, widthB, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  translate([-((beamADiameter + max(screwDiameter, screwHeadDiameter))/2 + thickness),-((beamADiameter + offset)/2 + thickness),-widthA/2]) {
    exampleMalePart(beamADiameter, widthA, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  }
  rotate([180,180 - 360/snaps,0]) {
    translate([-((beamBDiameter + max(screwDiameter, screwHeadDiameter))/2 + thickness),-((beamBDiameter + offset)/2 + thickness),-widthB/2]) {
      exampleFemalePart(beamBDiameter, widthB, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
    }
  }
}

module exampleFemalePart(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  color("orange") {
    topPartFemaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  }
  color("yellow") {
    bottomPart(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
  }
}

module exampleMalePart(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset) {
  color("Purple") {
    topPartMaleHirth(beamDiameter, width, hirthWidth, hirthHeight, snaps, screwDiameter, screwHeadDiameter, thickness, offset);
  }
  color("Violet") {
    bottomPart(beamDiameter, width, screwDiameter, screwHeadDiameter, hirthWidth, thickness, offset);
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


printParts(
  tube,
  part,
  beamADiameter,
  widthA,
  beamBDiameter,
  widthB,
  hirthWidth,
  hirthHeight,
  snaps,
  screwDiameter,
  screwHeadDiameter,
  thickness,
  offset
);
