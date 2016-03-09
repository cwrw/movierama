require "rails_helper"

RSpec.describe VotingBooth do
  let(:user) do
    User.create(
      uid:  'null|12345',
      name: 'Alice',
      email: 'alice@example.com'
    )
  end

  let(:author) do
    User.create(
      uid:  'null|67890',
      name: 'Bob',
      email: 'bob@example.com'
    )
  end

  let(:m_empire) do
    Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         author,
      liker_count:  0,
      hater_count:  0
    )
  end

  subject { described_class.new(user, m_empire) }

  describe "vote" do
    it "increments movie liker_count if vote is a like" do
      expect{ subject.vote(:like) }.to change { m_empire.liker_count }.from(0).to(1)
    end

    it "increment movie hater_count if vote is a hate" do
      expect{ subject.vote(:hate) }.to change { m_empire.hater_count }.from(0).to(1)
    end

    it "notifies observer of like action" do
      expect(Notifier).to receive(:send_email)
      subject.vote(:like)
    end

    it "notifies observer of hate action" do
      expect(Notifier).to receive(:send_email)
      subject.vote(:hate)
    end
  end

  describe "unvote" do
    it "dencrement movie liker_count if vote is a like" do
      subject.vote(:like)
      expect{ subject.unvote }.to change { m_empire.liker_count }.from(1).to(0)
    end

    it "decrement movie hater_count if vote is a hate" do
      subject.vote(:hate)
      expect{ subject.unvote }.to change { m_empire.hater_count }.from(1).to(0)
    end

    it "doesn't notify observer of like action" do
      expect(Notifier).to_not receive(:send_email)
      subject.unvote
    end

    it "doesn't notify observer of hate action" do
      expect(Notifier).to_not receive(:send_email)
      subject.unvote
    end
  end
end