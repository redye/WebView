var Common = function () {
    
};
Common.webviewAppearEvent = 'webviewAppear';
Common.webviewDisappearEvent = 'webviewDisappear';
Common.applicationEnterBackgroundEvent = 'applicationEnterBackground';
Common.applicationEnterForegroundEvent = 'applicationEnterForeground';

// dataDic为Object对象
Common.nativeLog = function (dataDic) {
    var params = {};
    params.dataDic = dataDic;
    this.sendCommonMessage('nativeLog', params);
},
// traceData为字符串
Common.crashTrace = function (traceData) {
    var params = {};
    params.data = traceData;
    this.sendCommonMessage('crashTrace', params);
},
// 复制剪切板
Common.copyContent = function (content) {
    var params = {};
    params.str = content;
    this.sendCommonMessage('copyContent', params);
},
//获取设备一些通用信息
Common.getCommonParams = function (callback) {
    this.sendCommonMessage('commonParams', {}, callback);
},
// common模块的基础类，选用同样的 handler name => Common
Common.sendCommonMessage = function (action, params, callback) {
    var msgBody = {};
    msgBody.handler = 'Common';
    msgBody.action = action;
    msgBody.params = params;
    window.bridge.Core.sendMessage(msgBody, callback);
}
window.bridge.Common = Common;