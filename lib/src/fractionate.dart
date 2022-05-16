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