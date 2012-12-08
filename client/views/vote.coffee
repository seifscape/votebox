## TEMPLATING

Template.vote.votes = ->
	vote = Votes.find({})

Template.vote.participants = ->
	validIdsArray = getValidVoteUserIds()
	return if not validIdsArray
	participants = Meteor.users.find(_id: {$in: validIdsArray})

Template.vote.email = ->
	this.emails[0].address

Template.vote.vote_status = ->
	userVote = findUserVote(this._id)
	if userVote.vote? then 'Voted!' else 'Waiting...'

Template.vote.has_vote = ->
	userVote = findUserVote(Meteor.userId())
	return userVote.vote? and Math.round(userVote.vote) is this.index


## EVENTS

Template.vote.events
	'click .vote-option': (evt) ->
		voteIndex = $(evt.target).attr('data-option-index')
		Meteor.call('setUserVote', Session.get('vote_id'), voteIndex);


## WORKING WITH VOTES AND USERS

findUserVote = (userId) ->
	return _.find Votes.findOne().users, (obj, index) ->
		return obj.id is userId

getValidVoteUserIds = ->
	vote = Votes.findOne()
	return if not vote
	return _.map vote.users, (obj, index) ->
		return obj.id