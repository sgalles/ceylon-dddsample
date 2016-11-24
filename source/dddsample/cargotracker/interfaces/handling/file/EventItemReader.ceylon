import java.io {
	RandomAccessFile,
	Serializable
}

import javax.batch.api.chunk {
	AbstractItemReader
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
import dddsample.cargotracker.application.util {

	fail
}
import ceylon.file {

	Path,
	Nil,
	Directory,
	parsePath
}

String uploadDirectoryName = "upload_directory";
String iso8601Format = "yyyy-MM-dd HH:mm";

dependent
named("EventItemReader")
inject
shared class EventItemReader(JobContext jobContext, Logger logger) extends AbstractItemReader(){
	
	variable EventFilesCheckpoint? checkpoint = null;
	variable RandomAccessFile? currentFile = null;
	
	shared actual void open(Serializable checkpoint){
		Path uploadDirectoryPath = parsePath(jobContext.properties.getProperty(uploadDirectoryName));
		Directory uploadDirectory = switch(failedDirectoryResource = uploadDirectoryPath.resource)
									case(is Nil) failedDirectoryResource.createDirectory(true)
									case(is Directory) failedDirectoryResource
									else fail<Directory>(()=>Exception("Unable to get or create directory ``uploadDirectoryPath``"));
		
	}
	
	shared actual Object readItem() => nothing;
	
	
	
}