module BackendJobs
  def calculate_points
    start_time = DateTime.now() - 1.hour
    end_time = DateTime.now()
    users = User.all
    users.each do |user|
      earned_points = 0
      likes = user.likes.where(created_at: start_time..end_time)
      comments = user.comments.where(created_at: start_time..end_time)
      shares = user.shares.where(created_at: start_time..end_time)
      micro_blogs = user.micro_blogs.where(created_at: start_time..end_time)
      if likes.count >= 100
        earned_points = earned_points + 10
      end
      if comments.count >= 100
        earned_points = earned_points + 100
      end
      if shares.count >= 100
        earned_points = earned_points + 1000
      end
      if micro_blogs.count >= 100
        earned_points = earned_points + 10000
      end
      user.points = user.points + earned_points
      user.save
    end

  end

  def award_titles
    users = User.all
    users.each do |user|
      titles = []
      total = 0
      likes = Like.where( user_id: user.id, status: [0,2] ).count
      comments = Comment.where(user_id: user.id,  status: [0,2]).count
      shares = Share.where(user_id: user.id, status: [0,2]).count
      micro_blogs = MicroBlog.where( user_id: user.id, status: [0,2]).count
      if likes >= 100
        titles << "Best Liker"
      end
      if comments >= 100
        titles << "Best Commentor"
      end
      if shares >= 100
        titles << "Best Sharer"
      end
      if micro_blogs >= 100
        titles << "Best Poster"
      end
      total = likes+comments+shares+micro_blogs
      if total >= 800
        titles << "Best Social Person"
      end
      my_abuses = Abuse.where(user_id: user.id).count
      if my_abuses >= 100 && user.blocked_by.count >= 100
        titles << "Worst Social Person"
      end
      if user.blockers.count >= 100
        titles << "The Wall"
      end
      user.title = titles.join(', ')
      user.save
    end
  end
end

