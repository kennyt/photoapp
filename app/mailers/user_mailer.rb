class UserMailer < ActionMailer::Base
  default from: "photo@app.com"

  def photo_post_inform(user)
    @user = user
    @url = "http://localhost:3000/"
    mail(:to => @user.email, :subject => "Nice photo post bro")
  end
end
