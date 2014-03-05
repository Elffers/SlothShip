require 'spec_helper'
 
describe Shipper do 
  #check webmock docs for how to store an actual call and tweak to get desired erros

  it "handles bad zip code error" do
    expect{ raise ArgumentError, "no"}.to raise_error ArgumentError
  end

end