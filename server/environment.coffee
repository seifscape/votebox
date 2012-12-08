# Publishing votes
Meteor.publish 'votes', (vote_id) ->
  user = Meteor.users.findOne({_id: this.userId})
  return false if not user
  if vote_id?
    return Votes.find({_id: vote_id, 'users.id': this.userId})
  else
    return Votes.find({'users.id': this.userId})

# Publishing select data for all users
Meteor.publish 'directory', (vote_id) ->
  if vote_id?
    vote = Votes.findOne({_id: vote_id})
    return if not vote
    validIdsArray = _.pluck vote.users, 'id'
    return Meteor.users.find(_id: {$in: validIdsArray}, {fields: {emails: 1, profile: 1, name: 1}})
  else
    return Meteor.users.find({}, {fields: {emails: 1, profile: 1, name: 1}})
Meteor.startup ->

  unless Votes.find().count()
    _.each [
      {
        question: 'What should we rename Flex Cards to?'
        options: [
          {
            option: 'Pre-Paid Card'
          }
          {
            option: 'Punchcard'
          }
        ]
        users: [
          {
            id: '2f537a74-3ce0-47b3-80fc-97a4189b2c15'
            vote: 0
          }
          {
            id: '6d46c5a6-d014-4ef8-b78b-c4638fc2cd7f'
            vote: null
          }
          {
            id: '8bffafa7-8736-4c4b-968e-82900b82c266'
            vote: 1
          }
          {
            id: 'a359da7f-a0d1-4f41-96e6-449dcde09a33'
            vote: null
          }
        ]
      },
      {
        question: 'What should we have for lunch?'
        options: [
          {
            option: 'Indian'
          }
          {
            option: 'Waffles'
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