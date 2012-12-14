Meteor.methods
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

		options = _.map optionsArray, (option) ->
			return {option: option}

		# TODO: Participant email invites
		# Send email invitations to each participant

		if Meteor.isServer
			Votes.insert(
				{
					question: question,
					options: options
					creator_id: Meteor.userId(),
					users: [
						{
							id: Meteor.userId(),
							vote: null
						}
					],
					invited_user_emails: participantsArray
				}
			)

			# When this is deployed to votebox.meteor.com you can comment out the following line
			process.env.MAIL_URL = 'smtp://postmaster%40cmal.mailgun.org:3ldr22afg917@smtp.mailgun.org:587'
			Email.send(
				{
					from: 'chris@desktimeapp.com'
					to: 'cmalven@chrismalven.com'
					subject: 'Meteor Test'
					html: '<h1>This is a test</h1><p>This is a test of the meteor email system.</p>'
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