express = require 'express'
levenshtein = require './levenshtein.js'
svc = express()
yelp = require('yelp').createClient({
	consumer_key : 'fnAIzIA5cLF6NSl_Lr7Hbw'#process.env.YELP_CONSUMER_KEY,
	consumer_secret : '-lbNbJtdQJLIqW7AtV1xUfP5tBY'#process.env.YELP_CON_SECRET,
	token : 'SkTYgQkbdmG6zgWIMqWpMHgiA-sudkEn'#process.env.YELP_TOKEN
	token_secret : '8actk2saU1JKQ2MfjDceow_Jzuw'#process.env.YELP_TOKEN_SECRET
	})

console.log "created clients"

max_discrepancy = 10
toLowerNoParens= (str) ->
	str.replace(/(\(.+?\))*/gim, '').trim().toLowerCase()

isMatch = (l, r) ->
	prepared = (str) ->
		toLowerNoParens(str).replace(/[-'*]*/gim, "").replace(/restraunt/g, "").trim()
	levenshtein.getEditDistance(prepared(l), prepared(r)) < max_discrepancy

svc.get '/', (req, resp) ->
	resp.contentType 'application/json'
	toError = (e) -> {error: e}

	searchTerm = req.query['s']
	locationTerm = req.query['l']
	hasError = false
	error = toError ""
	
	accumulateError = (e, str) ->
		e.error = e.error + str

	if searchTerm?
		searchTerm = toLowerNoParens searchTerm
	else
		hasError = true
		accumulateError(error, 'No search term defined')
	
	if locationTerm?
		locationTerm = toLowerNoParens locationTerm
	else
		hasError = true
		accumulateError(error, 'No location Term defined')

	if hasError
		resp.send(error)
		return

	params = 
		location: locationTerm
		sort: 0
		term: searchTerm
		limit: 10


	yelp.search params, (error, data) ->
		if error
			resp.send(toError error)
			return

		clip = (biz) ->
			name: biz.name
			rating: biz.rating
			reviewCount: biz.review_count
			ratingImg: biz.rating_img_url_small
			url: biz.url

		matches = (clip business for business in data.businesses when isMatch(business.name, searchTerm))
		
		if matches.length is 0
			result = toError 'No matching yelp business'
		else
			result = matches[0]

		resp.send(result)		

console.log "opening port"
port = process.env.PORT || 8080
svc.listen port, ->
	console.log 'started up!!!'



