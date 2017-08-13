require 'awesome_print'
MAX_GEN = 10

tablero = [
  [0,0,4,0,0,0,0,9,0],
  [7,0,0,0,6,0,0,0,5],
  [0,9,0,5,4,1,8,7,2],
  [0,0,0,1,8,7,0,4,0],
  [2,4,3,6,0,5,1,8,7],
  [0,8,0,3,2,4,0,0,0],
  [9,2,1,8,7,6,0,5,0],
  [6,0,0,0,1,0,0,0,8],
  [0,3,0,0,0,0,7,0,0],
]

tablero_flat = tablero.flatten

def evaluacion_poblacion

end

def seleccion
end

def reproduccion
end

def mutacion
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



