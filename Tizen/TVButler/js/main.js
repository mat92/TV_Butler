var startTime;
var checkTime;
/**
 * Displays logging information on the screen and in the console.
 * 
 * @param {string}
 *            msg - Message to log.
 */
function log(msg) {
	var logsEl = document.getElementById('logs');

	if (msg) {
		// Update logs
		console.log('[MultiScreen]: ', msg);
		logsEl.innerHTML += msg + '<br />';
	} else {
		// Clear logs
		logsEl.innerHTML = '';
	}

	logsEl.scrollTop = logsEl.scrollHeight;
}

/**
 * Register keys used in this application
 */
function registerKeys() {
	var usedKeys = [ '0' ];

	usedKeys.forEach(function(keyName) {
		tizen.tvinputdevice.registerKey(keyName);
	});
}

/**
 * Handle input from remote
 */
function registerKeyHandler() {
	document.addEventListener('keydown', function(e) {
		switch (e.keyCode) {
		case 48:
			// Key 0: Clear logs
			log();
			break;
		case 13:
			// key Enter: show ime
			document.getElementById('message').focus();
			break;
		case 65376:
		case 65385:
			// Close IME
			if (channel !== null && channel.clients.length > 1
					&& e.target.value) {
				channel.publish('say', e.target.value);
				e.target.value = '';
			}
			e.target.blur();
			document.body.focus();
			break;
		// Key Return
		case 10009:
			tizen.application.getCurrentApplication().exit();
			break;
		}
	});
}

/**
 * Display application version
 */
function displayVersion() {
	var el = document.createElement('div');
	el.id = 'version';
	el.innerHTML = 'ver: ' + tizen.application.getAppInfo().version;
	document.body.appendChild(el);
}

var channel = null;

// this function adds a new <div> with message at the top
function echo(msg, parent) {
	var sp = document.createElement("div");
	var parent = document.querySelector("#msg > div");
	sp.innerHTML = msg;
	parent.insertBefore(sp, parent.firstChild.nextSibling);
}

/**
 * Displays logging information on the screen and in the console.
 * 
 * @param {string}
 *            msg - Message to log.
 */
function echo(msg) {
	var messagesEl = document.getElementById('messages');

	if (msg) {
		// Update message box
		console.log('[MultiScreen]: ', msg);
		messagesEl.innerHTML += msg + '<br />';
	} else {
		// Clear message box
		messagesEl.innerHTML = '';
	}

	messagesEl.scrollTop = messagesEl.scrollHeight;
}

var clients = [];

/**
 * Start the application once loading is finished
 */
window.onload = function() {

	if (window.tizen === undefined) {
		log('This application needs to be run on Tizen device');
		return;
	}

	displayVersion();
	registerKeys();
	registerKeyHandler();

	// Get a reference to the local "service"
	msf.local(function(err, service) {
		if (err) {
			echo('msf.local error: ' + err, logBox);
			return;
		}
		// Create a reference to a communication "channel"
		channel = service.channel('hackwerkstatt.7hack.tvbutler');
		window.channel = channel;
		// Connect to the channel
		channel.connect({
			name : "The TV"
		}, function(err) {
			if (err) {
				return console.error(err);
			}
			log('MultiScreen initialized, channel opened.');
		});

		// Add a message listener. This is where you will receive messages from
		// mobile devices
		channel.on('say', function(msg, from) {
			echo(from.attributes.name + ' says: <strong>' + msg + '</strong>');
		});

		// Add a listener for when another client connects, such as a mobile
		// device
		channel.on('clientConnect', function(client) {
			// Send the new client a message
			channel
					.publish('say', 'Hello ' + client.attributes.name,
							client.id);
			log("Let's welcome a new client: " + client.attributes.name);

			clients.push(client);
		});

		channel.on('changeToChannel', function(msg, from) {
			tuneUp();
		});
		
		// Add a listener for when a client disconnects
		channel.on('clientDisconnect',
				function(client) {
					var index = clients.indexOf(client);
					if (index > -1) {
						clients.splice(index, 1);
					}
					log("Sorry to see you go, " + client.attributes.name
							+ ". Goodbye!");
				});

		// Tell clients what channel is running
		function broadcast() {
			var clength = clients.length;
			for (var i = 0; i < clength; i++) {
				channel.publish('say', 'Hello ' + client.attributes.name,
						clients[i].id);
			}
		}
		var interval = setInterval(broadcast, 5000);
	});
}

function startTime() {
	var today = new Date();
	var h = today.getHours();
	var m = today.getMinutes();
	var s = today.getSeconds();
	m = checkTime(m);
	s = checkTime(s);
	document.getElementById('divbutton1').innerHTML = "Current time: " + h
			+ ":" + m + ":" + s;
	t = setTimeout(startTime, 250);
};

function checkTime(i) {
	if (i < 10) {
		i = "0" + i;
	}
	return i;
}
var tuneCB = {
	onsuccess : function() {
		console.log("Tune() is successfully done. And there is a signal.");
	},
	onnosignal : function() {
		console.log("Tune() is successfully done. But there is no signal.");
	}
};

function channelCB(channels) {
	console.log("getting channels is successful. " + channels.length
			+ " channels are retreived.");
	if (channels.length === 0) {
		console.log("There is no found channel.");
		return;
	}

	var channelDiv = document.getElementById("channelList");
	for (i = 0; i < channels.length; i++) {
		var p = document.createElement("p");
		p.setAttribute("class", "channellist");
		var text = document.createTextNode("channelName: "
				+ channels[i].channelName + "major: " + channels[i].major
				+ "minor: " + channels[i].minor);

		p.appendChild(text);
		channelDiv.appendChild(p);
	}

	/*try {
	    tizen.tvchannel.tune({major: channels[0].major}, tuneCB);
	} catch(error) {
	    console.log("Error name = "+ error.name + ", Error message = " + error.message);
	}*/
}

function errorCB(error) {
	console.log("Error name = " + error.name + ", Error message = "
			+ error.message);
}

function getChannels() {
	console.log("getChannel");

	try {
		// requests to get information about 10 channels.
		window.tizen.tvchannel.getChannelList(channelCB, errorCB, "ALL", 0);
	} catch (error) {
		console.log("Error name = " + error.name + ", Error message = "
				+ error.message);
	}

}

function getCurrentChannel() {
	return tizen.tvchannel.getCurrentChannel();
}

function printCurrentChannel() {

	var currentChannel = getCurrentChannel();

	if (currentChannel != null) {
		var currentChannelDiv = document.getElementById("currentChannel");

		var p = document.createElement("p");
		p.setAttribute("class", "channellist");
		var text = document.createTextNode("channelName: "
				+ currentChannel.channelName + "major: " + currentChannel.major
				+ "minor: " + currentChannel.minor);

		p.appendChild(text);
		currentChannelDiv.appendChild(p);

		console.log("current channel found")
	} else {
		console.log("error retreiving the current channel!");
	}
}

var tuneCB = {
	onsuccess : function() {
		console.log("tuneUp() is successfully done. And there is a signal.");
	},
	onnosignal : function() {
		console.log("tuneUp() is successfully done. But there is no signal.");
	}
};

function tuneUp() {
	tizen.tvchannel.tuneUp(tuneCB, null, "ALL");
}
