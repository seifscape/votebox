## TEMPLATING

Template.vote.votes = ->
	votes = Votes.find()

Template.vote.participants = ->
	Meteor.users.find()

Template.vote.creator_email = ->
	findVoteCreatorEmail()

Template.vote.email = ->
	this.emails[0].address

Template.vote.has_user_voted = ->
	userVote = findUserVote(this._id)
	return userVote? and userVote.vote?

Template.vote.has_vote = ->
	userVote = findUserVote(Meteor.userId())
	return if not userVote
	return userVote.vote? and Math.round(userVote.vote) is this.index

Template.vote.is_winner = ->
	return if not areAllVotesIn()
	voteTotals = tabulateVotes()
	maxVoteIndex = voteTotals.indexOf(_.max(voteTotals))
	return maxVoteIndex is this.index and doesMajorityVoteExist()

## EVENTS

Template.vote.events
	'click .vote-option': (evt) ->
		voteIndex = Math.round($(evt.target).attr('data-option-index'))
		Meteor.call('setUserVote', Session.get('vote_id'), Meteor.userId(), voteIndex);