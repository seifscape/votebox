## TEMPLATING

Template.admin.votes = ->
	vote = Votes.find({})

Template.admin.participants = ->
	Meteor.users.find()

Template.admin.email = ->
	this.emails[0].address

Template.admin.vote_options = ->


## EVENTS

Template.admin.events
	'click .vote-option': (evt) ->
		voteIndex = $(evt.target).attr('data-option-index')
		Meteor.call('setUserVote', Session.get('vote_id'), voteIndex);