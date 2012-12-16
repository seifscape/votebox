VoteBox
=======

A Meteor-based group voting app, built using:

* [CoffeeScript](http://coffeescript.org)
* [Stylus](http://learnboost.github.com/stylus/)
* [Reactive Router](https://github.com/tmeasday/meteor-router)


## Install

You'll need to have [Node and npm](http://nodejs.org) Installed.

Install [Meteor](http://meteor.com) with:

```
curl https://install.meteor.com | sh
```

Install Meteorite with:

```
npm install -g meteorite
```

## Run

```
cd votebox && mrt
```
will download the latest Meteor development bundle, and install all necessary smart packages for you.

## Deploy

_VoteBox_ is is easily deployed with the Meteor deployment service:

```
mrt deploy your-app-name.meteor.com
```

You can also deploy to Heroku easily using a Heroku build pack:

```
heroku create your-app-name --stack cedar --buildpack https://github.com/jordansissel/heroku-buildpack-meteor.git
```
Add the heroku remote to git:

```
git remote add heroku git@heroku.com:your-app-name.git
```

Then, to deploy:

```
git push heroku master
```
