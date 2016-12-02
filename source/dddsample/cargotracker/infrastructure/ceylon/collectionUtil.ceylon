
import java.util { 
	JList = List,
	JArrayList = ArrayList
 }
import ceylon.interop.java {

	JavaList
}
import ceylon.collection {

	ArrayList
}

shared JList<Element> toJavaList<Element>({Element*} elements)
	=> let (ceylonList = ArrayList{*elements}) 
       JArrayList<Element>(JavaList(ceylonList));