import ceylon.language.meta {
	type
}
import ceylon.collection {

	HashMap
}
shared abstract class TransportStatus(shared String name) 
	of not_received | in_port | onboard_carrier | claimed | unknown {
	//shared String name => type(this).declaration.name;
}

shared object not_received extends TransportStatus("not_received") {}
shared object in_port extends TransportStatus("in_port") {}
shared object onboard_carrier extends TransportStatus("onboard_carrier") {}
shared object claimed extends TransportStatus("claimed") {}
shared object unknown extends TransportStatus("unknown") {}

shared TransportStatus?(String) getTransportStatusByName
		= HashMap{*`TransportStatus`.caseValues.map((ts) => ts.name->ts)}.get;

