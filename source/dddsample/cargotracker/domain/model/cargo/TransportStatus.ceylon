

shared class TransportStatus
	of not_received | in_port | onboard_carrier | claimed | unknown {

	shared actual String string;

	shared new not_received {string="not_received";}
	shared new in_port {string="in_port";}
	shared new onboard_carrier {string="onboard_carrier";}
	shared new claimed {string="claimed";}
	shared new unknown {string="unknown";}

}



