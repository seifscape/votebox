Votes = new Meteor.Collection('votes')

Meteor.methods
	addUserToVote: (vote_id, user_id) ->	
		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to modify users')
		
		if Meteor.isServer
			Votes.update(
				{_id: vote_id},
				{
					$push: {
						users: {
							'id': user_id,
							'vote': null
						}
					}
				}
			)

	removeEmailFromVote: (vote_id, user_email) ->
		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to modify users')
		
		if Meteor.isServer
			Votes.update(
				{_id: vote_id, invited_user_emails: user_email},
				{
					$pull: {
						invited_user_emails: user_email
					}
				}
			)

	setUserVote: (vote_id, user_id, vote_index) ->
		# Prevent setting vote for other users
		# if user_id is not Meteor.userId()
		#	throw new Meteor.Error(403, 'You can only set your own vote)	

		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to vote')
		
		if Meteor.isServer
			Votes.update(
				{_id: vote_id, 'users.id': user_id},
				{$set: {'users.$.vote': vote_index}}
			)

	resetUserVotes: (vote_id) ->
		vote = Votes.findOne({_id: vote_id})

		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to modify votes.')

		if this.userId is not vote.creator_id
			throw new Meteor.Error(403, 'You cannot clear votes that you did not create.')

		
		if Meteor.isServer
			_.each vote.users, (user) ->
				Votes.update(
					{_id: vote_id, 'users.id': user.id},
					{$set: {'users.$.vote': null}}
				)

	createNewVote: (question, optionsArray, participantsArray) ->
		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to create votes.')

		# Turn optionsArray into key/value pairs
		options = _.map optionsArray, (option) ->
			return {option: option}

		# TODO: Email addresses from participants array that already exist in
		# VoteBox should be immediately added to users, rather than to 'invited_user_emails'.

		users = []
		invited_user_emails = []

		# For each in participantsArray, determine whether the user email already exists
		# and if so immediately add them to the vote
		_.each participantsArray, (participantEmail) ->
			user = Meteor.users.findOne({'emails.0.address': participantEmail})
			if user?
				users.push {id: user._id, vote: null}
			else
				invited_user_emails.push participantEmail
		users.push({id: Meteor.userId(), vote: null})

		if Meteor.isServer
			newVoteId = Votes.insert(
				{
					question: question,
					options: options
					creator_id: Meteor.userId(),
					users: users
					invited_user_emails: invited_user_emails
				}
			)

			# When this is deployed to votebox.meteor.com you can comment out the following line
			process.env.MAIL_URL = 'smtp://postmaster%40cmal.mailgun.org:3ldr22afg917@smtp.mailgun.org:587'
			url = 'http://localhost:3000/'
			Email.send(
				{
					from: 'chris@desktimeapp.com'
					to: 'cmalven@chrismalven.com'
					subject: 'Meteor Test'
					html: "<h1>You've been invited to a VoteBox: #{question}</h1><p>To participate in this vote please click the following link:</p><p><a href='#{url}vote/#{newVoteId}'>Participate in this vote</a>"
				}
			)

	deleteVote: (vote_id) ->
		vote = Votes.findOne({_id: vote_id})

		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to delete votes.')

		if this.userId is not vote.creator_id
			throw new Meteor.Error(403, 'You cannot delete votes that you did not create.')

		if Meteor.isServer
			Votes.remove({_id: vote_id})