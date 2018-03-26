window.bridge = function() {}

var Core = function () {

};

Core.ua = navigator.userAgent;
Core.isAndroid = (/(Android);?[\s\/]+([\d.]+)?/.test(Core.ua));
Core.isIOS = !!Core.ua.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
Core.msgCallbackMap = {};
Core.eventCallMap = {};

Core.onListenEvent = function (eventId, handler) {
    var handlerArr = this.eventCallMap[eventId];
    if (handlerArr === undefined) {
        handlerArr = [];
        this.eventCallMap[eventId] = handlerArr;
    }
    if (handler !== undefined) {
        handlerArr.push(handler);
    }
},

Core.eventDispatcher = function (eventId, resultJson) {
    var handlerArr = this.eventCallMap[eventId];
    for (var key in handlerArr) {
        if (handlerArr.hasOwnProperty(key)) {
            var handler = handlerArr[key];
            if (handler && typeof (handler) === 'function') {
                var resultObj = resultJson ? JSON.parse(resultJson) : {};
                handler(resultObj);
            }
        }
    }
}, 

Core.callbackDispatcher = function (callbackId, resultJson) {
    var handler = this.msgCallbackMap[callbackId];
    if (handler && typeof (handler) === 'function') {
        // JSON.parse(resultjson)
        console.log(resultJson);
        var resultObj = resultJson ? JSON.parse(resultJson) : {};
        handler(resultObj);
    }
},

Core.sendMessage = function (data,callback) {
    if (callback && typeof (callback) === 'function') {
        var callbackId = this.getNextCallbackID();
        this.msgCallbackMap[callbackId] = callback;
        data.callbackId = callbackId;
        data.callbackFunction = 'window.callbackDispatcher';
    }
    
    if (this.isIOS) {
        try {
            window.webkit.messageHandlers.Native.postMessage(data);
        }
        catch (error) {
            console.log('error native message');
        }
    }
    if (this.isAndroid) {
        try {
            prompt(JSON.stringify([data]));
        }
        catch (error) {
            console.log('error native message');
        }
    }
},

Core.getNextCallbackID = function() {
	// 时间戳 + 随机数
	var timestamp = Date.parse(new Date());
	var random = Math.random().toFixed(2) * 100;
	let callbackId = `${timestamp}${random}`;
	return callbackId;
}

window.bridge.Core = Core;

window.callbackDispatcher = function(callbackId, resultJson) {
    window.bridge.Core.callbackDispatcher(callbackId, resultJson);
}

window.eventDispatcher = function (eventId, resultJson) {
    window.bridge.Core.eventDispatcher(eventId, resultJson);
}

window.onListenEvent = function (eventId, handler) {
    window.bridge.Core.onListenEvent(eventId, handler);
}