import ceylon.file {
	File
}


shared class EventFilesCheckpoint() {
	
	shared variable {File*} files = {};
	shared variable Integer fileIndex = 0;
	shared variable Integer filePointer = 0;
	
	shared File? currentFile => files.getFromFirst(fileIndex);
	
	shared File? nextFile() {
		filePointer = 0;
		fileIndex++;
		return currentFile;
	}
	
}