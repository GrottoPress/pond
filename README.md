# Pond

**Pond** is a *Crystal* implementation of a *WaitGroup*, without channels or explicit counters. *Pond* automatically keeps track of all its fibers, and waits until all of them complete execution.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pond:
       github: GrottoPress/pond
   ```

1. Run `shards install`

## Usage

- Spawn fibers and wait on them:

  ```crystal
  require "pond"

  pond = Pond.new

  1000.times do |_|
    pond.fill { do_work } # <= Spawns fiber and passes block to it
  end

  pond.drain # <= Waits for fibers to complete
  ```

  The code above is the same as:

  ```crystal
  require "pond"

  Pond.drain do |pond|
    1000.times do |_|
      pond.fill { do_work }
    end
  end # <= Drains pond automatically at the end of the block
  ```

- You may spawn *nested* fibers:

  In this case, all *ancestor* fibers have to be added to the pond, otherwise *Pond* can't guarantee any of them would complete.

  ```crystal
  require "pond"

  pond = Pond.new

  pond.fill do
    pond.fill do
      pond.fill { do_work }
    end
  end

  pond.drain
  ```

  Note that, while you can fill a pond that was created in a another fiber, draining has to be done in the same fiber the pond was created in. This is to prevent potential deadlocks.

  ```crystal
  require "pond"

  pond = Pond.new

  pond.fill { do_work }

  spawn { pond.drain } # <= Error!
  ````

## Development

Run tests with `crystal spec -Dpreview_mt`. You may set `CRYSTAL_WORKERS` environment variable with `export CRYSTAL_WORKERS=<number>`, before running tests.

## Contributing

1. [Fork it](https://github.com/GrottoPress/pond/fork)
1. Switch to the `master` branch: `git checkout master`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Make your changes, updating changelog and documentation as appropriate.
1. Commit your changes: `git commit`
1. Push to the branch: `git push origin my-new-feature`
1. Submit a new *Pull Request* against the `GrottoPress:master` branch.
