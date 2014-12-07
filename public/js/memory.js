function memory(){

  var ROWS = Math.floor(Math.random() * (9-4) + 4);
  var COLS = 0;
  this.matriz = undefined;
  this.clicks = 0;
  Array.prototype.repeat = function(elem){
    var cont = 0;
    for (var i in this){
      if (this[i] == elem)
        cont++;
    }
    if (cont == 2) return true;
    return false;
  }
  Array.prototype.posequal = function(value){
    var a = -1;
    var b = -1;
    for (var i in this){
      if (this[i] == value)
        a = i;
    }
    for (var i in this){
      if (this[i] == value && i != a)
        b = i;
    }
    return [a,b];
  }
  this.create_rand = function(){
    do{
      COLS = Math.floor(Math.random() * (9-3) + 3);
    }while(ROWS*COLS%2 != 0)
    matriz = new Array(ROWS*COLS);
    var folders = ['animals','flags','sports']
    var folder = Math.floor(Math.random() * 3);
    for(var i=0; i<ROWS; i++){
      for(var j=0; j<COLS; j++){
        var rand = 0;
        do{
          rand = Math.floor(Math.random() *(ROWS*COLS/2));
        }while(matriz.repeat(rand));
        matriz[i*COLS+j] = rand;
      }
    }
    var table = $('#matriz');
    table.css("background","url(/img/games/memory/"+folders[folder]+".jpg) fixed center center no-repeat");
    table.css("background-size","cover");
    for(var i=0; i<ROWS; i++){
      var row = $("<div class='matriz rows'></div>");
      for(var j=0; j<COLS; j++){
        row.append("<div id='flipfront" + (i*COLS+j) + "' class='front matriz columns col-"+ROWS+"' onclick='flip("+(i*COLS+j)+")'><img class='thumb' src='/img/games/memory/" + folders[folder] + "/" + matriz[i*COLS+j] + ".png'/></div>");
        row.append("<div id='flipback" + (i*COLS+j) + "' class='back matriz columns col-"+ROWS+"' onclick='unflip("+(i*COLS+j)+")'><img class='thumb' src='/img/games/memory/back.png'/></div>");
      }
      table.append(row);
    }
  }
  this.check = function(value){
    return matriz.posequal(value);
  }
  this.matriz_pos = function(pos) {
    return matriz[pos];
  }
  this.rows = function() {
    return ROWS;
  }
  this.cols = function() {
    return COLS;
  }
  this.set_clicks = function() {
    this.clicks += 1;
  }
  this.get_clicks = function() {
    return this.clicks;
  }
};
var mem = new memory();
var end = 0;

$(document).ready(function(){
  mem.create_rand();
});

function flip(id){
  $('#flipfront'+id).addClass('front');
  $('#flipback'+id).removeClass('front');
}
function unflip(id){
  $('#flipfront'+id).removeClass('front');
  $('#flipback'+id).addClass('front');
  var pair = mem.check(mem.matriz_pos(id));
  mem.set_clicks();
  if($('#flipfront'+pair[0]).css('display') != 'none' && $('#flipfront'+pair[1]).css('display') != 'none'){
    $('#flipfront'+pair[0]).attr('data-check','true').removeAttr("onclick");
    $('#flipfront'+pair[1]).attr('data-check','true').removeAttr("onclick");
    end++;
  }
  var cont = 0;
  for(var i=0; i<mem.rows(); i++){
    for(var j=0; j<mem.cols(); j++){
      if($('#flipfront'+(i*mem.cols()+j)).css('display') != 'none' && $('#flipfront'+(i*mem.cols()+j)).attr('data-check') == undefined){
        cont++;
      }
    }
  }
  if(cont == 2){
    setTimeout(function(){
      for(var i=0; i<mem.rows(); i++){
        for(var j=0; j<mem.cols(); j++){
          if($('#flipfront'+(i*mem.cols()+j)).css('display') != 'none' && $('#flipfront'+(i*mem.cols()+j)).attr('data-check') == undefined){
            flip(i*mem.cols()+j);
          }
        }
      }
    },500);
  }
  if(end == (mem.rows()*mem.cols()/2)){
    var plus = (mem.get_clicks()-(mem.rows()*mem.cols()));
    var final_score = (mem.rows()*mem.cols())*10 - plus*5;
    $('#score>h1>span').html(final_score);
    $.post('/game/save',{score:final_score, name:'memoria'}, function(){
      window.location.href = "/game";
    });
  }
}
