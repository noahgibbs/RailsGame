// This assumes that Juggernaut and Prototype are also loaded properly

// First, some JavaScriptified Juggernaut functions.  These are translations
// of standard Ruby Juggernaut functionality.
function RG(options) {
  this.hasLogger = "console" in window && "log" in window.console
  this.options = options
}

RG.fn = RG.prototype;

RG.fn.logger = function(msg) {
    if (this.options.debug) {
	msg = "RailsGame: " + msg + " on " + Juggernaut.options.host + ":" + Juggernaut.options.port;
	this.hasLogger ? console.log(msg) : alert(msg);
    }
};

RG.fn.broadcast = function(body, type, client_ids, channels) {
    if (typeof(client_ids) == 'string') {
      client_ids = [ client_ids ]
    }
    if (typeof(channels) == 'string') {
      channels = [ channels ]
    }
    Juggernaut.fn.broadcast(body, type, client_ids, channels);
};

RG.fn.send_to_all = function(data) {
    RG.fn.broadcast(data)
};

RG.fn.send_to_channels = function(data, channels) {
    RG.fn.broadcast(data, 'to_channels', null, channels)
};

RG.fn.send_to_channel = RG.fn.send_to_channels;

RG.fn.send_to_clients = function(data, clients) {
    RG.fn.broadcast(data, 'to_clients', clients)
};

RG.fn.send_to_client = RG.fn.send_to_clients;

RG.fn.send_to_clients_on_channels = function(data, clients, channels) {
    RG.fn.broadcast(data, 'to_clients', clients, channels)
};

RG.fn.send_to_client_on_channel = RG.fn.send_to_clients_on_channels;
RG.fn.send_to_clients_on_channel = RG.fn.send_to_clients_on_channels;
RG.fn.send_to_client_on_channels = RG.fn.send_to_clients_on_channels;

//
// Now, some simple RailsGame helpers
//

RG.fn.send_action = function(aname, obj) {
    body = {client:Juggernaut.options.client_id, type:'action',
            verb:aname, objects:obj};
    RG.fn.send_to_client(body, 'gameserver');
};

RG.fn.replace_container_contents = function(container, contents) {
    $(container + "_data").innerHTML = contents;
};

RG.fn.append_to_container = function(container, contents) {
    $(container + "_data").innerHTML += contents;
};

RG.fn.prepend_to_container = function(container, contents) {
    obj = $(container + "_data");
    obj.innerHTML = contents + obj.innerHTML;
};

RG.fn.append_to_console = function(container, line) {
    obj = $(container + "_data");
    if(obj.max_lines) {
	if(!obj.current_lines) {
	    obj.current_lines = 0;
	}
	obj.current_lines++;

	if(obj.current_lines > obj.max_lines) {
	    obj.removeChild(obj.childnodes[0]);
	}
    }

    l = createElement("li");
    l.innerHTML = line;
    obj.appendChild(l);
}