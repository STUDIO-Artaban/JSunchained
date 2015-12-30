/* Created by Pascal VIGUIE on 17/06/2015.
   Copyright (c) 2015 - STUDIO Artaban.
   All rights reserved. */

var ACCEL_LIMITS_SUP = 9.80665;
var ACCEL_LIMITS_INF = -ACCEL_LIMITS_SUP;
var ORIENTATION_SUP = ACCEL_LIMITS_SUP / 2.0;
var ORIENTATION_INF = -ORIENTATION_SUP;
function ACCEL_CLIP(xyz) {
    return ((xyz > ACCEL_LIMITS_SUP)? ACCEL_LIMITS_SUP:(xyz < ACCEL_LIMITS_INF)? ACCEL_LIMITS_INF:xyz);
}

var ROTATION_PRECISION = 2.0;
var ACCEL_TO_ROTATION = (Math.PI / ((4.0 + ROTATION_PRECISION) * ORIENTATION_INF));

var PORTRAIT = 1;
var REV_PORTRAIT = 2;
var LANDSCAPE = 3;
var REV_LANDSCAPE = 4;
var FLAT = 5;
var REVERSED = 6;

var VELOCITY = 3.0;
var RADIAN_TO_DEGREE = 180.0 / Math.PI;

var ACCEL_PRECISION = 0.2;
function ACCEL_CHANGED(XYZ, xyz) {
    return (((XYZ - ACCEL_PRECISION) > xyz) || ((XYZ + ACCEL_PRECISION) < xyz));
}

//
var g_X = 0.0;
var g_Y = 0.0;
var g_Z = 0.0;

var g_rotation = 0; // Degree

var g_rotate = 0.0;
var g_rotateVel = 0.0;
var g_orientation = 0;
var g_prevPos = 0;
function getRotation(x, y, z) {

    if (unchained.isAvailable()) {
        if (unchained.isAndroid()) { // Android
        
            x = ACCEL_CLIP(x);
            y = ACCEL_CLIP(y);
            z = ACCEL_CLIP(z);
        }
        else { // iOS/WindowsPhone/etc.

            x = ACCEL_CLIP(-x * 10.0);
            y = ACCEL_CLIP(-y * 10.0);
            z = ACCEL_CLIP(-z * 10.0);
        }
    }
    else {
        
        x = ACCEL_CLIP(x);
        y = ACCEL_CLIP(y);
        z = ACCEL_CLIP(z);
    }
    var orientation = 0;
    if ((ORIENTATION_INF < z) && (z < ORIENTATION_SUP)) {

        if ((ORIENTATION_INF < x) && (x < ORIENTATION_SUP)) orientation = (ORIENTATION_SUP < y)? PORTRAIT:REV_PORTRAIT;
        else if ((ORIENTATION_INF < y) && (y < ORIENTATION_SUP)) orientation = (ORIENTATION_SUP < x)? LANDSCAPE:REV_LANDSCAPE;
    }
    if ((!orientation) && (ORIENTATION_INF < x) && (x < ORIENTATION_SUP) &&
            (ORIENTATION_INF < y) && (y < ORIENTATION_SUP)) orientation = (ORIENTATION_SUP < z)? FLAT:REVERSED;

    var prevOrientation = g_orientation;
    if (orientation)
        g_orientation = orientation;

    switch (g_orientation) {
        default: {

            g_orientation = PORTRAIT;
            //break;
        }
        case PORTRAIT: { // Portrait (home button at bottom)

            if (prevOrientation == LANDSCAPE) {

                g_rotate -= 2.0 * Math.PI;
                g_rotateVel -= 2.0 * Math.PI;
            }
            else
            if (ACCEL_CHANGED(g_X, x))
                g_rotateVel = x * ACCEL_TO_ROTATION;
            break;
        }
        case REV_PORTRAIT: { // Reversed portrait

            if (ACCEL_CHANGED(g_X, x))
                g_rotateVel = (x * -ACCEL_TO_ROTATION) + Math.PI;
            break;
        }
        case LANDSCAPE: { // Landscape (home button at right)

            if (prevOrientation == PORTRAIT) {

                g_rotate += 2.0 * Math.PI;
                g_rotateVel += 2.0 * Math.PI;
            }
            else if (ACCEL_CHANGED(g_Y, y))
                g_rotateVel = (y * -ACCEL_TO_ROTATION) + ((3.0 * Math.PI) / 2.0);
            break;
        }
        case REV_LANDSCAPE: { // Reversed landscape

            if (ACCEL_CHANGED(g_Y, y))
                g_rotateVel = (y * ACCEL_TO_ROTATION) + (Math.PI / 2.0);
            break;
        }
        case FLAT: // Flat
        case REVERSED: { // Reversed

            if ((!ACCEL_CHANGED(g_X, x)) && (!ACCEL_CHANGED(g_Y, y)))
                break;

            if ((y > 0.0) && (x < 0.0)) {

                g_rotateVel = Math.atan(-x / y);
                g_prevPos = 0;
            }
            else if ((y < 0.0) && (x < 0.0)) {

                g_rotateVel = Math.atan(y / x) + (Math.PI / 2.0);
                g_prevPos = 0;
            }
            else if ((y < 0.0) && (x > 0.0)) {

                if (g_prevPos == 2)
                    g_rotate += 2.0 * Math.PI;
                g_rotateVel = Math.PI - Math.atan(x / y);
                g_prevPos = 1;
            }
            else if ((y > 0.0) && (x > 0.0)) { // 'else if' instead of 'else' coz 'y' must be > 0

                if (g_prevPos == 1)
                    g_rotate -= 2.0 * Math.PI;
                g_rotateVel = -Math.atan(x / y);
                g_prevPos = 2;
            }
            //else // 'x' & 'y' are equal to 0: Nothing to do
            break;
        }
    }
    if (ACCEL_CHANGED(g_X, x)) g_X = x;
    if (ACCEL_CHANGED(g_Y, y)) g_Y = y;
    if (ACCEL_CHANGED(g_Z, z)) g_Z = z;

    g_rotate -= (g_rotate - g_rotateVel) / VELOCITY;
    g_rotation = -Math.round(RADIAN_TO_DEGREE * g_rotate);
    return g_rotation;
}

