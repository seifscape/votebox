Meteor.methods
	setUserVote: (vote_id, vote_index) ->
		if not this.userId
			throw new Meteor.Error(403, 'You must be logged in to vote')
		
		if Meteor.isServer
			Votes.update(
				{_id: vote_id, 'users.id': this.userId},
				{$set: {'users.$.vote': vote_index}}
			)