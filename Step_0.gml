// Code for Gamemaker platformer with Dash mechanic

var xDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var jump = keyboard_check_pressed(vk_space);
var dash = keyboard_check_pressed(ord("M"));
var onTheGround = place_meeting(x, y + 1, oWall);
var onAWall = place_meeting(x-5, y, oWall) - place_meeting(x+5, y, oWall);
 
mvtLocked = max(mvtLocked - 1, 0);
dashDuration = max(dashDuration - 1, 0);

 
if (dashDuration > 0) ySpeed = 0;
else ySpeed++;
 
 if (onTheGround)
	dashSwitch = true;
 
if (dash && dashSwitch) {
    dashDuration = 10;
    xSpeed = image_xscale * dashSpd;
	dashSwitch = false;
}

if (mvtLocked <= 0 && dashDuration <= 0) {
    if (xDirection != 0) image_xscale = xDirection*3;
    xSpeed = xDirection * spd;
} 
    if (jump) {
        if (onTheGround) {
            ySpeed = -15;
    }
}
 
if (dashDuration > 0) {
    sprite_index = Dash_Char;
} else if (onTheGround) {
    if (xDirection != 0) { sprite_index = Run_Char; } 
    else { sprite_index = Idle_Char; }
} else {
    sprite_index = Jump_Char;
}
 
if (place_meeting(x + xSpeed, y, oWall)) { 
    
    while (!place_meeting(x + sign(xSpeed), y, oWall)) {
        x += sign(xSpeed);
    }
    xSpeed = 0; 
}
 
x += xSpeed;
 
 
if (place_meeting(x, y + ySpeed, oWall)) { 
    
    while (!place_meeting(x, y + sign(ySpeed), oWall)) {
        y += sign(ySpeed);
    }
    
    ySpeed = 0; 
}
 
y += ySpeed;

if (x > maxXpos)
	maxXpos = x;
	
