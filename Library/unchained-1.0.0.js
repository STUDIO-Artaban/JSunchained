/* Created by Pascal VIGUIE on 11/15/2015.
   Copyright(c) 2016 - STUDIO Artaban.
   All rights reserved. */

'use strict';

window.console.log = function(msg) {
    unchainedConsole.log(msg);
};
window.requestUnchained = function() { };
////// Init

window.UNCHAINED_ERR_WRONG_PARAMETER = 1;
window.UNCHAINED_ERR_ELEMENT_NOT_FOUND = 2;
window.UNCHAINED_ERR_NOT_IMG_ELEMENT = 3;
////// Errors

window.UNCHAINED_PERM_CAMERA = 0x00000001;
////// Permissions

window.UNCHAINED_REQ_PERMISSION = 1;
window.UNCHAINED_REQ_SENSORS = 2;
window.UNCHAINED_REQ_CAMERA = 3;
////// Requests

window.unchainedCallback = function(doneFunct) {
    if (typeof arguments[1] != 'undefined')
        doneFunct(arguments[1]);
    else
        doneFunct();
};
window.unchained = {
    permission : 0,
    sensors : {
        accel : {
            x : 0.0,
            y : 0.0,
            z : 0.0,
            random : function() {

                var direction = Math.random();
                this.x = Math.random() * ((direction < 0.165)? 10.0:-10.0);
                this.y = Math.random() * (((direction > 0.333) && (direction < 0.498))? 10.0:-10.0);
                this.z = Math.random() * (((direction > 0.666) && (direction < 0.831))? 10.0:-10.0);
            },
            toString : function() {
                return '{x:' + this.x.toFixed(5) + ';y:' + this.y.toFixed(5) + ';z:' + this.z.toFixed(5) + '};';
            }
        },
        random : function() {

            this.accel.random();
            var self = this;
            setTimeout(function() { self.random(); }, 40);
        },
        toString : function() {
            return this.accel.toString();
        }
    },
    camera : {
        playing : false,
        varArray : [],
        imageArray : [],
        container : function(element, attribute, url) {

            this.element = element;
            this.imageAtt = attribute;
            this.url = (typeof url != 'undefined')? url:false;
            this.image = new Image();
            this.toString = function() {
                return '{element:' + this.element.toString() + ';imageAtt:' + this.imageAtt + ';url:' + ((this.url)? 'true':'false') +
                       ';image:' + this.image.toString() + '};';
            };
        },
        start : function(width, height, imgArray) {

            if ((typeof imgArray != 'object') || (typeof imgArray.slice != 'function') || (this.playing))
                return false;
            this.imageArray = imgArray.slice();
            if (unchained.isAvailable()) {

                this.varArray = [];
                for (var i = 0; i < this.imageArray.length; ++i)
                    this.varArray.push(0);
                requestUnchained(UNCHAINED_REQ_CAMERA, true);
            }
            else {

                this.playing = true;
                unchained.camera.random();
            }
            return true;
        },
        stop : function() {

            if (!this.playing)
                return false;
            if (unchained.isAvailable())
                requestUnchained(UNCHAINED_REQ_CAMERA, false);
            this.randIdx = 0;
            this.playing = false;
            return true;
        },
        randIdx : 0,
        random : function() {

            if (!this.playing)
                return;
            ++this.randIdx;
            for (var i = 0; i < this.imageArray.length; ++i)
                if (this.imageArray[i].image.complete) {
                    this.imageArray[i].element[this.imageArray[i].imageAtt] = (!this.imageArray[i].url)? this.imageArray[i].image.src:'url("' + this.imageArray[i].image.src + '")';
                    this.imageArray[i].image.src = 'http://jsunchained.com/default/camera' + this.randIdx + '.png';
                }

            if (this.randIdx == 9)
                this.randIdx = 0;
            var self = this;
            setTimeout(function() { self.random(); }, 40);
        },
        toString : function() {
            return '{playing:' + this.playing + ';imageArray:' + this.imageArray.toString() + ';varArray:' + this.varArray.toString() +
                    ';randIdx:' + this.randIdx + '};';
        }
    },
    error : 0,
    version : '1.0.0',
    connected : false,
    isAndroid : function() { return (/Android/i.test(navigator.userAgent)); },
    isIOS : function() { return (/iPhone|iPad|iPod/i.test(navigator.userAgent)); },
    isWindowsPhone : function() { return (/IEMobile/i.test(navigator.userAgent)); },
    isAvailable : function() {
        return ((this.isAndroid() || this.isIOS() || this.isWindowsPhone()) && (typeof requestUnchained != 'undefined'));
    },
    isRunning : function() { return (this.isAvailable() && this.connected); },
    toString : function() {
        return ((this.isAvailable())? '{available};':'{unavailable};') + this.sensors.toString() + this.camera.toString() +
                '{error:' + this.error + '};{version:' + this.version + '};{connected:' + ((this.connected)? 'true':'false') + '}';
    }
};

////// Core
var LOOP_DELAY = 40; // In milliseconds
var DISCOVER_DELAY = 50; // 2 second (LOOP_DELAY * DISCOVER_DELAY)
var LOCAL_HOST = 'http://127.0.0.1:';
var METHOD_GET = 'GET';
var PORT_MIN = 1024;
var PORT_MAX = 1124;

var updateUnchained = new XMLHttpRequest();
var abort = false;
var port = PORT_MIN;
var address = LOCAL_HOST;
var operation = METHOD_GET;
var permAllowing = true;
var permAllowed = false;
var permissions = 0;
updateUnchained.onreadystatechange = function() {
    if (updateUnchained.readyState == 4) {
        if (updateUnchained.status == 200) {
            if (!updateUnchained.responseText.localeCompare('close')) {

                if (!abort)
                    console.log('JSunchained: Stopped!');
                abort = true;
                return;
            }
            var reply = JSON.parse(updateUnchained.responseText);
            if (typeof reply.permission != 'undefined') {
                if (reply.permission.allowed != 0) { // Wait user allows permission(s)

                    permAllowed = (reply.permission.allowed == 1)? true:false;
                    permissions = reply.permission.mask;
                    permAllowing = false;
                    console.log('JSunchained: Permission ' + ((permAllowed)? 'allowed':'not allowed'));
                }
            }
            else if (typeof reply.camera != 'undefined') {

                unchained.camera.playing = (!reply.camera.playing)? false:true;
                console.log('JSunchained: Camera ' + ((unchained.camera.playing)? 'started':'stopped') + '!');
            }
            else { // ...add feature event in JSON reply below (e.i Bluetooth connection event)

                unchained.sensors.accel.x = reply.accel.x;
                unchained.sensors.accel.y = reply.accel.y;
                unchained.sensors.accel.z = reply.accel.z;
            }
        }
        else if (unchained.connected) { // No reply

            console.log('JSunchained: Disconnected!');
            unchained.connected = false;
            port = PORT_MIN;
        }
    }
};

var connCount = 3;

var connChgCam = false;
var connRdyCam = false;

var noConnCam = false;
var camData = true;
// Needed when trying to start camera without connection yet & security

var varPerm = 0;
var varLoop = 0;
var varCam = 0;
function process() { updateUnchained.send(); }
function TO_BE_REPLACED_WITH_KEY(request, data) {

    if (abort)
        return;

    switch (request) {
        case UNCHAINED_REQ_PERMISSION: {

            updateUnchained.open(operation, address + 'permission/' + unchained.permission + '_' + varPerm, false);
            if (!varPerm) varPerm = 1;
            else varPerm = 0;
            process();
            break;
        }
        case UNCHAINED_REQ_SENSORS: {

            connRdyCam = connChgCam;
            connChgCam = false;

            updateUnchained.open(operation, address + varLoop + '/' + connCount, false);
            if (!varLoop) varLoop = 1;
            else varLoop = 0;
            process();
            break;
        }
        case UNCHAINED_REQ_CAMERA: {

            if ((!unchained.connected) || (permAllowing)) {
                noConnCam = true;
                camData = (data)? true:false;
                return;
            }
            noConnCam = false;
            if (!(permissions & UNCHAINED_PERM_CAMERA)) {
                console.log("JSunchained: Missing 'UNCHAINED_PERM_CAMERA' permission");
                return;
            }
            if (!permAllowed) {
                console.log("JSunchained: Camera permission not allowed");
                return;
            }
            if ((data) && (!connChgCam) && (!connRdyCam)) {

                ++connCount;
                connChgCam = true;
                return;
            }
            connRdyCam = false;
            console.log('JSunchained: ' + ((data)? 'Start':'Stop') + ' camera...');
            updateUnchained.open(operation, address + 'camera/' + ((data)? 'start':'stop') + varCam, false);
            if (!varCam) varCam = 1;
            else varCam = 0;
            process();
            break;
        }
    }
}
window.requestUnchained = function() {
    return TO_BE_REPLACED_WITH_KEY(arguments[0], arguments[1]);
};

//////
function loopUnchained() {
    if (!unchained.connected) {

        address = LOCAL_HOST;
        var http = new XMLHttpRequest();
        try {

            http.open('HEAD', address + port + '/', false);
            http.send();
        }
        catch (e) { }
        if (http.status == 200) {

            unchained.connected = true;
            address += port + '/';
            if ((permAllowing) && (!unchained.permission))
                permAllowing = false;
            console.log('JSunchained: Connected!');
        }
        else if (++port > PORT_MAX)
            port = PORT_MIN;
    }
    else if (permAllowing)
        requestUnchained(UNCHAINED_REQ_PERMISSION);

    else {

        requestUnchained(UNCHAINED_REQ_SENSORS);
        if ((noConnCam) || (connChgCam) || (connRdyCam))
            requestUnchained(UNCHAINED_REQ_CAMERA, camData);
        else if (unchained.camera.playing)
            for (var i = 0; i < unchained.camera.imageArray.length; ++i)
                if (unchained.camera.imageArray[i].image.complete) {
                    unchained.camera.imageArray[i].element[unchained.camera.imageArray[i].imageAtt] = (!unchained.camera.imageArray[i].url)? unchained.camera.imageArray[i].image.src:'url("' + unchained.camera.imageArray[i].image.src + '")';
                    if (++unchained.camera.varArray[i] < 0)
                        unchained.camera.varArray[i] = 0;
                    unchained.camera.imageArray[i].image.src = address + 'camera/' + unchained.camera.varArray[i] + '.jpg';
                }
    }
    if (!abort)
        setTimeout(loopUnchained, LOOP_DELAY);
}
setTimeout(loopUnchained, 200);
console.log('JSunchained: Started!');

