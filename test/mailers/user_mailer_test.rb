require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test 'welcome_user sequencing' do
    assert_difference('ActionMailer::Base.deliveries.size', + 1) do
      UserMailer.welcome_user(users(:anand)).deliver_now
    end
  end

  test 'welcome_user mail content' do
    email = UserMailer.welcome_user(users(:anand))
    sent_email = nil

    # Send the email, then test that it got queued
    assert_emails 1 do
      sent_email = email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['notifications@rails_e2_soln.com'], sent_email.from
    assert_equal [users(:anand).email], sent_email.to
    assert sent_email.subject.downcase.include?('welcome')
    assert sent_email.body.encoded.downcase.include?('welcome')
  end
end
