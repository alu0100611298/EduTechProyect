function memory(){

  var ROWS = 0;
  var COLS = 0;
  this.matriz = undefined;
  this.clicks = 0;
  this.lvl = 1;
  this.score = 0;
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
  this.level = function(lvl){
    if(lvl == "1"){
      ROWS = 4;
      COLS = 4;
    }
    else if(lvl == "2"){
      ROWS = 8;
      COLS = 4;
    }
    else if(lvl == "3"){
      ROWS = 6;
      COLS = 6;
    }
    else if(lvl == "4"){
      ROWS = 8;
      COLS = 6;
    }
    else if(lvl == "5"){
      ROWS = 8;
      COLS = 8;
    }
    this.lvl = lvl;
  }
  this.create_rand = function(){
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
  this.set_score_plus = function(){
    this.score += 30;
    $('#score>h1>span').html("" + this.score);
  }
  this.set_score_minus = function(){
    this.score -= 5;
    $('#score>h1>span').html("" + this.score);
  }
};
var mem = new memory();
var end = 0;

$(document).ready(function(){
  var level = $('#level').html();
  mem.level(level[level.length-1]);
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
  if($('#flipfront'+pair[0]).css('display') != 'none' && $('#flipfront'+pair[1]).css('display') != 'none'){
    $('#flipfront'+pair[0]).attr('data-check','true').removeAttr("onclick");
    $('#flipfront'+pair[1]).attr('data-check','true').removeAttr("onclick");
    mem.set_score_plus();
    end++;
  }
  else if(cont == 2){
    mem.set_score_minus();
  }
  if(end == (mem.rows()*mem.cols()/2)){
    $.post('/game/save',{score:mem.score, name:'memoria', level:mem.lvl}, function(){
      window.location.href = "/game";
    });
  }
}
