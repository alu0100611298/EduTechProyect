$(document).ready(function ()
{
	var score = 0;
	var areas = 0;
	$('#map1').mapster({
		singleSelect : false,
		fill : true, altImage : IMAGE,
		fillOpacity : 1,
		highlight: false,
		onClick: verify,
	});
	function verify(data){
		if($("#b" + COLORS[data.key] + ">input:checked").val() == "on"){
			if($('#map1').mapster('get',data.key) == false)
				score += 5;
			$('#map1').mapster('set',false,data.key,{fillOpacity: 1,});
			$("#score").html(score);
			areas += 1;
		}
		else{
			if($('#map1').mapster('get',data.key) == false)
				score -= 1;
			$("#score").html(score);
			$('#map1').mapster('set',true,{fillOpacity: 0});
		}
		if (areas == COLORS.length){
			end(score);
		}
	}
	function end(score){
		$('label[for="color"]').remove();
	}
});
function change_color(color){
	var inputs = $('label[for="color"]>span>input');
	var imgs = $('label[for="color"]>span>img');
	var actual = $('label[for="color"]>span#'+color+">input");
	$(inputs).each(function(){
		if(actual[0] != this){
			$(this).attr('checked',false);
			var src = $(this).parent().find("img").attr("src");
			src = src.split('/');
			src[3] = "64x64";
			src = src.join("/");
			$(this).parent().find("img").attr('src',src);
		}
		else{
			$('#'+color+">input").attr('checked',true);
			var src = $('#'+color+">img").attr("src");
			var src = src.split('/');
			src[3] = "100x100";
			src = src.join("/");
			$('#'+color+">img").attr('src',src);
		}
	});
}