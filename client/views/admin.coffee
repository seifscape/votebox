## TEMPLATING

Template.admin.votes = ->
	votes = Votes.find({creator_id: Meteor.userId()})

Template.admin.participants = ->
	getValidVoteUsers(this._id)

Template.admin.email = ->
	this.emails[0].address

Template.admin.is_selected_option = ->
	# this refers to the user (id and email)
	# we can get the current vote id from $('.option-select').attr('data-vote-id')
	userVote = findUserVote(this._id)
	return if not userVote?
	userVote = if not userVote.vote? then null else userVote.vote

## EVENTS

Template.admin.events
	'change .option-select': (evt) ->
		voteId = $(evt.target).attr('data-vote-id')
		voteIndex = evt.target.selectedIndex
		voteIndex = null if evt.target.value is 'None'

		Meteor.call('setUserVote', voteId, this._id, voteIndex)

	'click .reset-votes-button': (evt) ->
		Meteor.call('resetUserVotes', this._id)

	'click .create-vote-button': (evt) ->
		questionInput = $('.vote-question')
		question = questionInput.val()
		questionInput.val('')
		Meteor.call('createNewVote', question)

	'click .delete-vote-button': (evt) ->
		Meteor.call('deleteVote', this._id)