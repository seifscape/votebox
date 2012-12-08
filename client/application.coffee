# Subscribe to member directory
Meteor.subscribe('directory')

# Configure autosubscribe for votes
Meteor.autosubscribe ->
	vote_id = Session.get('vote_id')
	Meteor.subscribe('votes', vote_id)

Meteor.Router.add
	'': ->
		Session.set('vote_id', null)
		return 'main'

	'/vote/:id': (id) ->
		Session.set('vote_id', id[0])
		return 'vote'

Meteor.startup ->
	# Startup code