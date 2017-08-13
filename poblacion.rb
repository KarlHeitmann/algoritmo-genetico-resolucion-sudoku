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
  def representar
    i=1
    fila="| "
    @vector_casillas.each do |c|
      if (i%3) == 0
        fila += c.valor.to_s + " | "
      else
        fila += c.valor.to_s + " "
      end
      i+=1
    end
    puts fila
  end
end

class Individuo
  def initialize(params = {})
    _genes = params.fetch(:genes, nil)
    unless _genes.nil?
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
    else
      raise GenesInvalidos
    end
    @adaptacion = params.fetch(:adaptacion, 0.0)
    @puntuacion = params.fetch(:puntuacion, 0.0)
    @puntuacion_acumulada = params.fetch(:puntuacion_acumulada, 0.0)
    @elite = params.fetch(:elite, false)
  end
  def representar
    i = 1
    puts  "_________________________"
    @genes.each do |gen|
      puts "|       |       |       |"
      if (i%3) == 0
        gen.representar
        #puts "|       |       |       |"
        puts  "|_______|_______|_______|"
      else
        gen.representar
      end
      i += 1
    end
  end
  
end

class Poblacion
  def initialize(_individuos)
    @individuos = []
    _individuos.each do |individuo|
      if individuo.class == Individuo
        @individuos << individuo
      else
        raise ErrorCrearIndividuo
      end
    end
  end
end

if __FILE__ == $0

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
  indiv1 = Individuo.new({genes: [@gen_1, @gen_2, @gen_3], adaptacion: 2.3, puntuacion: 5.0, puntuacion_acumulada: 3.0, elite: true})
  indiv2 = Individuo.new({genes: [@gen_3, @gen_2, @gen_1]})

  indiv1.representar

=begin
  ap indiv1
  ap "-----"
  ap indiv2
=end
  #Individuo.new()

end


