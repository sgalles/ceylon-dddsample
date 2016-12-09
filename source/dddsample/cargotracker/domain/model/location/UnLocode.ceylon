import javax.persistence {
    embeddable
}
"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
shared class UnLocode(String countryAndLocation){

    String unlocode = countryAndLocation.uppercased;

    shared String idString => unlocode;

    shared Boolean sameValueAs(UnLocode other)
            => this.unlocode == other.unlocode;

}