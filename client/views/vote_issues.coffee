## TEMPLATING

Template.vote_issues.is_registered_user = ->
	return Meteor.userId()?

Template.vote_issues.has_no_votes = ->
	return Meteor.userId()? and not Votes.find().count()