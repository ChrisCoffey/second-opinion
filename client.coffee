class yelpOAuthClient
	consumerKey = 'fnAIzIA5cLF6NSl_Lr7Hbw'
	consumerSecret = '-lbNbJtdQJLIqW7AtV1xUfP5tBY'
	token = 'SkTYgQkbdmG6zgWIMqWpMHgiA-sudkEn'
	tokenSecret = '8actk2saU1JKQ2MfjDceow_Jzuw'
	signatureMethod = 'hmac-sha1'
	
	search : (rterm, rlocation) ->
		parameters ={
			oauth_consumer_key : consumerKey
			oauth_token : token
			oauth_nonce : '12345GFDSA'
			oauth_timestamp : new Date()
			oauth_signature_method : signatureMethod
			oauth_version: 2
			term: rterm
			location: rlocation
		}
		method = 'GET'
		reqUrl = 'http://api.yelp.com/v2/search'
		encodedSignature = oauthSignature.generate(method, reqUrl, parameters, consumerSecret, tokenSecret)
		
		$.ajax({ 
			url: reqUrl
			type: method
			data: 'term=#{ rterm }&location=#{ rlocation }&oauth_consumer_key=#{oauth_consumer_key}&oauth_token=#{oauth_token}&oauth_signature_method=#{oauth_signature_method}&oauthSignature=#{encodedSignature}&oauth_timestamp=#{parameters.oauth_timestamp}&oauth_nonce=#{parameters.oauth_nonce}'
			success: (d) ->
				console.log d 
			})

class yelpRestClient
	baseURL : 'http://www.yelp.com/search/?'
	search : (business, location) ->
		dest = 'find_desc=#{business}'
		loc = 'find_loc=#{location}'
		

elements = $(".search-location")
for e in elements
	console.log  e.innerHTML

restraunts = $(".rest-name")
for r in restraunts
	console.log r.innerHTML


results = $(".result").find(".ratings-col")
for res in results
	$(res).append("<span>Yelp Stuff</span>")
	c.search("Tico", "Boston")	