# quarter

![Gem Version](https://badge.fury.io/rb/quarter.svg)
![Build Status](https://github.com/readysteady/quarter/workflows/Test/badge.svg)


Ruby gem for working with standard calendar quarters.


## Install

Using Bundler:

    $ bundle add quarter

Using RubyGems:

    $ gem install quarter


## Usage

```ruby
require 'quarter'

date = Date.today

quarter = Quarter(date)

p quarter.start_date
p quarter.include?(date)
p quarter.next
p quarter.name
p quarter.to_s
p quarter.iso8601
```

### Quarter::Methods

Include the `Quarter::Methods` module for methods which can be used to get the quarter for a given year in a manner that resembles written english. For example:

    include Quarter::Methods

    q1 = Q1 2020

### Quarter::Constants

Include the `Quarter::Constants` module for constants which can be used to get the quarter for a given year in a manner that resembles written english. For example:

    include Quarter::Constants

    q1 = Q1/2020

    q2 = 2020-Q2

### YAML integration

Require `quarter/yaml` for YAML integration which supports dumping and loading quarter objects to and from YAML as scalar values. For example:

    require 'quarter/yaml'

    puts YAML.dump([Quarter.now])
