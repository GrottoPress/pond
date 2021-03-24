require "./spec_helper"

describe Pond do
  describe "#drain" do
    it "waits for fibers to complete" do
      n = 1000
      pond = Pond.new
      count = Atomic(Int32).new(0)

      n.times do |_|
        pond.fill { count.add(1) }
      end

      pond.fill do
        pond.fill do
          pond << spawn { count.add(1) }
        end
      end

      pond.drain

      count.lazy_get.should eq(n + 1)
    end

    it "raises when drained from another fiber" do
      pond = Pond.new
      errors = Array(Exception.class).new

      spawn do
        pond.drain
      rescue error
        errors << error.class
      end

      Fiber.yield

      errors.should contain(Pond::Error)
    end
  end
end
