## TEMPLATING

Template.admin.votes = ->
	votes = Votes.find()

Template.admin.participants = ->
	Meteor.users.find()

Template.admin.email = ->
	this.emails[0].address

## EVENTS

Template.admin.events
	'change .option-select': (evt) ->
		voteId = $(evt.target).attr('data-vote-id')
		voteIndex = evt.target.selectedIndex
		voteIndex = null if evt.target.value is 'None'

		Meteor.call('setUserVote', voteId, this._id, voteIndex)