use <Debug.scad>;

include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

use <Reference.scad>;
use <Frame.scad>;
use <Tee Housing.scad>;

use <Forend.scad>;

use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Firing Pin Guide.scad>;
use <Striker.scad>;
use <Stock Spacer.scad>;
use <Spring Cap.scad>;
use <Striker Guide.scad>;

module Liberator12k() {

  translate([ForendOffset(),0,0])
  rotate([-14+(30*$t),0,0])
  BarrelLugs();

  color("Lime")
  render()
  DebugHalf(dimension=20) {
    Forend();
  }

  Reference_TriggerGuard(debug=true);

  Reference_TeeHousing();

  color("HotPink")
  translate([(TeeWidth(receiverTee)/2) - BushingDepth(breechBushing),0,0])
  rotate([0,-90,0])
  firing_pin_guide();

  render() {
    translate([-4.5,0,0])
    rotate([0,-90,0])
    SpringCartridge(debug=true);

    translate([-4.55-3,0,0])
    rotate([0,-90,0])
    SpringCartridge(debug=true);
  }

  color("Gold")
  translate([-TeeWidth(ReceiverTee())/2 -12,0,-(1/8)-TeeCenter(ReceiverTee())])
  StrikerGuide();

  color("Grey", 1)
  Frame();

  color("White", 0.2)
  Reference();
}

//rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4])
{
  Liberator12k();
}
