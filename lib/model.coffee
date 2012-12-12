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

	createNewVote: (question) ->
		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to create votes.')

		if Meteor.isServer
			Votes.insert(
				{
					question: question,
					options: [
						{
							option: 'Option A'
						}
					],
					creator_id: Meteor.userId(),
					users: [
						{
							id: Meteor.userId(),
							vote: null
						}
					]
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