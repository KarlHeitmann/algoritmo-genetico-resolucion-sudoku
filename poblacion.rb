require 'awesome_print'

PUNTO_DE_CRUCE = 4
PROBABILIDAD_MUTACION = 0.8

class Casilla
  attr_accessor :valor, :fija
  def initialize(_valor, _fija)
    @valor = _valor #Valor numerico de casilla
    @fija = _fija #Es una posicion inicial o no
  end
end

class Cromosoma
  def initialize(params = {})
    if params.has_key? :vector_casillas
      @vector_casillas = []
      params[:vector_casillas].each do |casilla|
        if casilla.class == Casilla
          @vector_casillas << casilla
        else
          raise ErrorCrearCasilla
        end
        #@vector_casillas << Casilla.new(casilla.valor, casilla.fija)
      end
    elsif (params.has_key?(:papa) && params.has_key?(:mama))
      @vector_casillas = []
      9.times do |i|
        if i < PUNTO_DE_CRUCE
          @vector_casillas << Casilla.new(params[:papa][i].valor, params[:papa][i].fija)
        else
          @vector_casillas << Casilla.new(params[:mama][i].valor, params[:mama][i].fija)
        end
      end
    else
      raise ErrorCrearCromosoma
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

  def find_fixed_nums
    results = []
    i = 0
    @vector_casillas.each do |c|
      if c.fija
        results << {valor: c.valor, indice: i}
      end
      i += 1
    end
    return results
  end

  def set_value(_val, _i)
    @vector_casillas[_i] = Casilla.new(_val, false) unless @vector_casillas[_i].fija
  end

  def show_casilla(i)
    return @vector_casillas[i]
  end


  def [](i)
    return @vector_casillas[i]
  end

end

class Individuo
  def initialize(params = {})
    if params.has_key? :genes
      @genotipo = []
      params[:genes].each do |gen|
        if gen.class == Cromosoma
          @genotipo << gen
        elsif gen.class == Array
          @genotipo << Cromosoma.new({ vector_casillas: gen})
        else
          raise ErrorCrearCromosoma
        end
      end
    elsif (params.has_key?(:papa) && params.has_key?(:mama))
      @genotipo = []
      9.times do |i|
        @genotipo << Cromosoma.new({papa: params[:papa][i], mama: params[:mama][i]})
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
    @genotipo.each do |gen|
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

  def rellenar_casillas
    entrada = []
    @genotipo.each do |gen|
      cambios = [1,2,3,4,5,6,7,8,9]
      fijos = gen.find_fixed_nums
      fijos.each do |n|
        cambios.delete_at(cambios.index(n[:valor]))
      end
      i = 0
      cambios.shuffle.each do |n|
        while gen[i].fija do
          i += 1
        end
        gen.set_value(n, i)
        i += 1
      end
    end
  end

  def get_genotipo
    return @genotipo
  end

  def mutar
    if rand < PROBABILIDAD_MUTACION
      #TODO al tirar los dados, el algoritmo no se fija si el segundo dado tiene
      #el mismo valor del primer dado. En ese caso cambia el numero por uno en
      #la misma posicion, lo que significa que no hay mutacion
      cromosoma = rand(0..8)
      k1 = true
      k2 = true
      until k1==false
        i1 = rand(0..8)
        k1 = @genotipo[cromosoma][i1].fija
        v1 = @genotipo[cromosoma][i1].valor
      end
      until k2==false
        i2 = rand(0..8)
        k2 = @genotipo[cromosoma][i2].fija
        v2 = @genotipo[cromosoma][i2].valor
      end
      @genotipo[cromosoma].set_value(v1, i2)
      @genotipo[cromosoma].set_value(v2, i1)
      #ap "mutacion cromosoma #{cromosoma}, posicion (#{i1}, #{i2})"
    end
  end

  def calcular_adaptacion_ponderada
    #
    # Calculo de columnas
    #
    # Restriccion de Sumas RS
    rsCuad =         [45, 45, 45, 45, 45, 45, 45, 45, 45]
    rpCuad =         [1, 1, 1, 1, 1, 1, 1, 1, 1]
    reaCuad =        [(1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a
    ]
    rsColumna =         [45, 45, 45, 45, 45, 45, 45, 45, 45]
    rpColumna =         [1, 1, 1, 1, 1, 1, 1, 1, 1]
    reaColumna =        [(1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a,
                         (1..9).to_a
    ]
    9.times do |i|
      9.times do |j|
        valor_casilla = @genotipo[j][i].valor

        rsColumna[i] -= valor_casilla
        rpColumna[i] = rpColumna[i] * valor_casilla
        reaColumna[i].delete_at(reaColumna[i].index(valor_casilla)) unless reaColumna[i].index(valor_casilla).nil?

        if (i < 3)
          if (j < 3)
            rsCuad[0] = rsCuad[0] - valor_casilla
            rpCuad[0] = rpCuad[0] * valor_casilla
            reaCuad[0].delete_at(reaCuad[0].index(valor_casilla)) unless reaCuad[0].index(valor_casilla).nil?
          elsif (j < 6)
            rsCuad[1] = rsCuad[1] - valor_casilla
            rpCuad[1] = rpCuad[1] * valor_casilla
            reaCuad[1].delete_at(reaCuad[1].index(valor_casilla)) unless reaCuad[1].index(valor_casilla).nil?
          elsif (j < 9)
            rsCuad[2] = rsCuad[2] - valor_casilla
            rpCuad[2] = rpCuad[2] * valor_casilla
            reaCuad[2].delete_at(reaCuad[2].index(valor_casilla)) unless reaCuad[2].index(valor_casilla).nil?
          end
        elsif (i < 6)
          if (j < 3)
            rsCuad[3] = rsCuad[3] - valor_casilla
            rpCuad[3] = rpCuad[3] * valor_casilla
            reaCuad[3].delete_at(reaCuad[3].index(valor_casilla)) unless reaCuad[3].index(valor_casilla).nil?
          elsif (j < 6)
            rsCuad[4] = rsCuad[4] - valor_casilla
            rpCuad[4] = rpCuad[4] * valor_casilla
            reaCuad[4].delete_at(reaCuad[4].index(valor_casilla)) unless reaCuad[4].index(valor_casilla).nil?
          elsif (j < 9)
            rsCuad[5] = rsCuad[5] - valor_casilla
            rpCuad[5] = rpCuad[5] * valor_casilla
            reaCuad[5].delete_at(reaCuad[5].index(valor_casilla)) unless reaCuad[5].index(valor_casilla).nil?
          end
        elsif (i < 9)
          if (j < 3)
            rsCuad[6] = rsCuad[6] - valor_casilla
            rpCuad[6] = rpCuad[6] * valor_casilla
            reaCuad[6].delete_at(reaCuad[6].index(valor_casilla)) unless reaCuad[6].index(valor_casilla).nil?
          elsif (j < 6)
            rsCuad[7] = rsCuad[7] - valor_casilla
            rpCuad[7] = rpCuad[7] * valor_casilla
            reaCuad[7].delete_at(reaCuad[7].index(valor_casilla)) unless reaCuad[7].index(valor_casilla).nil?
          elsif (j < 9)
            rsCuad[8] = rsCuad[8] - valor_casilla
            rpCuad[8] = rpCuad[8] * valor_casilla
            reaCuad[8].delete_at(reaCuad[8].index(valor_casilla)) unless reaCuad[8].index(valor_casilla).nil?
          end
        end

      end
      rpColumna[i] = (362880 - rpColumna[i]).abs
      rsColumna[i] = rsColumna[i].abs
    end
    9.times do |i|
      rsCuad[i] = rsCuad[i].abs
      rpCuad[i] = (362880 - rpCuad[i]).abs
    end
    rea = 0
    9.times do |i|
      rea += reaCuad[i].inject(:+) unless reaCuad[i].empty?
      rea += reaColumna[i].inject(:+) unless reaColumna[i].empty?
    end
    rs = rsCuad.inject(:+) + rsColumna.inject(:+)
    rp = rpCuad.inject(:+) + rpColumna.inject(:+)

    return (5*rs) + rp + (20*rea)
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

  @gen_1 = Cromosoma.new({ vector_casillas: [@cas_1, @cas_2, @cas_3]})
  @gen_2 = Cromosoma.new({ vector_casillas: [@cas_3, @cas_2, @cas_1]})
  @gen_3 = Cromosoma.new({ vector_casillas: [@cas_2, @cas_3, @cas_1]})


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


