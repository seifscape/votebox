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
		# TODO: Each vote should have a creator id attach
		# and this method should check to see if the current
		# userId matches the creator id, otherwise error

		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to modify votes.')
		
		if Meteor.isServer
			vote = Votes.findOne({_id: vote_id})

			_.each vote.users, (user) ->
				Votes.update(
					{_id: vote_id, 'users.id': user.id},
					{$set: {'users.$.vote': null}}
				)