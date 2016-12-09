import ceylon.collection {
    ArrayList
}
import ceylon.interop.java {
    CeylonList
}

import dddsample.pathfinder.internal {
    GraphDao
}

import java.util {
    Random,
    Date,
    Collections,
    Arrays
}

import javax.inject {
    inject
}
import javax.ws.rs {
    path,
    get,
    produces,
    queryParam
}

path("/graph-traversal")
shared class GraphTraversalService {

    static Integer oneMinMs = 1000 * 60;
    static Integer oneDayMs = oneMinMs * 60 * 24;

    shared new () {}

    inject
    late GraphDao dao;

    value random = Random();

    get
    path("/shortest-path")
    produces {"application/json", "application/xml; qs=.75"}
    shared TransitPaths findShortestPath(
        queryParam("origin") String originUnLocode,
        queryParam("destination") String destinationUnLocode,
        queryParam("deadline") String deadline
    ) {
        variable Date date = nextDate(Date());

        variable List<String> allVertices = [
            for (loc in dao.locations)
            if (!loc in [originUnLocode, destinationUnLocode])
            loc
        ];

        value candidateCount = randomNumberOfCandidates();
        value candidates = ArrayList<TransitPath>(candidateCount);
        for (i in 0:candidateCount) {
            allVertices = randomChunkOfLocations(allVertices);
            value transitEdges = ArrayList<TransitEdge>(allVertices.size-1);
            assert (exists firstLegTo = allVertices.first);
            variable Date fromDate = nextDate(date);
            variable Date toDate = nextDate(fromDate);
            date = nextDate(toDate);

            transitEdges.add(TransitEdge {
                voyageNumber = dao.voyageNumber();
                fromUnLocode = originUnLocode.string;
                toUnLocode = firstLegTo;
                fromDate = fromDate;
                toDate = toDate;
            });

            for (j in 0:allVertices.size-1) {
                assert (exists current = allVertices[j],
                        exists next = allVertices[j+1]);
                fromDate = nextDate(date);
                toDate = nextDate(fromDate);
                date = nextDate(toDate);
                transitEdges.add(TransitEdge {
                    voyageNumber = dao.voyageNumber();
                    fromUnLocode = current;
                    toUnLocode = next;
                    fromDate = fromDate;
                    toDate = toDate;
                });
            }

            assert (exists lastLegFrom = allVertices.last);
            fromDate = nextDate(date);
            toDate = nextDate(fromDate);
            transitEdges.add(TransitEdge {
                voyageNumber = dao.voyageNumber();
                fromUnLocode = lastLegFrom;
                toUnLocode = destinationUnLocode.string;
                fromDate = fromDate;
                toDate = toDate;
            });

            candidates.add(TransitPath(transitEdges));
        }

        return TransitPaths(candidates);
    }

    Date nextDate(Date date)
            => Date(date.time + oneDayMs
                + (random.nextInt(1000) - 500) * oneMinMs);

    Integer randomNumberOfCandidates() => 3 + random.nextInt(3);

    List<String> randomChunkOfLocations(List<String> allLocations) {
        value list = Arrays.asList(*allLocations);
        Collections.shuffle(list);
        value total = list.size();
        value chunk = total > 4 then 1 + random.nextInt(5) else total;
        return CeylonList(list.subList(0, chunk));
    }

}