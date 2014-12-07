function schools(){
  this.school = 0;
  this.schools = ['Bag','Notebook','Book','Pencil','Rubber','Map','Sharpener','Ruler','Compass','Board','Crayons','Playground','Scissors','Calculator','Paper','Clock'];
  this.options = [0,0,0,0];

  Array.prototype.repeat = function(elem){
    for (var i in this)
      if (this[i] == elem) return true;
    return false;
  }

  this.create_game = function(){
    this.school = Math.floor(Math.random() * 16);
    for(var i=0; i<this.options.length; i++){
      var rand = 0;
      do{
        rand = Math.floor(Math.random() * 16);
      }while(rand == this.school || this.options.repeat(rand));
      this.options[i] = rand;
    }
    this.options[Math.floor(Math.random() * 4)] = this.school;
  }

  this.create_table = function(){
    var table = $('#matriz');
    table.append('<div class="big"><div class="vcenter" id="or' + this.school + '"><img src="/img/games/school/' + this.school + '.png"/></div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[0] + '" onclick="check(' + this.options[0]+','+this.school + ')">' + (this.schools[this.options[0]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[1] + '" onclick="check(' + this.options[1]+','+this.school + ')">' + (this.schools[this.options[1]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[2] + '" onclick="check(' + this.options[2]+','+this.school + ')">' + (this.schools[this.options[2]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[3] + '" onclick="check(' + this.options[3]+','+this.school + ')">' + (this.schools[this.options[3]]) + '</div></div>');
  }
}
var school = new schools();
var cont = 0;
var score = 0;
$(document).ready(function(){
  school.create_game();
  school.create_table();
});

function check(id,origin){
  if (id == origin){
    $('#or'+origin).parent().addClass('win');
    $('#'+id).parent().addClass('win');
    cont++;
    score++;
    if(cont < 5){
      setTimeout(function(){
        $('#matriz').html("");
        school.create_game();
        school.create_table();
      },1000);
    }
    else{
      setTimeout(function(){
        $.post('/game/save',{score:score, name:'school'}, function(){
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