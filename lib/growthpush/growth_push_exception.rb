#
# GrowthPush Exception Class (GrowthPush 例外クラス)
#
class GrowthPushException < Exception

  #code

  attr_reader :code

  #
  # initializer (イニシャライザ)
  # @param [String] message error message (エラー・メッセージ)
  # @param [Integer] code error code (エラー・コード)
  #
  def initialize(message, code=nil)
    super(message)
    @code = code
  end

end