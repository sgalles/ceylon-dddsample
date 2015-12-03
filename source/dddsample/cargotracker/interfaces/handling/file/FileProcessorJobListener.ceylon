import java.util {
	Date
}

import javax.batch.api.listener {
	JobListener
}
import javax.enterprise.context {
	dependent
}
import javax.inject {
	named=named__TYPE,
	inject
}

import org.slf4j {
	Logger
}

dependent
named("FileProcessorJobListener")
inject
shared class FileProcessorJobListener(Logger logger) satisfies JobListener{
	
	afterJob() => logger.info("Handling event file processor batch job starting at ``Date()``");
	
	beforeJob() => logger.info("Handling event file processor batch job completed at ``Date()``");
	
}