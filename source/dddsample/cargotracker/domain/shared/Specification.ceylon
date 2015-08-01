shared interface Specification<Testable> {
	
	shared formal Boolean isSatisfiedBy(Testable t);
	
	shared formal Specification<Testable> and(Specification<Testable> specification);
	
	shared formal Specification<Testable> or(Specification<Testable> specification);
	
	shared formal Specification<Testable> not(Specification<Testable> specification);
	
}

shared abstract class AbstractSpecification<Testable>() satisfies Specification<Testable> {
	
	shared formal actual Boolean isSatisfiedBy(Testable t);
	
	shared actual Specification<Testable> and(Specification<Testable> specification) 
			=> AndSpecification(this, specification);
	
	shared actual Specification<Testable> or(Specification<Testable> specification) 
			=> OrSpecification(this, specification);
	
	shared actual Specification<Testable> not(Specification<Testable> specification) 
			=> NotSpecification(specification);
	
	
}

shared class AndSpecification<Testable>(Specification<Testable> spec1, Specification<Testable>spec2) 
		extends AbstractSpecification<Testable>(){
	
	shared actual Boolean isSatisfiedBy(Testable t) 
			=> spec1.isSatisfiedBy(t) && spec2.isSatisfiedBy(t);
	
}

shared class OrSpecification<Testable>(Specification<Testable> spec1, Specification<Testable>spec2) 
		extends AbstractSpecification<Testable>(){
	
	shared actual Boolean isSatisfiedBy(Testable t) 
			=> spec1.isSatisfiedBy(t) || spec2.isSatisfiedBy(t);
	
}

shared class NotSpecification<Testable>(Specification<Testable> spec1) 
		extends AbstractSpecification<Testable>(){
	
	shared actual Boolean isSatisfiedBy(Testable t) 
			=> !spec1.isSatisfiedBy(t);
	
}