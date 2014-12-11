function colors(){
  this.color = 0;
  this.colors = ['Blue','Black','Orange','Purple','Brown','Green','Red','Yellow','Pink','White','Gray'];
  this.options = [0,0,0,0];
  this.states = [];

  Array.prototype.repeat = function(elem){
    for (var i in this)
      if (this[i] == elem) return true;
    return false;
  }

  this.create_game = function(){
    do{
      this.color = Math.floor(Math.random() * 10);
    }while(this.states.repeat(this.color));

    this.states.push(this.color);
    
    for(var i=0; i<this.options.length; i++){
      var rand = 0;
      do{
        rand = Math.floor(Math.random() * 10);
      }while(this.options.repeat(rand) || rand == this.color);
      this.options[i] = rand;
    }
    this.options[Math.floor(Math.random() * 4)] = this.color;
  }

  this.create_table = function(){
    var table = $('#matriz');
    table.append('<div class="big"><div class="vcenter" id="or' + this.color + '"><img src="/img/games/colors/' + this.color + '.png"/></div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[0] + '" onclick="check(' + this.options[0]+','+this.color + ')">' + (this.colors[this.options[0]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[1] + '" onclick="check(' + this.options[1]+','+this.color + ')">' + (this.colors[this.options[1]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[2] + '" onclick="check(' + this.options[2]+','+this.color + ')">' + (this.colors[this.options[2]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[3] + '" onclick="check(' + this.options[3]+','+this.color + ')">' + (this.colors[this.options[3]]) + '</div></div>');
  }
}
var color = new colors();
var cont = 0;
var score = 0;
$(document).ready(function(){
  color.create_game();
  color.create_table();
});

function check(id,origin){
  if (id == origin){
    $('#or'+origin).parent().addClass('win');
    $('#'+id).parent().addClass('win');
    cont++;
    score += 10;
    if(cont < 5){
      setTimeout(function(){
        $('#matriz').html("");
        color.create_game();
        color.create_table();
      },1000);
    }
    else{
      setTimeout(function(){
        $.post('/game/save',{score:score, name:'colors'}, function(){
          window.location.href = "/game";
        });
      },1000);
      
    }
  }
  else{
    $('#or'+origin).parent().addClass('wrong');
    $('#'+id).parent().addClass('wrong');
    setTimeout(function(){
      $('#or'+origin).parent().removeClass('wrong');
      $('#'+id).parent().removeClass('wrong');
    },1000);
    score--;
  }
  $('#score>h1>span').html(score);
}