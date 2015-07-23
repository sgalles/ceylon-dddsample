import java.io {
	Serializable
}

import javax.faces.view {
	viewScoped
}
import javax.inject {
	named__TYPE
}


named__TYPE
viewScoped
shared class Track() satisfies Serializable{
	
	shared variable String? trackingId = null;
	shared variable CargoTrackingViewAdapter? cargo = null;
	shared void onTrackById(){
		print("On try by id ``trackingId else nothing``");
	}
	
}