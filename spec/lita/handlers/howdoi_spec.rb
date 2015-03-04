require "spec_helper"

describe Lita::Handlers::Howdoi, lita_handler: true do

  it { is_expected.to route_command("howdoi do a thing").to(:howdoi) }
  it { is_expected.to route_command("howdoi 2 do a thing").to(:howdoi) }

  it "can return an answer" do
    send_command("howdoi split a string in ruby")
    expect(replies.last).to match /\.split/
  end
end
