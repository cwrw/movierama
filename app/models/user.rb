class User < BaseModel
  include GlobalID::Identification
  include Ohm::Timestamps

  attribute :name
  attribute :email

  # Unique identifier for this user, in the form "{provider}|{provider-id}"
  attribute :uid
  index     :uid
  unique    :uid

  # Session token
  attribute :token
  index     :token

  # Submitted movies
  collection :movies, :Movie

  def validate
    assert_present(:name)
    assert_email(:email)
  end
end
