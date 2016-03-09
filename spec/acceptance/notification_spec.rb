require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'email notifications', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    @alice = User.create(
      uid:  'null|12345',
      name: 'Alice',
      email: "alice@gmail.com"
    )
    @bob = User.create(
      uid:  'null|67890',
      name: 'Bob',
      email: "bob@gmail.com"
    )
    @m_empire = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         @alice,
      liker_count:  50,
      hater_count:  2
    )
    @m_turtles = Movie.create(
      title:        'Teenage mutant ninja turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      user:         @bob,
      liker_count:  1,
      hater_count:  237
    )
  end

  with_logged_in_user
  before { page.open }

  it 'sends email on like' do
    expect { page.like('Empire strikes back') }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends email on hate' do
    expect { page.like('Teenage mutant ninja turtles') }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "sends email on unlike" do
    # TODO: not sure about this?
    page.like('Teenage mutant ninja turtles')
    expect { page.unlike('Teenage mutant ninja turtles') }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "sends email on unhate" do
    # TODO: not sure about this?
    page.hate('Empire strikes back')
    expect { page.unhate('Empire strikes back') }
      .to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "handles exceptions" do
    # TODO: raise error, empty email?
    expect(Rails.logger).to receive(:error).with("Boom!")
  end

end



