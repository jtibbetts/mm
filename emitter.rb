class Emitter
  attr_accessor :format, :output

  def initialize(format)
    @format = format
  end

  def emit(values)
    result = @format % values
    result
  end
end