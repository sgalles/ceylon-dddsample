import javax.jms {
	MessageListener,
	Message
}

import org.slf4j {
	Logger
}
import javax.ejb {

	messageDriven,
	activationConfigProperty
}
import javax.inject {
	inject=inject__FIELD
}


messageDriven{ activationConfig = {
	activationConfigProperty{
		propertyName = "destinationType"; 
		propertyValue = "javax.jms.Queue";},
		activationConfigProperty{
			propertyName = "destinationLookup"; 
			propertyValue = "java:global/jms/MisdirectedCargoQueue";}
		};
		messageListenerInterface=`MessageListener`;
}

shared class MisdirectedCargoConsumer() satisfies MessageListener{
	
	inject
	late Logger logger;
	
	shared actual default void onMessage(Message message) {
		logger.info("Received JMS message: ``message``");
	}
}

messageDriven{ activationConfig = {
	activationConfigProperty{
		propertyName = "destinationType"; 
		propertyValue = "javax.jms.Queue";},
		activationConfigProperty{
			propertyName = "destinationLookup"; 
			propertyValue = "java:global/jms/DeliveredCargoQueue";}
		};
		messageListenerInterface=`MessageListener`;
	}
shared class DeliveredCargoConsumer() satisfies MessageListener{
	
	inject
	late Logger logger;
	
	shared actual default void onMessage(Message message) {
		logger.info("Received JMS message: ``message``");
	}
}


