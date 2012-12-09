# Publishing votes

Meteor.publish 'votes', (vote_id) ->
  user = Meteor.users.findOne({_id: this.userId})
  return false if not user
  if vote_id?
    return Votes.find({_id: vote_id, 'users.id': this.userId})
  else
    return Votes.find({'users.id': this.userId})


# Publishing users

Meteor.publish 'directory', (vote_id) ->
  if vote_id?
    vote = Votes.findOne({_id: vote_id})
    return if not vote
    validIdsArray = _.pluck vote.users, 'id'
    return Meteor.users.find(_id: {$in: validIdsArray}, {fields: {emails: 1, profile: 1, name: 1}})
  else
    return Meteor.users.find({}, {fields: {emails: 1, profile: 1, name: 1}})


# Bootstrap data

Meteor.startup ->
  unless Votes.find().count()
    _.each [
      {
        question: 'What should we have for lunch?'
        options: [
          {
            option: 'Indian'
          }
          {
            option: 'Waffles'
          }
          {
            option: 'Salad'
          }
        ]
      }
    ], (attributes) ->
      Votes.insert(attributes)


# Allowing

Meteor.users.allow
  insert: (userId, docs) ->
    return false
  update: (userId, docs, fields, modifier) ->
    return false
  remove: (userId, docs) ->
    return false