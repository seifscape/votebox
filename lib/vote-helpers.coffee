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
	vote = if voteId? then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote?
	validIdsArray = _.pluck vote.users, 'id'
	return Meteor.users.find({_id: {$in: validIdsArray}})

getUsersForVote = (voteId) ->
	vote = if voteId? then Votes.findOne({_id: voteId}) else Votes.findOne()
	return if not vote?
	return vote.users

getValidVoteUserIds = (voteId) ->
	validUsers = getValidVoteUsers(voteId)
	return if not validUsers?
	validIds = _.pluck validUsers.fetch(), '_id'

areAllVotesIn = () ->
	allVotes = getUsersForVote()
	return  _.every allVotes, (user) ->
		user.vote?

tabulateVotes = ->
	allUsers = getUsersForVote()
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
	numUsers = getUsersForVote().length
	return _.max(voteTotals) >= Math.ceil(numUsers / 2)

makeInvitedIntoParticipant = ->
	# If user is signed in and their email is
	# in the current votes invited list,
	# remove them from invited and and them
	# to the vote's users

	vote = Votes.findOne({_id: Session.get('vote_id')})
	user = Meteor.user()
	return if not vote? or not user? or not user.emails?
	invitedArray = vote.invited_user_emails
	userEmail = user.emails[0].address
	if _.contains invitedArray, userEmail
		Meteor.call('removeEmailFromVote', Session.get('vote_id'), userEmail)
		Meteor.call('addUserToVote', Session.get('vote_id'), Meteor.userId());
