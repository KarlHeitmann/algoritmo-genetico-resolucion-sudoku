require 'awesome_print'
require_relative 'poblacion'

require 'byebug'

MAX_GEN = 10
TAMANIO_FILA = 9
POBLACION = 2

tablero = [
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

tablero_flat = tablero.flatten


def cruzar(papa, mama)
  genes_papa = papa.get_genotipo
  genes_mama = mama.get_genotipo

  return Individuo.new({ papa: genes_papa, mama: genes_mama})
end


def mutacion
end

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

i=0
individuos.each do |individuo|
  individuo.representar

  individuo.rellenar_casillas

  individuo.representar

  ap "Indiv #{i}: #{individuo.calcular_adaptacion_ponderada}"
end

hijo = cruzar(individuos[0], individuos[1])
hijo.representar
ap " hijo #{0}: #{hijo.calcular_adaptacion_ponderada}"

hijo.mutar
hijo.representar
ap " hijo #{0}: #{hijo.calcular_adaptacion_ponderada}"



def evaluacion_poblacion
end

def seleccion
end

def reproduccion
end

MAX_GEN.times do |i|
  #separa_elite
  seleccion
  reproduccion
  mutacion
  #incluye_elite
  evaluacion_poblacion
end

#ap tablero
#ap tablero_flat



