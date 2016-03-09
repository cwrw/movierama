require 'rails_helper'

RSpec.describe NotificationMailer do
  describe 'notifier' do
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

    let(:action) { "like" }
    let(:mail) do
      described_class.vote_message(
        author: author,
        movie: movie,
        action: action
      )
    end

    it 'sets the subject' do
      expect(mail.subject).to eql('MovieRama notification')
    end

    it 'sets the receiver email' do
      expect(mail.to).to eql([author.email])
    end

    it 'sets the sender email' do
      expect(mail.from).to eql(['notifications@movierama.com'])
    end

    it 'sets the correct body with author name' do
      expect(mail.body.encoded).to match(author.name)
    end

    it 'sets the correct body with movie and action' do
      expect(mail.body.encoded).to match("You have received a #{action} vote on your movie: #{movie.title}")
    end

    it "exceptions"
  end
end