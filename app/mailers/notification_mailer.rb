class NotificationMailer < ApplicationMailer
  default from: 'notifications@movierama.com'

  def vote(author:, movie:, action:)
    @author = author
    @movie  = movie
    @action = action
    mail(to: @author.email, subject: 'MovieRama notification') do |format|
      format.html { render layout: 'mailer' }
      format.text
    end
  end
end
