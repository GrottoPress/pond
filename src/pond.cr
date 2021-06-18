require "./pond/version"
require "./pond/**"

class Pond
  def initialize(@fibers = Array(Fiber).new)
    @fiber = Fiber.current
    @mutex = Mutex.new
    @done = false

    remove_dead_fibers_async
  end

  def <<(fiber)
    fill(fiber)
  end

  def fill(name = nil, same_thread = nil, &block)
    fill spawn(name: name, same_thread: same_thread, &block)
  end

  def fill(fiber : Fiber)
    sync { @fibers << fiber }
    self
  end

  def drain : Nil
    if @fiber != Fiber.current
      raise Error.new("Cannot drain pond from another fiber")
    end

    remove_dead_fibers

    until @done
      Fiber.yield
    end
  end

  delegate :size, to: @fibers

  def self.drain(fiber : Fiber)
    drain([fiber])
  end

  def self.drain(fibers : Array(Fiber))
    new(fibers).drain
  end

  private def remove_dead_fibers_async
    spawn do
      remove_dead_fibers
      @done = true
    end
  end

  private def remove_dead_fibers
    until @fibers.all?(&.dead?)
      Fiber.yield
      sync { @fibers.reject!(&.dead?) }
    end
  end

  private def sync
    @mutex.synchronize { yield }
  end
end
