require "./pond/version"
require "./pond/**"

class Pond
  def initialize
    @fibers = Array(Fiber).new
    @fiber = Fiber.current
    @mutex = Mutex.new
  end

  def self.new(fibers) : self
    new.fill(fibers)
  end

  def fill(fibers)
    fibers.each { |fiber| fill(fiber) }
    self
  end

  def <<(fiber)
    fill(fiber)
  end

  def fill(name = nil, same_thread = nil, &block)
    fill spawn(name: name, same_thread: same_thread, &block)
  end

  def fill(fiber : Fiber)
    sync do
      @fibers << fiber
      @done = false
    end

    remove_dead_fibers
    self
  end

  def drain : Nil
    ensure_same_fiber
    return unless @done == false

    until @fibers.all?(&.dead?)
      Fiber.yield
    end

    sync { @done = nil } unless @done

    until @done
      Fiber.yield
    end
  end

  def size
    @fibers.count(&.dead?.!)
  end

  def self.drain(fiber : Fiber)
    drain([fiber])
  end

  def self.drain(fibers : Array(Fiber))
    new(fibers).drain
  end

  private def remove_dead_fibers
    return unless size == 1

    spawn do
      until @done.nil?
        sync { @fibers.reject!(&.dead?) }
        Fiber.yield
      end

      sync { @done = true }
    end
  end

  private def ensure_same_fiber
    return if @fiber == Fiber.current

    sync { @done = nil }
    raise Error.new("Cannot drain pond from another fiber")
  end

  private def sync
    @mutex.synchronize { yield }
  end
end
