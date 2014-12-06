function numbers(){
  this.LIMIT = 20;
  this.number = 0;
  this.numbers = ['One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen','Twenty'];
  this.options = [];

  Array.prototype.repeat = function(elem){
    for (var i in this)
      if (this[i] == elem) return true;
    return false;
  }

  this.create_game = function(){
    this.number = Math.floor(Math.random() * this.LIMIT);
    this.options = new Array(4);
    for(var i=0; i<this.options.length; i++){
      var rand = 0;
      do{
        rand = Math.floor(Math.random() * this.LIMIT);
      }while(this.options.repeat(rand) && rand == this.number);
      this.options[i] = rand;
    }
    this.options[Math.floor(Math.random() * 4)] = this.number;
  }

  this.create_table = function(){
    var table = $('#matriz');
    table.append('<div class="big"><div class="vcenter" id="or' + this.number + '">' + (this.number+1) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[0] + '" onclick="check(' + this.options[0]+','+this.number + ')">' + (this.numbers[this.options[0]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[1] + '" onclick="check(' + this.options[1]+','+this.number + ')">' + (this.numbers[this.options[1]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[2] + '" onclick="check(' + this.options[2]+','+this.number + ')">' + (this.numbers[this.options[2]]) + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ this.options[3] + '" onclick="check(' + this.options[3]+','+this.number + ')">' + (this.numbers[this.options[3]]) + '</div></div>');
  }
}
var num = new numbers();
var cont = 0;
var score = 0;
$(document).ready(function(){
  num.create_game();
  num.create_table();
});

function check(id,origin){
  if (id == origin){
    $('#or'+origin).addClass('win');
    $('#'+id).addClass('win');
    cont++;
    score++;
    if(cont < 5){
      setTimeout(function(){
        $('#matriz').html("");
        num.create_game();
        num.create_table();
      },1000);
    }
    else{
      setTimeout(function(){
        $.post('/game/save',{score:score, name:'numbers'}, function(){
          window.location.href = "/game";
        });
      },1000);
      
    }
  }
  else{
    $('#or'+origin).addClass('wrong');
    $('#'+id).addClass('wrong');
    setTimeout(function(){
      $('#or'+origin).removeClass('wrong');
      $('#'+id).removeClass('wrong');
    },1000);
    score--;
  }
  $('#score>h1>span').html(score);
}