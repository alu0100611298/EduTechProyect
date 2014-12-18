Edutech [![Build Status](https://travis-ci.org/Edu-Tech/EduTechProyect.svg?branch=master)](https://travis-ci.org/Edu-Tech/EduTechProyect)
=========
Sistemas y Tecnologías web
---------------------------

### Objetivo

El objetivo principal de esta aplicación web es crear un espacio, un portal, donde niños y no tan niños puedan registrarse para aprender jugando.
Esta red social estará dividida en 4 secciones principales:

1. Home

	Sección en la que se mostrarán las mejores puntuaciones del usuario y sus últimas notas (funcionalidad que explicaremos más tarde). Además, como en todas las demás secciones, encontraremos un menú en el que podremos acceder a un apartado de mensajeria para poder interactuar con otros usuarios de la aplicación. Dentro del menú también veremos notificiaciones, sección de ajustes de perfil y un botón para salir de la cuenta.

2. Notas

	Aquí el usuario podrá crear unas notas a modo de post-it por si necesitase apuntar cualquier cosa que necesite recordar. Estas notas podrán ser borradas en cualquier momento y contarán con un título, una descripción y la fecha en la que fue creada.

3. Juegos

	La sección más importante de nuestra aplicación. En este punto el usuario tiene la posibilidad de elegir entre 6 juegos que contemplan contenidos como el inglés, las matemáticas, juegos de memoria...etc, incluyendo (en ciertos juegos) un sistema de niveles separados por dificultad. Cada vez que juguemos a uno de estos juegos, conseguiremos una serie de puntos, los cuales quedarán registrados en las estadísticas, sección de la que hablaremos a continuación.

4. Estadísticas

	En este apartado de la página veremos una serie de gráficas que mostrarán un podio con los tres mejores jugadores de toda la web, las estadisticas de tus puntos y además un podio de los tres mejores jugadores de cada juego por separado.


###Funcionamiento

Hay dos formas posibles de ver el funcionamiento de la aplicación, una mediante la web, gracias a Heroku, y otra desde local.

1. Visualización en Heroku
    
    Para poder ver la aplicación en dicha plataforma, haz click [aquí].
    Una vez ahí registrate y ya podrás empezar a usar nuestra aplicación.

2. Visualización en local

    Primero se ha de clonar el repositorio de [github], de la siguiente forma: 
    
    ```sh
    user@ubuntu-hp:~$ git clone git@github.com:Edu-Tech/EduTechProyect.git
    ```
    Una vez clonado el repositorio, y situado en el directorio, ejecuta bundler:
    
    ```sh
    user@ubuntu-hp:~/my-tiny-url$ bundle install
    ```
    
    Una vez hecho todo lo anterior, procede a ejecutar *rake server*, y por defecto se empezará a ejecutar.
    
    Una vez en ejecución, abre el navegador y escribe en la barra de direcciones *localhost:9292* y accederás a la web de la aplicación:
    
    ![ejemplo navegador](https://raw.githubusercontent.com/Edu-Tech/EduTechProyect/master/public/img/ejemplo.jpg)
    
    
[aquí]:http://my-edutech.herokuapp.com
[github]:https://github.com/Edu-Tech/EduTechProyect

