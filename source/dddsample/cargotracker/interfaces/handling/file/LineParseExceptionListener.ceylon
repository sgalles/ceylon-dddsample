import ceylon.file {
	parsePath,
	Directory,
	Nil,
	Path,
	File
}

import dddsample.cargotracker.application.util {
	fail
}

import javax.batch.api.chunk.listener {
	SkipReadListener
}
import javax.batch.runtime.context {
	JobContext
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

String failedDirectoryName = "failed_directory";



dependent
named ("LineParseExceptionListener")
inject
shared class LineParseExceptionListener(Logger logger, JobContext jobContext)
		satisfies SkipReadListener {
	shared actual void onSkipReadItem(Exception parseException) {
		
		assert(is EventLineParseException parseException);
		
		logger.warn("Problem parsing event file line", parseException);	
		
		Path failedDirectoryPath = parsePath(jobContext.properties.getProperty(failedDirectoryName));
		Directory failedDirectory = switch(failedDirectoryResource = failedDirectoryPath.resource)
									case(is Nil) failedDirectoryResource.createDirectory(true)
									case(is Directory) failedDirectoryResource
									else fail<Directory>(()=>Exception("Unable to get or create directory ``failedDirectoryPath``"));
		
		
		value failedFileName = "failed_``jobContext.jobName``_``jobContext.instanceId``.csv";
		value failedFile = switch(failedFileResource = failedDirectory.childResource(failedFileName))
									case(is Nil) failedFileResource.createFile()
									case(is File) failedFileResource
									else fail<File>(()=>Exception("Unable to get or create file ``failedFileResource``"));
		
		try (writer = failedFile.Appender()) {
			writer.writeLine(parseException.line);
		}							
								
	}
}