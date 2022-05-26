List<List<dynamic>> fractionate(List<dynamic> listing, int pieces){
	assert(listing.length > 3);
	var listingF = <List<dynamic>>[];
	var distribution = listing.length ~/ pieces;

	var start = 0;
	var end = distribution;
	while(true){
		
		List<dynamic>? segmentRange;
		if(start < listing.length){
			if(end < listing.length){
				segmentRange = listing.sublist(start, end);
			} else if(end >= listing.length) {
				segmentRange = listing.sublist(start, listing.length);
			}
		}

		if(segmentRange != null){
			listingF.add(segmentRange);
		} else {
			break;
		}

		start = end;
		end = end + distribution;
	}

	return listingF;
}

List<List<dynamic>> rowOfTwoInList(List<dynamic> listing){
	List<List<dynamic>> formatted = [];
	int firstIndex = 0;
	int secondIndex = 0;
	int trips = (listing.length / 2).round();
	for(int index=0; index<trips; index++){
		secondIndex = firstIndex + 1;
		if(firstIndex <= (listing.length - 2)){
			formatted.add([listing[firstIndex], listing[secondIndex]]);
		} else if(firstIndex == (listing.length -1)){
			formatted.add([listing[firstIndex]]);
			break;
		}
		firstIndex = secondIndex + 1;
	}

	return formatted;
}