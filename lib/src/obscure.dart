String obscureText(String text){
	var obscured = '';
	for(var index=0; index<text.length; index++){
		obscured += '*';
	}

	return obscured;
}