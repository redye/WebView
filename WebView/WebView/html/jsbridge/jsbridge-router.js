var Router = function() {

}

Router.openLink = function(url) {
	var params = {};
	params.url = url;
	this.sendRouterMessage("openLink", params);
}

Router.sendRouterMessage = function(action, params, callback) {
	var msgBody = {};
    msgBody.handler = 'Router';
    msgBody.action = action;
    msgBody.params = params;
	window.bridge.Core.sendMessage(msgBody, callback);
}


window.bridge.Router = Router;