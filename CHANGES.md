# 1.3.0

* Added Quarter#inspect method

# 1.2.1

* Added CHANGES.md to gem files

* Fixed outdated changelog_uri

# 1.2.0

* Added Quarter::Methods module

* Added Quarter::Constants module

# 1.1.0

* Added optional YAML integration

This makes it possible to dump/load quarter objects to/from YAML as scalar values. For example:

    require 'quarter/yaml'

    puts YAML.dump([Quarter.today])

This functionality is not enabled by default, due to the use of Module#prepend.

# 1.0.0

* First version!
