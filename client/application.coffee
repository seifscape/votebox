# Configure autosubscribe for votes and users
Meteor.autosubscribe ->
	vote_id = Session.get('vote_id')
	Meteor.subscribe('directory', vote_id)
	Meteor.subscribe('votes', vote_id)

Meteor.Router.add
	'': ->
		Session.set('vote_id', null)
		return 'main'

	'/admin': ->
		Session.set('vote_id', null)
		return 'admin'

	'/vote/:id': (id) ->
		Session.set('vote_id', id[0])
		makeInvitedIntoParticipant()
		return 'vote'

Meteor.startup ->
	# Startup code