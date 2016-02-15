class ConfirmationMailer < ActionMailer::Base
  def confirm_email(target_email, activation_token)
            @activation_token = activation_token
            mail(:to => target_email,
                        :from => "elpewe2@gmail.com",
                        :subject => "[Task Lima]") do |format|
                            format.html { render 'confirm_email'}
                        end
        end
end
