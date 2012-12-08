## TEMPLATING

Template.vote.votes = ->
	vote = Votes.find({})

Template.vote.participants = ->
	Meteor.users.find()

Template.vote.email = ->
	this.emails[0].address

Template.vote.vote_status = ->
	userVote = findUserVote(this._id)
	if userVote.vote? then 'Voted!' else 'Waiting...'

Template.vote.has_vote = ->
	userVote = findUserVote(Meteor.userId())
	return userVote.vote? and Math.round(userVote.vote) is this.index

Template.vote.are_all_votes_in = ->
	allVotes = getValidUsers()
	return  _.every allVotes, (user) ->
		user.vote?

Template.vote.is_winner = ->
	voteTotals = tabulateVotes()
	maxVoteIndex = voteTotals.indexOf(_.max(voteTotals))
	return maxVoteIndex is this.index

## EVENTS

Template.vote.events
	'click .vote-option': (evt) ->
		voteIndex = $(evt.target).attr('data-option-index')
		Meteor.call('setUserVote', Session.get('vote_id'), voteIndex);