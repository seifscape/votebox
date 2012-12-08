Template.main.votes = ->
	Votes.find({})

Template.main.events =
	'click a': (evt) ->