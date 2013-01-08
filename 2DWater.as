import flash.geom.Point;
import flash.display.MovieClip;
import fl.events.SliderEvent;
stop();

var WaterLength = stage.stageWidth;  // not less than 550px

var StartX   = 0;
var StartY   = 250;

var ParticleNum:int = 100;
var ParticlePos     :Array = new Array();
var ParticleVelocity:Array = new Array();
var ParticleMC      :Array = new Array();

var Dampening   = 0.03;
var SpringConst = 0.055;	
var Spread      = 0.08;


var leftDeltas:Array  = new Array();
var rightDeltas:Array = new Array();

for (var i = 0; i < ParticleNum; i++)
{
	var deltaX:Number = WaterLength / ParticleNum;
	ParticlePos[i]   = new Object();
	ParticlePos[i].x = (StartX + deltaX * i);
	ParticlePos[i].y = StartY;

	ParticleVelocity[i] = 0.0;
	ParticleMC[i] = new water();
	ParticleMC[i].x = ParticlePos[i].x;
	ParticleMC[i].y = ParticlePos[i].y;
	ParticleMC[i].height = stage.stageHeight - ParticlePos[i].y;
	ParticleMC[i].addEventListener(MouseEvent.CLICK, onClickWater);
	this.addChild(ParticleMC[i]);
}

function onClickWater(e:MouseEvent) 
{
	var index = int(mouseX/(WaterLength / ParticleNum));
	ParticleVelocity[index] = slider_force.value;
}

var container:MovieClip = new MovieClip();
addChild(container);
container.addEventListener(Event.ENTER_FRAME, updateWaterParticle);

function updateWaterParticle(e:Event):void
{
	// update position
	for (var i = 0; i < ParticleNum; i++)
	{
		var displacement:Number = ParticlePos[i].y - StartY;
		var accel:Number = (-SpringConst * displacement) - (ParticleVelocity[i] * Dampening);
		ParticleVelocity[i] += accel;
		ParticlePos[i].y += ParticleVelocity[i];
	}

	// update neighbours's position
	for (var j = 0; j < slider_smooth.value; j++)
	{
		for ( i = 0; i < ParticleNum; i++)
		{
			if (i > 0)
			{
				leftDeltas[i] = Spread * (ParticlePos[i].y - ParticlePos[i - 1].y);
				ParticleVelocity[i - 1] += leftDeltas[i];
			}
			if (i < ParticleNum - 1)
			{
				rightDeltas[i] = Spread * (ParticlePos[i].y - ParticlePos[i + 1].y);
				ParticleVelocity[i + 1] += rightDeltas[i];
			}
		}

		for ( i = 0; i < ParticleNum; i++)
		{
			if (i > 0)
			{
				ParticlePos[i - 1].y += leftDeltas[i];
			}
			if (i <ParticleNum - 1)
			{
				ParticlePos[i + 1].y += rightDeltas[i];
			}
		}
	}
	
	for ( i = 0; i < ParticleNum; i++)
	{
		ParticleMC[i].x = ParticlePos[i].x;
		ParticleMC[i].y = ParticlePos[i].y;
		ParticleMC[i].height = stage.stageHeight - ParticlePos[i].y;
	}
	
}


txt_force.text  = String(slider_force.value);
txt_spread.text = String(slider_spread.value);
txt_smooth.text = String(slider_smooth.value);
txt_res.text    = String(slider_res.value);


// force
slider_force.addEventListener(SliderEvent.CHANGE, onSliderForceChange);
function onSliderForceChange(e:Event)
{
	txt_force.text = String(slider_force.value);
}

slider_force.addEventListener(SliderEvent.THUMB_DRAG, onSliderForceDrag);
function onSliderForceDrag(e:Event)
{
	txt_force.text = String(slider_force.value);
}

// resistance
slider_res.addEventListener(SliderEvent.CHANGE, onSliderResistanceChange);
function onSliderResistanceChange(e:Event)
{
	txt_res.text = String(slider_res.value);
	SpringConst = slider_res.value/1000.0;
}

slider_res.addEventListener(SliderEvent.THUMB_DRAG, onSliderResistanceDrag);
function onSliderResistanceDrag(e:Event)
{
	txt_res.text = String(slider_res.value);
}

// smooth
slider_smooth.addEventListener(SliderEvent.CHANGE, onSliderSmoothChange);
function onSliderSmoothChange(e:Event)
{
	txt_smooth.text = String(slider_smooth.value);
	SpringConst = slider_res.value/1000.0;
}

slider_smooth.addEventListener(SliderEvent.THUMB_DRAG, onSliderSmoothDrag);
function onSliderSmoothDrag(e:Event)
{
	txt_smooth.text = String(slider_smooth.value);
}

// spread
slider_spread.addEventListener(SliderEvent.CHANGE, onSliderSpreadChange);
function onSliderSpreadChange(e:Event)
{
	txt_spread.text = String(slider_spread.value);
	Spread = slider_spread.value/1000.0;
}

slider_spread.addEventListener(SliderEvent.THUMB_DRAG, onSliderSpreadDrag);
function onSliderSpreadDrag(e:Event)
{
	txt_spread.text = String(slider_spread.value);
}

// interval
slider_interval.addEventListener(SliderEvent.CHANGE, onSliderIntervalChange);
function onSliderIntervalChange(e:Event)
{
	autoTimer.delay = slider_interval.maximum - slider_interval.value;
}

slider_interval.addEventListener(SliderEvent.THUMB_DRAG, onSliderIntervalDrag);
function onSliderIntervalDrag(e:Event)
{
	autoTimer.delay = slider_interval.maximum - slider_interval.value;
}

// reset button
btn_reset.addEventListener(MouseEvent.CLICK, onClickReset);
function onClickReset(e:Event)
{
	slider_force.value  = 50;
	slider_spread.value = 90;
	Spread = slider_spread.value/1000.0;
	slider_smooth.value =4;
	slider_res.value =50;
	SpringConst = slider_res.value/1000.0;
	txt_force.text = String(slider_force.value);
	txt_spread.text = String(slider_spread.value);
	txt_smooth.text = String(slider_smooth.value);
	txt_res.text = String(slider_res.value);
}

// stop button 
btn_stop.addEventListener(MouseEvent.CLICK, onClickStop);
function onClickStop(e:Event)
{
	for(var i=0 ; i<ParticleNum; i++)
	{
		ParticleVelocity[i] = 0.0;
		ParticlePos[i].y = StartY;
	}
}

// random button
btn_random.addEventListener(MouseEvent.CLICK, onClickRandom);
function onClickRandom(e:Event)
{
	slider_force.value =  randomRange(slider_force.maximum, slider_force.minimum);
	slider_spread.value = randomRange(slider_spread.maximum, slider_spread.minimum);
	Spread = slider_spread.value/1000.0;
	slider_smooth.value =randomRange(slider_smooth.maximum, slider_smooth.minimum);
	slider_res.value =randomRange(slider_res.maximum, slider_res.minimum);
	SpringConst = slider_res.value/1000.0;
	txt_force.text = String(slider_force.value);
	txt_spread.text = String(slider_spread.value);
	txt_smooth.text = String(slider_smooth.value);
	txt_res.text = String(slider_res.value);
}

enableAuto.addEventListener(Event.CHANGE, checkboxChange);

function checkboxChange(evt:Event)
{
	if(evt.target.selected == true)
	{
		autoTimer.start();
		slider_interval.enabled = true;
	}
	else
	{
		autoTimer.stop();
		slider_interval.enabled = false;
	}
}

var autoTimer:Timer=new Timer(slider_interval.maximum - slider_interval.value);
autoTimer.addEventListener("timer", splash);
autoTimer.stop();

function splash(e:Event):void
{
	var i = int(randomRange(0,ParticleNum-1));
	ParticleVelocity[i] = slider_force.value;
}

function randomRange(max:Number, min:Number = 0):Number
{
     return Math.random() * (max - min) + min;
}	