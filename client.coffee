elements = $(".search-location")
for e in elements
	console.log  e.innerHTML

location = elements[0]

extractError = (error, business) ->
	biz = encodeURI business
	address = "http://yelp.com/search?find_desc=#{biz}"
	$(document.createElement 'a').attr({href: address, target: '_blank'}).html(error)

extractRatings = (rating, reviewCount, starsUrl, bizUrl) ->
	reviews = $(document.createElement 'a')
	reviews.attr {href: bizUrl, target: '_blank'}
	reviews.html "(#{reviewCount} reviews)"

	return {stars: "<img src='#{starsUrl}' alt='#{rating}'></img>", reviews: reviews}



search = (business, location, div) ->
	req = new XMLHttpRequest
	req.open "GET", "https://second-opinion.herokuapp.com/?s=#{business}&l=#{location}", true
	req.onreadystateexchange = ->
		if req.readyState is 4
			res = $.parseJSON req.responseText
			if res.error?
				failure = extractError(res.error, business)
			else
				ratings = extractRatings(res.rating, res.reviewCount, res.ratingImg, res.url)
				div.append ratings.starsUrl
				div.append ratings.reviews
	req.send()		



		


# restraunts = $(".rest-name")
# for r in restraunts
# 	console.log r.innerHTML

results = $(".result")
for res in results
	name = $(res).find(".rest-name")[0].innerHTML
	div = $(res).find(".ratings-col")
	search(name, location, $(div))

	# results = $(".result").find(".ratings-col")
	# for res in results
	# 	$(res).append("<span>Yelp Stuff</span>")
