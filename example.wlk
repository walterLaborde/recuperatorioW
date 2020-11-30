/** First Wollok example */
class Personaje {
	var property estrategia
	var property espiritualidad
	const property poderes = #{}
	
	method capacidadDeBatalla() {
		return poderes.sum({poder => poder.capacidadDeBatalla(self)})
	}
	
	method elMejorPoder() {
		return poderes.max({poder => poder.capacidadDeBatalla(self)})
	}
	
	method puedeAfrontarPeligro(peligro) {
		if(peligro.desechosRadiactivos())
		     {return self.capacidadMayorAPeligro(peligro) and self.manejaRadiactividad(peligro)}
		else 
		     {return self.capacidadMayorAPeligro(peligro)}
	}

	method capacidadMayorAPeligro(peligro) {
		return self.capacidadDeBatalla() > peligro.capacidadDeBatalla() 
	}
	
	method manejaRadiactividad(peligro) {
		return self.inmuneARadiacion()
	}
	
	method inmuneARadiacion() {
		return poderes.any({poder => poder.inmunidad()})
	}
	
	method afrontarPeligro(peligro) {
		self.validarQueLoPuedeEnfrentar(peligro)
		self.aumentarComplegidad(peligro)
	}
	
	method validarQueLoPuedeEnfrentar(peligro) {
		if(!self.puedeAfrontarPeligro(peligro)) {
			self.error(self.toString() + "no puede afrontarlo solo")
		}
	}
	method aumentarComplegidad(peligro) {
		estrategia += peligro.nivelDeComplegidad() 
	}

}

class Poder {
	
	method capacidadDeBatalla(personaje) {
		return (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje) 
	}
	
	method agilidad(personaje)
	
	method fuerza(personaje)
	
	method habilidadEspecial(personaje) {
		return personaje.espiritualidad() + personaje.estrategia()
	}
	
	method inmunidad()
}

class Velocidad inherits Poder {
	const rapidez
	
	override method agilidad(personaje) {
		return personaje.estrategia() * rapidez
	}
	
	override method fuerza(personaje) {
		return personaje.espiritualidad() * rapidez
	}
	
	override method inmunidad() {
		return false
	}

}

class Vuelo inherits Poder {
	const alturaMaxima
	const energiaParaDespegue
	
	override method agilidad(personaje) {
		return personaje.estrategia() * alturaMaxima / energiaParaDespegue
	}
	
	override method fuerza(personaje) {
		return personaje.espiritualidad() + alturaMaxima - energiaParaDespegue
	}
	
	override method inmunidad() {
		return alturaMaxima > 200
	}

}

class PoderAmplificador inherits Poder {
	const poderBase
	const amplificador
	
	override method agilidad(personaje) {
		return poderBase.agilidad(personaje)
	}
	
	override method fuerza(personaje) {
		return poderBase.fuerza(personaje)
	}
	
	override method habilidadEspecial(personaje) {
		return poderBase.habilidadEspecial(personaje) * amplificador
	}
	
	override method inmunidad() {
		return true
	}
}

class Equipo {
	const property personajes
	
	method miembroMasVulnerable() {
		return personajes.min({personaje => personaje.capacidadDeBatalla()})
	}
	
	method calidadDelEquipo() {
		return personajes.sum({personaje => personaje.capacidadDeBatalla()}) / personajes.size()
	}
	
	method mejoresPoderes() {
		return personajes.map({personaje => personaje.elMejorPoder()}).asSet()
	}
	
	method peligroSensato(peligro) {
		return personajes.all({personaje => personaje.puedeAfrontarPeligro(peligro)})
	}
	
	method afrontarPeligro(peligro) {
		const personajesCapaces = personajes.filter({personaje => personaje.puedeAfrontarPeligro(peligro)})
		self.validarPersonasParaAfrontar(peligro)
		personajesCapaces.forEach({personaje => personaje.aumentarComplegidad(peligro)})
	}
	
	method validarPersonasParaAfrontar(peligro) {
		const personasCapaces = personajes.count({personaje => personaje.puedeAfrontarPeligro(peligro)})
		if(personasCapaces <= peligro.personajesSimultaneos()) {
			self.error(self.toString() + " no cuenta con suficientes miembros para afrontar a " + peligro.toString())
		}
	}
	
}


class Peligro {
	
	const property capacidadDeBatalla
	const property desechosRadiactivos
	var property nivelDeComplegidad = 0
	var property personajesSimultaneos = 0
	
	
}

class Metahumano inherits Personaje {
	
	override method capacidadDeBatalla() {
		return super() * 2
	}
	
	override method manejaRadiactividad(peligro) {
		return true
	}
	
	override method aumentarComplegidad(peligro) {
		super(peligro)
		espiritualidad += peligro.nivelDeComplegidad()
	}
}

class Mago inherits Metahumano {
	var property poderAcumulado
	
	override method capacidadDeBatalla() {
		return super() + poderAcumulado
	}
	
	override method aumentarComplegidad(peligro) {
		if(poderAcumulado > 10) {
			super(peligro)
			poderAcumulado -= 5.max(0)
			}
		else {
			poderAcumulado -= 5.max(0)
			}
	}
	
}