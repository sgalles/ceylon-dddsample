import javax.batch.operations {
	JobOperator
}
import javax.batch.runtime {
	BatchRuntime
}
import javax.ejb {
	stateless,
	schedule
}
stateless
shared class UploadDirectoryScanner() {
	
	schedule{minute = "*/2"; hour = "*";}
	shared default void processFiles(){
		JobOperator jobOperator = BatchRuntime.jobOperator;
		jobOperator.start("EventFilesProcessorJob", null);
	}
}