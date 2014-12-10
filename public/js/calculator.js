function calculator(){
  this.max = 30;
  this.min = 1;
  this.operands = [0,0];
  this.operation = 0;
  this.result = 0;
  this.operations = ['+','-','x','÷'];
  this.options = [];

  Array.prototype.repeat = function(elem){
    for (var i in this)
      if (this[i] == elem) return true;
    return false;
  }

  this.random = function(){
    return Math.floor(Math.random() * (this.max - this.min) + this.min);
  }

  this.simple_random = function(){
    return Math.floor(Math.random() * (10-1) + 1);
  }

  this.create_game = function(){
    this.operation = this.operations[Math.floor(Math.random() * 4)];
    this.options = new Array(4);
    if(this.operation == '÷'){
      do{
        this.operands = [this.random(),this.random()];
      }while(this.operands[0]%this.operands[1] != 0 || this.operands[0] < this.operands[1])
      for(var i=0; i<this.options.length; i++){
        var rand = [];
        do{
          rand = [this.random(),this.random()];
        }while(rand[0]%rand[1] != 0 || rand[0] < rand[1] || this.options.repeat(rand) || this.operation == rand);
        this.options[i] = rand;
      }
    }
    else{
      this.operands = [this.random(),this.random()];
      for(var i=0; i<this.options.length; i++){
        var rand = 0;
        do{
          rand = [this.random(),this.random()];
        }while(this.options.repeat(rand) || rand == this.operands);
        this.options[i] = rand;
      }
    }
    if(this.operation == '+'){
      this.result = this.operands[0] + this.operands[1];
      for(var i=0; i<this.options.length; i++){
        this.options[i] = this.options[i][0] + this.options[i][1];
      }
    }
    else if(this.operation == '-'){
      this.result = this.operands[0] - this.operands[1];
      for(var i=0; i<this.options.length; i++){
        this.options[i] = this.options[i][0] - this.options[i][1];
      }
    }
    else if(this.operation == 'x'){
      this.result = this.operands[0] * this.operands[1];
      for(var i=0; i<this.options.length; i++){
        this.options[i] = this.options[i][0] * this.options[i][1];
      }
    }
    else if(this.operation == '÷'){
      this.result = this.operands[0] / this.operands[1];
      for(var i=0; i<this.options.length; i++){
        this.options[i] = this.options[i][0] / this.options[i][1];
      }
    }
    this.options[Math.floor(Math.random() * 4)] = this.result;
  }

  this.create_table = function(){
    var table = $('#matriz');
    table.append('<div class="big"><div class="vcenter" id="or' + String(this.result).split(".").join("") + '">' + this.operands[0] + " " + this.operation + " " + this.operands[1] + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ String(this.options[0]).split(".").join("") + '" onclick="check(' + String(this.options[0]).split(".").join("")+','+this.result + ')">' + this.options[0] + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ String(this.options[1]).split(".").join("") + '" onclick="check(' + String(this.options[1]).split(".").join("")+','+this.result + ')">' + this.options[1] + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ String(this.options[2]).split(".").join("") + '" onclick="check(' + String(this.options[2]).split(".").join("")+','+this.result + ')">' + this.options[2] + '</div></div>');
    table.append('<div class="small"><div class="vcenter" id="'+ String(this.options[3]).split(".").join("") + '" onclick="check(' + String(this.options[3]).split(".").join("")+','+this.result + ')">' + this.options[3] + '</div></div>');
  }
}
var calc = new calculator();
var cont = 0;
var score = 0;
$(document).ready(function(){
  calc.create_game();
  calc.create_table();
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
        calc.create_game();
        calc.create_table();
      },1000);
    }
    else{
      setTimeout(function(){
        $.post('/game/save',{score:score, name:'calculator'}, function(){
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