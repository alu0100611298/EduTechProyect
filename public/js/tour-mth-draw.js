function tour(){
  $('#tour1').grumble({
    text: 'Este es el panel de colores', 
    angle: 85, 
    distance: 50,
    showAfter: 500,
    hasHideButton: true,
    onHide: function () { 
      $('#tour3').grumble({
        text: 'Cada área tiene una operación, resuelvela y busca el número en el panel de colores',
        angle: 0, 
        distance: 50,
        showAfter: 500,
        hasHideButton: true,
        onHide: function () { 
          $('#tour2').grumble({
            text: 'Por ejemplo 19-4 = 15',
            angle: 0, 
            distance: 50,
            showAfter: 500,
            hasHideButton: true,
            onHide: function () { 
              $('#b0').grumble({
                text: 'Haremos click en 15',
                angle: 90, 
                distance: 0,
                showAfter: 500,
                hasHideButton: true,
                onHide: function () { 
                  $('#map1').grumble({
                    text: 'Y pinchamos en el área',
                    angle: 90, 
                    distance: 0,
                    showAfter: 500,
                    hasHideButton: true,
                    onHide: function () { 
                      $('#score').grumble({
                        text: 'Empieza a jugar!!',
                        angle: 30, 
                        distance: 0,
                        showAfter: 500,
                        hideAfter: 2500
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    }
  });
}