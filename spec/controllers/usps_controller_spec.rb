require 'spec_helper'

describe UspsController do

  describe "GET 'estimate'" do
    it "returns http success" do
      get 'estimate'
      response.should be_success
    end
  end

end
