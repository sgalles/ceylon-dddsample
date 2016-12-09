import javax.enterprise.context {
    applicationScoped
}
import javax.enterprise.inject {
    produces
}
import javax.enterprise.inject.spi {
    InjectionPoint
}

import org.slf4j {
    Logger,
    LoggerFactory
}

applicationScoped
shared class LoggerProducer() {
    suppressWarnings("unusedDeclaration")
    produces
    Logger createLogger(InjectionPoint ip)
            => LoggerFactory.getLogger(ip.member.declaringClass);
}