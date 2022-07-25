package Connect.Local
{
//import Connection.json.JSON;

import Connect.Jsons.JSON;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class URLConnector
{
	private var _loader: URLLoader;

	private var _completeFunction: Function;
	private var _failFunction: Function;

	private var _arrQueue: Array;

	private var _isSending: Boolean;

	public function URLConnector() {
		init();
	}

	private function init(): void {
		_isSending = false;

		_loader = new URLLoader();
		_loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		_loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
	}

	public function send(path: String, onComplete: Function, onFail: Function, params: Object): void {
		var request: URLRequest;
		var requestVars: URLVariables;

		if (_isSending) {
			addQuery(path, onComplete, onFail, params);
			return;
		}

		requestVars = new URLVariables();
		if (params)
			for (var property: String in params)
				requestVars[property] = params[property];

		_completeFunction = onComplete;
		_failFunction = onFail;

		request = new URLRequest(path);
		request.data = requestVars;
		request.method = URLRequestMethod.POST;
		_loader.load(request);

		_isSending = true;
	}

	private function addQuery(path: String, onComplete: Function, onFail: Function, params: Object): void {
		var query: QueryParams;

		query = new QueryParams();
		query.path = path;
		query.onComplete = onComplete;
		query.onFail = onFail;
		query.params = params;

		(_arrQueue) ? _arrQueue.push(query) : _arrQueue = [query];
	}

	private function checkQuery(): void {
		var query: QueryParams;
		if (!_arrQueue || !_arrQueue.length) return;

		query = _arrQueue.shift();
		send(query.path, query.onComplete, query.onFail, query.params);
	}

	private function loadCompleteHandler(e: Event): void {
		trace(e.target.data);

		if (_completeFunction != null)
			_completeFunction(decode(e.target.data));

		_isSending = false;
		checkQuery();
	}

	private function loadErrorHandler(e: IOErrorEvent): void {
		trace(e.target.data);
		if (_failFunction != null)
			_failFunction(e.target.data);

		_isSending = false;
		checkQuery();
	}

	private function decode(str: String): Object {
		var result: Object;

		try {
			result = Connect.Jsons.JSON.decode(str);
		}
		catch (e: Error) {
			return null;
		}

		return result;
	}
}
}