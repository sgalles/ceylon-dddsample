import javax.xml.bind.annotation {
    xmlRootElement
}

import java.util { JList=List }

xmlRootElement
shared class TransitPaths(transitPath) {

    shared JList<TransitPath> transitPath;

}