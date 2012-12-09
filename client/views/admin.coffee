## TEMPLATING

Template.admin.votes = ->
	votes = Votes.find()

Template.admin.participants = ->
	Meteor.users.find()

Template.admin.email = ->
	this.emails[0].address

Template.admin.is_selected_option = ->
	# this refers to the user (id and email)
	# we can get the current vote id from $('.option-select').attr('data-vote-id')
	userVote = findUserVote(this._id)
	return if not userVote?
	userVote = if not userVote.vote? then null else userVote.vote
	console.log 'this', this

## EVENTS

Template.admin.events
	'change .option-select': (evt) ->
		voteId = $(evt.target).attr('data-vote-id')
		voteIndex = evt.target.selectedIndex
		voteIndex = null if evt.target.value is 'None'

		Meteor.call('setUserVote', voteId, this._id, voteIndex)