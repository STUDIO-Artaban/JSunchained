/* Created by Pascal VIGUIE on 11/15/2015.
   Copyright (c) 2015 - STUDIO Artaban.
   All rights reserved. */

'use strict';
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

