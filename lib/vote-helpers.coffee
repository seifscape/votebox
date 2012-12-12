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

getValidVoteUsers = (voteId) ->
	vote = if voteId then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote?
	validIdsArray = _.pluck vote.users, 'id'
	return Meteor.users.find({_id: {$in: validIdsArray}})

getValidVoteUserIds = ->
	validUsers = getValidVoteUsers()
	validIds = _.pluck validUsers, 'id'

areAllVotesIn = () ->
	allVotes = getValidVoteUsers()
	return  _.every allVotes, (user) ->
		user.vote?

tabulateVotes = ->
	allUsers = getValidVoteUsers()
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
	numUsers = getValidVoteUsers().length
	return _.max(voteTotals) >= Math.ceil(numUsers / 2)
