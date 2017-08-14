require_relative 'poblacion'

#require 'byebug'

MAX_GEN = 10
TAMANIO_FILA = 9
POBLACION = 10
ELIMINAR = 2


TABLERO = [
  [0,0,4,0,0,0,0,9,0],
  [7,0,0,0,6,0,0,0,5],
  [0,9,0,5,4,1,8,7,2],
  [0,0,0,1,8,7,0,4,0],
  [2,4,3,6,0,5,1,8,7],
  [0,8,0,3,2,4,0,0,0],
  [9,2,1,8,7,6,0,5,0],
  [6,0,0,0,1,0,0,0,8],
  [0,3,0,0,0,0,7,0,0]
]

tablero_flat = TABLERO.flatten


def cruzar(papa, mama)
  genes_papa = papa.get_genotipo
  genes_mama = mama.get_genotipo

  return Individuo.new({ papa: genes_papa, mama: genes_mama})
end

def poblacion_inicial(tablero)
  individuos =  []
  POBLACION.times do |i|
    genes = []
    tablero.each do |f|
      casillas = []
      f.each do |e|
        if e == 0
          casillas << Casilla.new(0, false)
        else
          casillas << Casilla.new(e, true)
        end
      end
      genes << Cromosoma.new({ vector_casillas: casillas })
    end
    individuos << Individuo.new({genes: genes})
  end
  return individuos
end

def test
  individuos = poblacion_inicial TABLERO
  i=0
  individuos.each do |individuo|
    individuo.representar

    individuo.rellenar_casillas

    individuo.representar

    puts "Indiv #{i}: #{individuo.calcular_adaptacion_ponderada}"
  end

  hijo = cruzar(individuos[0], individuos[1])
  hijo.representar
  puts " hijo #{0}: #{hijo.calcular_adaptacion_ponderada}"

  hijo.mutar
  hijo.representar
  puts " hijo #{0}: #{hijo.calcular_adaptacion_ponderada}"
end

# Comienzo del algoritmo
#
# Se genera la poblacion inicial, a partir de los datos del tablero se proponen
# soluciones aleatorias, indicando cuales son las casillas fijas.
#

individuos = poblacion_inicial TABLERO
individuos.each do |indiv|
  indiv.rellenar_casillas
end

#
# Aqui comienzan las generaciones
#
MAX_GEN.times do |i|
  #
  # EVALUACION
  #
  # Se evaluan los individuos de esta generacion
  #
  total_puntuacion = 0.0
  total_acumulado  = 0.0

  individuos.each do |indiv|
    total_puntuacion += indiv.calcular_adaptacion_ponderada.to_f
  end
  individuos.each do |indiv|
    indiv.setear_puntuacion total_puntuacion
    total_acumulado = indiv.setear_puntuacion_acumulada total_acumulado
  end

  if i == 0
    puts "Tablero inicial, los ceros representan las casillas vacias"
    individuos.first.representar
    record = Float::INFINITY
    ganador = nil
    individuos.each do |indiv|
      if indiv.adaptacion < record
        record = indiv.adaptacion
        ganador = indiv
      end
    end

    puts ""
    puts "Mejor adaptacion inicial: #{record}"
    ganador.representar
  end

  #puts individuos.count

  puts "total puntuacion: " + total_puntuacion.to_s
  puts "total acumulado:  " + total_acumulado.to_s
  #
  # SELECCION
  #
  # Se selecciona por el metodo de la ruleta la cantidad ELIMINAR de individuos
  # de la poblacion. Son los que tienen mayor puntaje, ya que este problema es
  # de minimizacion.
  #
  # TODO: en la seleccion no hay un filtro realice un nuevo soteo si es que el
  # se repite el individuo a eliminar

  ELIMINAR.times do |i|
    sorteo = rand
    individuos.delete_if do |indiv|
      (sorteo > (indiv.puntuacion_acumulada - indiv.puntuacion) and (sorteo < indiv.puntuacion_acumulada))
    end
  end

  # puts individuos.count

  #
  # REPRODUCCION
  #
  # Se utiliza la funcion cruzar definida en este archivo para seleccionar
  # aleatoriamente dos individuos sobre los que generar descendencia.
  #

  ELIMINAR.times do |i|
    papa = rand(0...individuos.count)
    mama = rand(0...individuos.count)
    while (mama == papa) do
      mama = rand(0..individuos.count)
    end
    individuos << cruzar(individuos[papa], individuos[mama])
  end

  #
  # MUTACION
  #
  # Por ultimo, se recorre toda la poblacion y se invoca el metodo mutar de cada
  # individuo. Con una baja probabiliddad, el individuo mutara uno de sus genes
  #

  individuos.each do |indiv|
    indiv.mutar
  end
end

#
# EVALUACION FINAL
#
# Se evaluan los individuos de la ultima generacion
#
total_puntuacion = 0.0
total_acumulado  = 0.0

individuos.each do |indiv|
  total_puntuacion += indiv.calcular_adaptacion_ponderada.to_f
end
individuos.each do |indiv|
  indiv.setear_puntuacion total_puntuacion
  total_acumulado = indiv.setear_puntuacion_acumulada total_acumulado
end


record = Float::INFINITY
ganador = nil
individuos.each do |indiv|
  if indiv.adaptacion < record
    record = indiv.adaptacion 
    ganador = indiv
  end
end
puts ""
puts "Mejor adaptacion final: #{record}"
ganador.representar

