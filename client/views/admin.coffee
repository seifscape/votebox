## TEMPLATING

Template.admin.votes = ->
	votes = Votes.find({creator_id: Meteor.userId()})

Template.admin.participants_with_vote_data = ->
	vote = this
	participants = getValidVoteUsers(vote._id).fetch()
	return if not participants?

	augumented_participants = _.map participants, (p) ->
		optionIndex = 0;
		{
			_id: p._id
			email: p.emails[0].address
			options: _.map vote.options, (option) ->
				option = {
					option: option.option
					is_selected_option: findUserVote(p._id, vote._id).vote is optionIndex
				}
				optionIndex++;
				return option
		}
	return augumented_participants

## EVENTS

Template.admin.events
	'change .option-select': (evt) ->
		voteId = $(evt.target).attr('data-vote-id')
		voteIndex = evt.target.selectedIndex
		voteIndex = null if evt.target.value is 'None'

		Meteor.call('setUserVote', voteId, this._id, voteIndex)

	'click .reset-votes-button': (evt) ->
		Meteor.call('resetUserVotes', this._id)

	'click .create-vote-button': (evt, template) ->
		# Gather the values
		question = $('.new-vote-question').val()
		options = $('.new-vote-options').val().split(/[ ,]+/)
		participants = $('.new-vote-participants').val().split(/[ ,]+/)

		Meteor.call('createNewVote', question, options, participants)

		# Clear inputs
		$(evt.target).parent().find('input, textarea').val('')

	'click .delete-vote-button': (evt) ->
		Meteor.call('deleteVote', this._id)