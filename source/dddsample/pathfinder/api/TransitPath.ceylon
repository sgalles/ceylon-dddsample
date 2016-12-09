import javax.xml.bind.annotation {
    xmlTransient
}

shared class TransitPath(transitEdges) {

    shared List<TransitEdge> transitEdges;

    assert (!transitEdges.empty);

    xmlTransient
    shared [TransitEdge+] transitEdgesSeq {
        assert (nonempty transitEdgesSeq = transitEdges.sequence());
        return transitEdgesSeq;
    }

}