require "test_helper"

describe HistoryController do
  it "should get index" do
    get history_index_url
    value(response).must_be :success?
  end

end
