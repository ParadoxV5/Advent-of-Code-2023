# It is time – to go back to our OOP roots.
class CommModule
  
  PULSE_QUEUE = []
  STATISTICS = [0, 0]
  
  
  attr_reader :state
  def initialize(state = nil)
    @destinations = []
    @state = state
  end
  
  attr_reader :destinations
  def destinations=(destinations)
    @destinations = destinations.each { _1.link_from self }
  end
  
  # Observer pattern #1
  # @abstract callback of {#destinations=}; default: no-op
  def link_from(_other) end
  
  
  # I could have merged this into {.update}, but the OOP design roots got me.
  def broadcast(pulse)
    STATISTICS[pulse ? 1 : 0] +=
      destinations.each { _1.queue pulse, self }.size
  end
  
  # Observer pattern #2
  # @abstract subclasses may override this to decide whether to queue its {#broadcast} or not
  def queue(pulse, _from)
    PULSE_QUEUE << [self, pulse]
  end
  
  
  class FlipFlop < self
    def initialize(state = false) = super
    def queue(pulse, _from)
      super(@state = !@state, _from) unless pulse
    end
  end
  
  class Conjunction < self
    def initialize(state = {}) = super
    def link_from(other)
      super
      @state[other] = false
    end
    def queue(pulse, from)
      @state[from] = pulse
      super(!@state.each_value.all?, from)
    end
  end
  
  
  def self.update
    PULSE_QUEUE.shift&.then {|mod, pulse| mod.broadcast pulse }
  end
  
  modules = Hash.new {|hash, name| hash[name] = new }
  File.foreach('input.txt', chomp: true).map do|line|
    line.split(' -> ', 2).tap do|name, _destinations|
      modules[name] =
        if    name.delete_prefix! '%' then FlipFlop
        elsif name.delete_prefix! '&' then Conjunction
        else self
        end.new
    end
  end.each do|mod, destinations|
    modules[mod].tap { _1.destinations = destinations.split(', ').map &modules }
  end
  
  BUTTON = new.tap { _1.destinations = modules.values_at('broadcaster') }
  modules.clear # GC
  
  # Totally thought Part 2 will make us press the button a bajillion times…
  # I solved Part 1 without checking state loops. This’ll be an exercise to the reader, then!
  #MODULES = modules.values
  #STATES = Set.new
  1000.times do
    PULSE_QUEUE << [BUTTON, false]
    while update; end
  end
  puts STATISTICS.inject &:*
end
