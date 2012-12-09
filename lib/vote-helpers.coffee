## WORKING WITH VOTES AND USERS

findUserVote = (userId) ->
	vote = Votes.findOne()
	return if not vote?
	return _.find vote.users, (obj, index) ->
		return obj.id is userId

getValidUsers = ->
	vote = Votes.findOne()
	return if not vote
	return vote.users

getValidVoteUserIds = ->
	validUsers = getValidUsers()
	validIds = _.pluck validUsers, 'id'

tabulateVotes = ->
	voteTotals = []
	allUsers = getValidUsers()
	allVotes = _.pluck allUsers, 'vote'
	sortedVotes = _.sortBy allVotes, (val) ->
		return Math.round(val)

	_.each sortedVotes, (vote) ->
		unless not vote?
			voteTotals.push(0) if not voteTotals[vote] 
			voteTotals[vote] += 1

	return voteTotals
