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
