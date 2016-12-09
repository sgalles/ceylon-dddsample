import javax.inject {
    qualifier
}

shared annotation CargoInspected cargoInspected() => CargoInspected();
shared final qualifier annotation class CargoInspected() 
        satisfies OptionalAnnotation<CargoInspected> {}