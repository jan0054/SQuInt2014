// JavaScript Document for common functions

  function getAllAuthor(inputStr)
  {
	Parse.initialize("PLlbyPCGMrfHvghx1sllgLmNRIwz00l7PHYZdAvd", "Qkfl1VnB7ksIXOQAT5sV5uPFVVCehOVUoSLC0pmx");
	ListItem = Parse.Object.extend("person");
	query = new Parse.Query(ListItem);
	query.descending('last_name');
	query.find({
		success: function(results){
			for (var i=0; i<results.length; i++){
				var object=results[i];
				var sel=document.getElementById(inputStr);
				if(i==0){
					var new_option = new Option(object.get('first_name'),object.id,1,1);
				}
				else
				{
					var new_option = new Option(object.get('first_name'),object.id);
				}
				sel.options.add(new_option);
				}
			},
		error: function(error)
		{
			alert("Author Error"+error.code);
		}
	})
  }

