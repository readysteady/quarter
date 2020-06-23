# 1.1.0

* Added optional YAML integration

This makes it possible to dump/load quarter objects to/from YAML as scalar values. For example:

    require 'quarter/yaml'

    puts YAML.dump([Quarter.today])

This functionality is not enabled by default, due to the use of Module#prepend.

# 1.0.0

* First version!
