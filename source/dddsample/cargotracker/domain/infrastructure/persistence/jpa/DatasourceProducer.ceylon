import javax.enterprise.inject {
	produces__GETTER
}
import javax.persistence {
	persistenceContext__SETTER,
	EntityManager
}
class DatasourceProducer() {
	
	produces__GETTER
	persistenceContext__SETTER
	late EntityManager entityManager;
	
	
	
}