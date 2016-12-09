import java.util {
	Random
}

import javax.enterprise.context {
	applicationScoped
}

applicationScoped
shared class GraphDao() {

	value random = Random();
	
	[String+] voyages = ["0100S", "0200T", "0300A", "0301S", "0400S"];

	shared [String+] locations
			= ["CNHKG", "AUMEL", "SESTO",
		       "FIHEL", "USCHI", "JNTKO", "DEHAM", "CNSHA", "NLRTM", "SEGOT",
		       "CNHGH", "USNYC", "USDAL"];

    shared String voyageNumber() {
		value i = random.nextInt(voyages.size);
		assert (exists number = voyages[i]);
        return number;
    }

}