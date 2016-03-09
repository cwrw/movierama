# Cast or withdraw a vote on a movie
class VotingBooth
  def initialize(user, movie, notifier = Notifier)
    @user  = user
    @movie = movie
    @notifier = notifier
  end

  def vote(like_or_hate)
    set = _action_vote(like_or_hate)
    unvote # to guarantee consistency
    set.add(user)
    _update_counts
    notifier.send_email(movie, like_or_hate)
    self
  end

  def unvote
    movie.likers.delete(user)
    movie.haters.delete(user)
    _update_counts
    self
  end

  private
  attr_reader :user, :movie, :notifier

  def _action_vote(like_or_hate)
    case like_or_hate
      when :like
       movie.likers
      when :hate
        movie.haters
      else
        raise
    end
  end

  def _update_counts
    movie.update(
      liker_count: movie.likers.size,
      hater_count: movie.haters.size)
  end
end
