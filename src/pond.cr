require "./pond/version"
require "./pond/**"

class Pond
  def initialize
    @counter = Atomic(Int32).new(0)
    @fiber = Fiber.current
  end

  def fill(name = nil, same_thread = nil, &block)
    @counter.add(1)

    spawn(name: name, same_thread: same_thread) do
      block.call
    ensure
      @counter.sub(1)
    end
  end

  def drain : Nil
    ensure_same_fiber

    until size == 0
      sleep 1.microsecond
    end
  end

  def size
    @counter.get
  end

  def self.drain
    yield pond = new
    pond.drain
  end

  private def ensure_same_fiber
    return if @fiber == Fiber.current
    raise Error.new("Cannot drain pond from another fiber")
  end
end
