class GrowthPushException < Exception

  #code

  attr_reader :code

  def initialize(*args)
    case args.length
      when 1
        super(args[0])
      when 2
        initialize_2(args[0],args[1])
      else
        raise ArgumentError
    end
  end

  def initialize_2(message, code=nil)
    initialize(message)
    @code = code
  end
  private :initialize_2

end