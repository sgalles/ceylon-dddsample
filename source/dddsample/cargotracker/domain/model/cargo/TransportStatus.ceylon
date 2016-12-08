import ceylon.language.meta {
	type
}

shared class TransportStatus
	of not_received | in_port | onboard_carrier | claimed | unknown {

	shared new not_received {}
	shared new in_port {}
	shared new onboard_carrier {}
	shared new claimed {}
	shared new unknown {}
	
	shared String name => type(this).declaration.name;

}



