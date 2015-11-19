import javax.enterprise.inject {
	produces=produces__GETTER
}
import javax.persistence {
	persistenceContext=persistenceContext__SETTER,
	EntityManager
}
class DatasourceProducer() {
	
	suppressWarnings("unusedDeclaration")
	produces
	persistenceContext
	late EntityManager entityManager;
	
	
	
}