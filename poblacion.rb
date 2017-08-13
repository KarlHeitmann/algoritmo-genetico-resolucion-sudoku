require 'awesome_print'

class Casilla
  attr_accessor :valor, :fija
  def initialize(_valor, _fija)
    @valor = _valor #Valor numerico de casilla
    @fija = _fija #Es una posicion inicial o no
  end
end

class Gen
  def initialize(_vector_casillas)
    @vector_casillas = []
    _vector_casillas.each do |casilla|
      if casilla.class == Casilla
        @vector_casillas << casilla
      else
        raise ErrorCrearCasilla
      end
      #@vector_casillas << Casilla.new(casilla.valor, casilla.fija)
    end
  end
end

class Individuo
  def initialize(_genes, _adaptacion, _puntuacion, _puntuacion_acumulada, _elite)
    @genes = []
    _genes.each do |gen|
      if gen.class == Gen
        @genes << gen
      elsif gen.class == Array
        @genes << Gen.new(gen)
      else
        raise ErrorCrearGen
      end
    end
    @adaptacion = _adaptacion
    @puntuacion = _puntuacion
    @puntuacion_acumulada = _puntuacion_acumulada
    @elite = _elite
  end
end

class Poblacion
  def initialize(_individuos)
    @individuos = []
    _individuos.each do |individuo|
      @individuos << individuo
    end
  end
end

puts "Casilla"
@cas_1 = Casilla.new(0, false)
ap @cas_1
@cas_2 = Casilla.new(0, false)
ap @cas_2
@cas_3 = Casilla.new(4, true)
ap @cas_3

@gen_1 = Gen.new([@cas_1, @cas_2, @cas_3])
@gen_2 = Gen.new([@cas_3, @cas_2, @cas_1])
@gen_3 = Gen.new([@cas_2, @cas_3, @cas_1])


puts "Genes"
indiv = Individuo.new([@gen_1, @gen_2, @gen_3], 2.3, 5.0, 3.0, false)
ap indiv



