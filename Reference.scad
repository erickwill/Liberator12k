use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference Build Area.scad>;

//DEFAULT_BARREL = Spec_PointFiveSix9mmBarrel();
//DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
//DEFAULT_BARREL = Spec_PipeOneInch(); // Trying a 1" pipe sleeve around the shell
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

DEFAULT_STOCK = Spec_PipeThreeQuarterInch();
DEFAULT_BREECH = Spec_BushingThreeQuarterInch();
DEFAULT_FRAME_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_ACTUATOR_ROD = Spec_RodFiveSixteenthInch(); // Revolver Setting
DEFAULT_CYLINDER_ROD = Spec_RodFiveSixteenthInch(); // Revolver Setting
DEFAULT_SEAR_ROD = Spec_RodOneEighthInch();
DEFAULT_SAFETY_ROD = Spec_RodOneEighthInch();
DEFAULT_RESET_ROD = Spec_RodOneEighthInch();
DEFAULT_TRIGGER_ROD = Spec_RodOneEighthInch();
DEFAULT_FIRING_PIN_ROD = Spec_RodOneEighthInch();
DEFAULT_GRIP_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_RECEIVER = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
DEFAULT_BUTT = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
DEFAULT_BARREL_LENGTH = 18;
DEFAULT_STOCK_LENGTH = 12;


// Settings: Resolution 0 = low, 1 = high
RESOLUTION = 1;
function Resolution(low, high) = RESOLUTION == 0 ? low : high;

// Settings: Manifold Gap
MANIFOLD_GAP = 0.0001;
function ManifoldGap(n=1) = MANIFOLD_GAP*n;

// Settings: Walls
function WallTee()              = 0.1;
function WallTriggerGuardRod()  = 0.35;
function WallFrontGripRod()     = 0.25;
function WallFrameRod()         = 0.2;
function WallFrameFront()       = 0.215;
function WallFrameBack()        = 0.3;
function WallBarrelLug()        = 0.1;

// Settings: Lengths
function StockLength() = DEFAULT_STOCK_LENGTH;
function BarrelLength() = DEFAULT_BARREL_LENGTH;

// Settings: Offsets
function OffsetFrameRod() = 0.4;
function OffsetFrameBack() = 0.315 + WallFrameBack();
function FrameRodMatchedAngle() = 45;

// Settings: Vitamins
function BarrelPipe() = DEFAULT_BARREL;
function BreechBushing() = DEFAULT_BREECH;
function ReceiverTee() = DEFAULT_RECEIVER;
function ButtTee() = DEFAULT_BUTT;
function StockPipe() = DEFAULT_STOCK;
function FrameRod() = DEFAULT_FRAME_ROD;
function ActuatorRod() = DEFAULT_ACTUATOR_ROD;
function CylinderRod() = DEFAULT_CYLINDER_ROD;
function SearRod() = DEFAULT_SEAR_ROD;
function SafetyRod() = DEFAULT_SAFETY_ROD;
function ResetRod() = DEFAULT_RESET_ROD;
function TriggerRod() = DEFAULT_TRIGGER_ROD;
function FiringPinRod() = DEFAULT_FIRING_PIN_ROD;
function GripRod() = DEFAULT_GRIP_ROD;

// Calculated: Positions
function ButtTeeCenterX() = - StockLength()
                            - (TeePipeEndOffset(ReceiverTee(),StockPipe())*2);

module Barrel(barrel=DEFAULT_BARREL, barrelLength=DEFAULT_BARREL_LENGTH,
              breech=DEFAULT_BREECH,
              receiver=DEFAULT_RECEIVER) {
  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
  rotate([0,90,0])
  Pipe(barrel, length=barrelLength);

}

module Receiver(receiver=ReceiverTee()) {
  translate([0,0,-TeeCenter(receiver)])
  CrossFitting(receiver);
}

function ReceiverInnerWidth(receiver) = TeeWidth(receiver) - (TeeRimWidth(receiver)*2);

module Stock(receiver, stock, stockLength) {
  translate([-TeeCenter(ReceiverTee())+PipeThreadDepth(stock),0,0])
  rotate([0,-90,0])
  Pipe(stock, clearance=PipeClearanceLoose(), length=stockLength+0.02);
}

module Butt(receiver, stockLength) {
  translate([ButtTeeCenterX()+TeeCenter(ReceiverTee()),0,0])
  rotate([0,-90,0])
  Tee(ButtTee());
}

module Breech(receiver, breech) {
  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
  rotate([0,-90,0])
  rotate([0,0,90])
  Bushing(spec=breech);
}

module Reference(barrel=BarrelPipe(), barrelLength=18,
                 breech=Spec_BushingThreeQuarterInch(),
                 receiver=ReceiverTee(),
                 stock=Spec_PipeThreeQuarterInch(), stockLength=StockLength(),
                 butt=Spec_TeeThreeQuarterInch()) {

  %color("Black", 0.3) {
    Stock(receiver, stock, stockLength);
    Breech(receiver, breech);
  }

  %color("White", 0.1) {
    Receiver(receiver);
    Butt(receiver, stockLength);
    translate([ManifoldGap(),0,0])
    Barrel(receiver=receiver, breech=breech, barrel=barrel, barrelLength=barrelLength);
  }
}

scale([25.4, 25.4, 25.4]) {
  Reference();
  ReferenceBuildArea();
}
