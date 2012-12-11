# Vote Helper Functions

findVoteCreatorEmail = (voteId) ->
	vote = if voteId then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote?
	creator = Meteor.users.findOne({_id: vote.creator_id})
	return creator.emails[0].address

findUserVote = (userId, voteId) ->
	vote = if voteId then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote?
	return _.find vote.users, (obj, index) ->
		return obj.id is userId

getValidUsers = (voteId) ->
	vote = if voteId then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote
	return vote.users

getValidVoteUserIds = ->
	validUsers = getValidUsers()
	validIds = _.pluck validUsers, 'id'

areAllVotesIn = () ->
	allVotes = getValidUsers()
	return  _.every allVotes, (user) ->
		user.vote?

tabulateVotes = ->
	allUsers = getValidUsers()
	allVotes = _.pluck allUsers, 'vote'

	sortedVotes = _.sortBy allVotes, (val) ->
		return Math.round(val)

	# Create a vote totals array with the necessary length
	voteTotals = []
	for i in [0..._.max(sortedVotes)+1]
		voteTotals.push(0)

	_.each sortedVotes, (vote) ->
		unless not vote?
			voteTotals[vote] += 1

	return voteTotals

doesMajorityVoteExist = ->
	voteTotals = tabulateVotes()
	numUsers = getValidUsers().length
	return _.max(voteTotals) >= Math.ceil(numUsers / 2)
