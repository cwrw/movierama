class Notifier
  attr_reader :author, :movie, :action

  def self.send_email(movie, action)
    new(movie, action).mailer
  rescue => e
    Rails.logger.error "#{e.message}: #{e.backtrace}"
  end


  def initialize(movie, action)
    @author = movie.user
    @movie = movie
    @action = action
  end

  def mailer
    NotificationMailer.vote_message(
      author: author,
      movie: movie,
      action: action
    ).deliver_later
  end
end
