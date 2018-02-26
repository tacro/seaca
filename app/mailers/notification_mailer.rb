class NotificationMailer < ApplicationMailer

  default from: "seaca.jp@gmail.com"

  def signup_email(user)
    @username = user.name
    mail to: user.email, subject: "ユーザー登録が完了しました!"
  end

  def post_email(user, post)
    @username = user.name
    @itemname = post.name
    mail to: user.email, subject: "作品が投稿されました"
  end
end
