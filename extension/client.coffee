elements = $(".search-location")
location = elements[0].innerHTML

extractError = (error, business) ->
	biz = encodeURI business
	address = "http://yelp.com/search?find_desc=#{biz}"
	$(document.createElement 'a').attr({href: address, target: '_blank'}).html(error)

extractRatings = (rating, reviewCount, starsUrl, bizUrl) ->
	reviews = $(document.createElement 'a')
	reviews.attr {href: bizUrl, target: '_blank'}
	reviews.html "(#{reviewCount} reviews)"
	stars = $(document.createElement 'img')
	stars.attr {src: starsUrl, alt: rating}

	return {stars: stars, reviews: reviews}



search = (business, location, div) ->
	req = new XMLHttpRequest
	req.open "GET", "http://second-opinion.herokuapp.com/?s=#{business}&l=#{location}", true
	#req.open "GET", "http://localhost:8080/?s=#{business}&l=#{location}", true
	req.onreadystatechange = ->
		if req.readyState is 4
			res = $.parseJSON req.responseText
			console.log res
			if res.error?
				console.log "there was an error #{res.err}"
				failure = extractError(res.error, business)
			else
				ratings = extractRatings(res.rating, res.reviewCount, res.ratingImg, res.url)
				console.log ratings
				div.append ratings.stars
				div.append ratings.reviews
	req.send()		



		


# restraunts = $(".rest-name")
# for r in restraunts
# 	console.log r.innerHTML

results = $(".result")
for res in results
	name = $(res).find(".rest-name")[0].innerHTML
	div = $(res).find(".ratings-col")
	console.log location
	console.log name
	console.log  div

	search(name, location, div)

	# results = $(".result").find(".ratings-col")
	# for res in results
	# 	$(res).append("<span>Yelp Stuff</span>")
