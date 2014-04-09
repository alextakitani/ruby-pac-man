require 'spec_helper'
require 'cartao_util'

describe CartaoUtil do

  it "should fail with a invalid card number" do
    cartao = CartaoUtil.new
    puts cartao.validar 2,"5256310001035222","201802"
  end

end
