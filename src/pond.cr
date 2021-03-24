require "./pond/version"
require "./pond/**"

class Pond
  private enum State
    Ready
    Drained
    Done
  end

  def initialize(@fibers = Array(Fiber).new)
    @fiber = Fiber.current
    @mutex = Mutex.new
    @state = State::Ready

    remove_dead_fibers
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

  def drain
    ensure_same_fiber
    return if @state.drained?

    until @fibers.all?(&.dead?)
      Fiber.yield
    end

    sync { @state = State::Drained }

    until @state.done?
      Fiber.yield
    end
  end

  private def remove_dead_fibers
    spawn do
      until @state.drained?
        sync { @fibers.reject!(&.dead?) }
        Fiber.yield
      end

      sync { @state = State::Done }
    end
  end

  private def ensure_same_fiber
    return if @fiber == Fiber.current

    sync { @state = State::Drained }
    raise Error.new("Cannot drain pond from another fiber")
  end

  private def sync
    @mutex.synchronize { yield }
  end
end
