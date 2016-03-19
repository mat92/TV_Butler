var startTime;
var checkTime;

//Initialize function
var init = function () {
    // TODO:: Do your initialization job
    console.log("init() called");
    
    document.addEventListener('visibilitychange', function() {
        if(document.hidden){
            // Something you want to do when hide or exit.
        } else {
            // Something you want to do when resume.
        }
    });
 
    // add eventListener for keydown
    document.addEventListener('keydown', function(e) {
    	switch(e.keyCode){
    	case 37: //LEFT arrow
    		break;
    	case 38: //UP arrow
    		break;
    	case 39: //RIGHT arrow
    		break;
    	case 40: //DOWN arrow
    		break;
    	case 13: //OK button
    		break;
    	case 10009: //RETURN button
    		break;
    	default:
    		console.log("Key code : " + e.keyCode);
    		break;
    	}
    });
};
// window.onload can work without <body onload="">
window.onload = init;

function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    m = checkTime(m);
    s = checkTime(s);
    document.getElementById('divbutton1').innerHTML="Current time: " + h + ":" + m + ":" + s;
    t = setTimeout(startTime, 250);
}

function checkTime(i) {
    if (i < 10) {
        i="0" + i;
    }
    return i;
}

var tuneCB = {
      onsuccess: function() {
          console.log("Tune() is successfully done. And there is a signal.");
      },
      onnosignal: function() {
          console.log("Tune() is successfully done. But there is no signal.");
      }
  };

function channelCB(channels) {
  console.log("getting channels is successful. " + channels.length + " channels are retreived.");
  if (channels.length === 0 ) {
      console.log("There is no found channel.");
      return;
  }
  
  var channelDiv = document.getElementById("channelList");
  for(i = 0; i < channels.length; i++) {
	  var p = document.createElement("p");
	  var text = document.createTextNode(
			  "channelName: " + channels[i].channelName +
			  "major: " + channels[i].major +
			  "minor: " + channels[i].minor
	  );
	  
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
	console.log("Error name = "+ error.name + ", Error message = " + error.message);
}


function getChannels() {
	try {
	      // requests to get information about 10 channels.
	      tizen.tvchannel.getChannelList(channelCB, errorCB, "ALL", 0);
	  } catch (error) {
	      console.log("Error name = "+ error.name + ", Error message = " + error.message);
	  } 
}

function getCurrentChannel() {
	return tizen.tvchannel.getCurrentChannel();
}

function printCurrentChannel() {
	try {
	var currentChannel = getCurrentChannel();
	}
	catch(error) {
		console.log(error);
	}
	
	if(currentChannel != null) {
		var currentChannelDiv = document.getElementById("currentChannel");
		
		
		
		var p = document.createElement("p");
		var text = document.createTextNode(
				  "channelName: " + currentChannel.channelName +
				  "major: " + currentChannel.major +
				  "minor: " + currentChannel.minor
		  );
		
		p.appendChild(text);
		currentChannelDiv.appendChild(p);
		
		console.log("current channel found")
	}
	else {
		console.log("error retreiving the current channel!");
	}
}