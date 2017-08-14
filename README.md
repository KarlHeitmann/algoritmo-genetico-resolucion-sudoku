# Algoritmo Genéico Simple: Solucionando SUDOKU

Este proyecto consiste en implementar un algoritmo genético para resolver
SUDOKU. El libro que contiene la explicación de este problema se titula
"Algoritmos Evolutivos Un enfoque práctico" de Lourdes Araujo y Carlos Cervigón,
editorial Alfaomega

[Enlace a Amazon](https://www.amazon.com/Algoritmos-Evolutivos-Enfoque-Practico-Spanish/dp/6077686298)

## Introducción

Un algoritmo genético se ve inspirado en la naturaleza, en la evolución. Existen
muchos problemas clásicos que se pueden resolver mediante esta técnica, y son
problemas de optimización cuya solución analítica es muy complicada, o tiene
muchas variables que no se pueden manejar o se desconocen.

Entre los problemas típicos están la búsqueda de camino más corto entre una
estación y otra de una red de metro, la planificación de horarios de clases
y salas en una Universidad, o la resolución de un SUDOKU.

## Objetivo

Principalmente, familiarizarse con Ruby y el trabajo en equipo usando Git. Este problema es la
excusa para que los programadores nuevos se ensucien las manos en un proyecto,
y se atrevan a explorar código ajeno.

Para quienes no conozcan bien los algoritmos evolutivos, aquí hay una lista de
cosas que pueden hacer para divertirse:

- Hacer una representación más bonita de los puzzles. Puede ser con una GUI,
    o usando ncurses.
- Permitir que el usuario ingrese parámetros para el sistema, por ejemplo: el
    tamaño de la población, cuantos individuos se eliminarán en cada generación,
    etc.
- Hacer de esta aplicación una gema, para distribuirla en la página de Rubygems.
- Traducir este proyecto al inglés, o ver una forma de que haya una versión en
    español y otra en inglés y que el usuario pueda escoger entre una u otra.
- Hacer sugerencias de cambios u objetivos al proyecto, ya sea haciendo un pull
    request para modificar este README, o abriendo un nuevo issue en la sección
    correspondiente de este repositorio.
- Refactorizar el código, crear algunas funciones más, o unas clases más que
    permitan ordenar un poco esto. Creo que el archivo main.rb me ha quedado un
    poco desordenado. También puedes eliminar las funciones que están deprecated
    (obsoletas).
- Hacer tests para este proyecto.

Para quienes estén algo familiarizados con los AE, pueden intentar algunas de
las cosas siguientes:

- He marcado algunas partes del código con la etiqueta TODO, la cuál indica
    algunas cosas que me faltaron hacer, más que nada relacionadas con la
    eficiencia, o algunos bugs
- Mejorar el algoritmo, o buscar unos parámetros mejores, ya que la solución del
    SUDOKU a la cuál llega esta versión deja bastante que desear.

## Funcionamiento

Hasta ahora tenemos dos archivos de código:
- main.rb
  Es el encargado de manejar el loop principal, en donde se crea la población
  inicial, y se itera la cantidad de generaciones definida como constante en ese
  archivo, en cada iteración se evalúa la población, se seleccionan los más
  adecuados, se cruzan los individuos mejor adaptados, y por último se
  introducen algunas mutaciones antes de continuar a la iteración siguiente

- poblacion.rb
  Es el que modela el problema, en este archivo se define la clase Individuo,
  Cromosoma y Casilla. Cada individuo tiene un vector arreglo de nueve
  cromosomas. Cada cromosoma representa una línea del SUDOKU, y cada cromosoma
  tiene a su vez 9 Casillas, en donde cada casilla tiene el valor del número
  y un booleano que indica si es una casilla fija o no (es decir, si es una
  casilla inicial del tablero, que no puede ser cambiada). El método más
  interesante de acá podría ser el **calcular_adaptacion_ponderada** de la clase
  Individuo, ya que ahí se evalúa qué tan buena es la solución del SUDOKU que
  ese individuo representa.

## Algunas reglas

Por ahora, este proyecto está en español, orientado a los programadores
hispanoparlantes. Nuestro idioma hace uso de tildes, pero vamos a tener que
omitirlas en los códigos fuentes, ya que dependiendo del editor que ocupen los
colaboradores, pueden tener algún problema con su intérprete de Ruby. No
obstante, en la documentación será importante escribir de forma correcta.

La belleza está en la simplicidad, intentemos mantener este código simple, sin
agregar muchas gemas. De esta forma, para los nuevos en Ruby será más fácil
integrarse al proyecto.

