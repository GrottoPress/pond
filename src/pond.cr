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
    unless fiber.dead?
      sync do
        @fibers << fiber
        @done = false
        remove_dead_fibers
      end
    end

    self
  end

  def drain : Nil
    ensure_same_fiber
    return unless @done == false

    until size == 0
      sleep 1.microsecond
    end

    sync do
      @fibers.clear
      @done = nil unless @done
    end

    until @done
      sleep 1.microsecond
    end
  end

  def size
    sync { @fibers.count(&.dead?.!) }
  end

  def self.drain(fiber : Fiber)
    drain({fiber})
  end

  def self.drain(fibers : Indexable(Fiber))
    new(fibers).drain
  end

  private def remove_dead_fibers
    return if @removing_dead

    spawn do
      until @done.nil?
        sync { @fibers.reject!(&.dead?) }
        sleep 1.microsecond
      end

      sync do
        @removing_dead = false
        @done = true
      end
    end

    @removing_dead = true
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
