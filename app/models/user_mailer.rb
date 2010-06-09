class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{SITE_URL}"
  end

  def forgot_password(user)
     setup_email(user)
     @subject    += 'Password reset request'
     @body[:url]  = "#{SITE_URL}/reset/#{user.reset_code}"
   end

   def reset_password(user)
     setup_email(user)
     @subject    += 'Your password has been reset'
   end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "freehub@bikekitchen.org"
      @subject     = "Freehub: "
      @sent_on     = Time.zone.now
      @body[:user] = user
    end
end
