[![TravisCI](https://secure.travis-ci.org/tstmedia/find_as_hashes.png "TravisCI")](http://travis-ci.org/tstmedia/find_as_hashes "Travis-CI FindAsHashes")

# ActiveRecord

Adds methods to return attribute hashes rather than instantiated
ActiveRecord objects. This is useful when working with large sets of
records and you need the performance more than you need the convenience
of your ActiveRecord methods.

## Methods

The hashes that return are similar to the hash that returns with
[`ActiveRecord::Base#attributes`][attrs_method], except values are not
coerced (e.g., a tinyint column containing `1` will not be coerced into
`true`). Strings, dates, and numbers will return as their appropriate
Ruby object. Booleans will return the underlying representation and
serialized objects will return as strings.

* `all_as_hashes` works similarly to `all`, but returns the results as
  an array of hashes.
* `first_as_hash` works similarly to `first`, but returns a hash of the
  first matching record.

[attrs_method]:http://api.rubyonrails.org/classes/ActiveRecord/Base.html#method-i-attributes

## Examples

    > User.where(:email => nil).all_as_hashes
    => [
      {:id => 123, :name => "Joe User", :email => nil},
      {:id => 456, :name => "Jane User", :email => nil}
    ]

    > User.where(:email => nil).first_as_hash
    => {:id => 123, :name => "Joe User", :email => nil}

## Effects

These methods are not for everyday use, but for when speed of execution
is more important than convenience, like heavy-duty reporting or
processing lots of existing records.

In one example, looping through 36,400 User records and accessing an
attribute used 32% less memory and performed 17% quicker using
`all_as_hashes` over `all`.

# ActiveResource

The equivalent methods are available in ActiveResource as well, providing
similar benefits.

## Methods

The hashes that return are essentially the xml or json data hashified.

* `all_as_hashes` works similarly to `all`, but returns the results as
  an array of hashes.
* `find_as_hashes` works similarly to `find`, but returns the results as
  an array of hashes.
* `first_as_hash` works similarly to `first`, but returns a hash of the
  first matching record.
* `last_as_hash` works similarly to `last`, but returns a hash of the
  last matching record.

## Usage

To enable the use of these methods, simply add this line to the top of your
ActiveResource class.

`require 'active_resource/find_as_hashes'`

## Examples

    > User.all_as_hashes(:active => 1)
    => [
      {:id => 123, :name => "Joe User", :active => 1,},
      {:id => 456, :name => "Jane User", :active => 1}
    ]

    > User.first_as_hash(:active => 1)
    => {:id => 123, :name => "Joe User", :active => 1}

## Tests

Run tests with `bundle exec rake test` (or just `rake test` if you're
daring).
