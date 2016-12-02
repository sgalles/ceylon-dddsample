import dddsample.pathfinder.internal {
	GraphDao
}

import java.util {
	Random,
	JList=List,
	JArrayList=ArrayList,
	Date,
	Collections
}
import java.lang{
	JString=String
}

import javax.ejb {
	stateless
}
import javax.inject {
	inject=inject__FIELD
}
import javax.ws.rs {
	path,
	get,
	produces,
	queryParam
}

import dddsample.cargotracker.infrastructure.ceylon {

	toJavaList
}

Integer oneMinMs = 1000 * 60;
Integer oneDayMs = oneMinMs * 60 * 24;


path("/graph-traversal")
shared class GraphTraversalService() {
	
	inject
	late GraphDao dao;
	Random random = Random();
	
	get
	path("/shortest-path")
	produces({"application/json", "application/xml; qs=.75"})
	shared TransitPaths findShortestPath(
		queryParam("origin") JString originUnLocode,
		queryParam("destination") JString destinationUnLocode,
		queryParam("deadline") JString deadline
	){
		variable Date date = nextDate(Date());
		
		variable JList<String> allVertices = toJavaList(dao.locations);
		allVertices.remove(originUnLocode);
		allVertices.remove(destinationUnLocode);
		
		value candidateCount = randomNumberOfCandidates();
		JList<TransitPath> candidates = JArrayList<TransitPath>(candidateCount);
		for(i in 0:candidateCount){
			allVertices = randomChunkOfLocations(allVertices);
			JList<TransitEdge> transitEdges = JArrayList<TransitEdge>(allVertices.size() - 1);
			String firstLegTo = allVertices.get(0);
			variable Date fromDate = nextDate(date);
			variable Date toDate = nextDate(fromDate);
			date = nextDate(toDate);
			
			transitEdges.add(TransitEdge(
				dao.voyageNumber(),
				originUnLocode.string, firstLegTo, fromDate, toDate));
			for(j in 0:allVertices.size() - 1){
				String current = allVertices.get(j);
				String next = allVertices.get(j + 1);
				fromDate = nextDate(date);
				toDate = nextDate(fromDate);
				date = nextDate(toDate);
				transitEdges.add(TransitEdge(dao.voyageNumber(), current, next, fromDate, toDate));
			}
			
			String lastLegFrom = allVertices.get(allVertices.size() - 1);
			fromDate = nextDate(date);
			toDate = nextDate(fromDate);
			transitEdges.add(TransitEdge(
				dao.voyageNumber(),
				lastLegFrom, destinationUnLocode.string, fromDate, toDate));
			
			candidates.add(TransitPath(transitEdges));
		}
		
		return TransitPaths(candidates);
	}
	
	Date nextDate(Date date) => Date(date.time + oneDayMs
		+ (random.nextInt(1000) - 500) * oneMinMs);
	
	Integer randomNumberOfCandidates() => 3 + random.nextInt(3);
	
	JList<String> randomChunkOfLocations(JList<String> allLocations){
		Collections.shuffle(allLocations);
		value total = allLocations.size();
		value chunk = if(total > 4) then 1 + Random().nextInt(5) else total;
		return allLocations.subList(0, chunk);
	}
		
	
}