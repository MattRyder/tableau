Tableau
=========

[![Build Status](https://travis-ci.org/MattRyder/tableau.png)](https://travis-ci.org/MattRyder/tableau)

Tableau is a Ruby on Rails Gem that parses, analyses and creates timetables for Staffordshire University students, by using the latest live data available. It currently has the ability to parse both 'student set' timetables (aka 'Core Timetables'), as well as individual Module timetables.

The parser is built upon a single BaseParser class, so if the University has data, it's likely Tableau can be expanded to retrieve it!

Installing Tableau on Rails 4
--------------------
In your Gemfile, include:
``` ruby
gem 'tableau'
```

Or pull the latest build from the master branch:

``` ruby
gem 'tableau', git: 'http://github.com/MattRyder/tableau.git'
```

and run bundle install.

Developing Tableau
--------------------

To develop for Tableau, I invite you to make some changes to the gem, and send me a pull request!

All I ask is that if you develop any new features, you include a similar test scheme as seen in existing parts of the gem (or better! :smile:) and if the tests pass, there's little preventing a merge!


Licence
-------------------
MIT Licence, see LICENCE for more details on that.
