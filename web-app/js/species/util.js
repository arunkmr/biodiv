/**
 * 
 */

$(function() {
	var spt = $('span.mailme');
	var at = /\(at\)/;
	var dot = /\(dot\)/g;
	$(spt).each(function() {
		var addr = $(this).text().replace(at, "@").replace(dot, ".");
		$(this).after(
				'<a href="mailto:' + addr + '" title="Send an email">' + addr
						+ '</a>').hover(function() {
			window.status = "Send an email!";
		}, function() {
			window.status = "";
		});
		$(this).remove();	
	});
	
});

function getBackgroundPos(obj) {
	var pos = obj.css("background-position");
	if (pos == 'undefined' || pos == null) {
		pos = [obj.css("background-position-x"),obj.css("background-position-y")];//i hate IE!!
	} else {
		pos = pos.split(" ");
	}
	return {
		x: parseFloat(pos[0]),
		xUnit: pos[0].replace(/[0-9-.]/g, ""),
		y: parseFloat(pos[1]),
		yUnit: pos[1].replace(/[0-9-.]/g, "")
	};
}

// to convert http to link
function dcorateCommentBody(comp){
	//var text = $(comp).text().replace(/\n\r?/g, '<br />');
	//$(comp).html(text);
	$(comp).linkify();
	
}

function updateRelativeTime(){
	$('.timeago').timeago('refresh');
}

//to show relative date
//function updateRelativeTime(currentTime){
//	//toRelativeTime('.activityfeed .timestamp', currentTime);
//}
//
//function getRelativeTime(diff) {
//	  var v = Math.floor(diff / 86400); diff -= v * 86400;
//	  if (v > 0) return (v == 1 ? 'Yesterday' : v + ' days ago');
//	  v = Math.floor(diff / 3600); diff -= v * 3600;
//	  if (v > 0) return v + ' hour' + (v > 1 ? 's' : '') + ' ago';
//	  v = Math.floor(diff / 60); diff -= v * 60;
//	  if (v > 0) return v + ' minute' + (v > 1 ? 's' : '') + ' ago';
//	  return 'Just now';
//}
//
//function toRelativeTime(s, currentTime) { 
//		$(s).each(function() {
//			var t = $(this);
//			var creationTime = $(t).children('input[name="creationTime"]').val();
//			var x = Math.round(parseInt(creationTime) / 1000);
//			if (x){ 
//			  $(t).children('span').text(getRelativeTime(Math.round(parseInt(currentTime) / 1000) - x));
//			} 
//		}); 
//}
