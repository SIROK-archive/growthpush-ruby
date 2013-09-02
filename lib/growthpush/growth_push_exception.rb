#
# GrowthPush Exception Class (GrowthPush 例外クラス)
#
# @version 0.1.0
# @!attribute [r] code
#  @return [String] error code (エラー・コード)
#
class GrowthPushException < Exception

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