require "rails_helper"

RSpec.describe Notifier do
  let(:author) do
    User.create(
      uid:  'null|12345',
      name: 'Bob',
      email: 'bob@example.com'
    )
  end

  let(:movie) do
    Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         author
    )
  end
  let(:action) { "hates" }

  subject { described_class.send_email( movie, action) }

  it "sends an email to author of movie about vote" do
    expect { subject }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  context "exceptions" do
    before do
      allow(NotificationMailer).to receive(:vote_message).and_raise("Boom!")
    end

    it "writes to error log" do
      expect(Rails.logger).to receive(:error).with("Boom!")
      subject
    end
  end
end