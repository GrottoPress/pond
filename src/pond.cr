require "./pond/version"
require "./pond/**"

class Pond
  def initialize(@fibers = Array(Fiber).new)
    @fiber = Fiber.current
    @mutex = Mutex.new

    spawn { remove_dead_fibers }
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
  end

  def self.drain(fiber : Fiber)
    drain([fiber])
  end

  def self.drain(fibers : Array(Fiber))
    new(fibers).drain
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
