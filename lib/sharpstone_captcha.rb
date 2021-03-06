#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2017-06-22 11:24:23
# @Last Modified by:   Mark S. Miller
# @Last Modified time: 2017-06-22 16:22:18
#
# Copyright (c) 2017 Silicon Chisel / Mark S. Miller

module SharpstoneCaptcha

  require 'active_support/core_ext/integer/inflections'
  require 'active_support/inflector'
  require 'active_support/message_encryptor'
  require 'active_support/message_verifier'

  MONTHNAMES = [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

  # The key is optional if you (a) don't want to use the default or (b) are running tests

  def self.verify_captcha(params, key=nil)
    key ||= Rails.application.secrets.secret_key_base
    if params[:ssc_captcha_answer] && params[:ssc_captcha_id]
      # m,d = self.crypt_out(params[:ssc_captcha_id], key).split("-")
      # if (m.to_i + d.to_i) == params[:ssc_captcha_answer].to_i
      expr = self.crypt_out(params[:ssc_captcha_id], key)
      if expr && (eval(expr) == params[:ssc_captcha_answer].to_i)
        return true
      end
    end
    return false
  end

  def self.data_for_form(key=nil)
    key ||= Rails.application.secrets.secret_key_base
    d = Time.now.day
    m = Time.now.month

    { 
      :ssc_captcha_id => self.crypt_in("#{m} + #{d}", key),
      :ssc_captcha_string => "Today is the #{Time.now.day.ordinalize} of #{SharpstoneCaptcha::MONTHNAMES[m]}"
    }
  end

  #### UTILITY FUNCTIONS ####

private

  # For captcha support - see: http://stackoverflow.com/questions/5492377/encrypt-decrypt-using-rails
  def self.crypt_in(s, k)
    crypt = ActiveSupport::MessageEncryptor.new(k)
    crypt.encrypt_and_sign(s)
  end

  def self.crypt_out(s, k)
    crypt = ActiveSupport::MessageEncryptor.new(k)
    crypt.decrypt_and_verify(s)
  end

end


=begin
require 'sharpstone_captcha'

# key will usually be: Rails.application.secrets.secret_key_base

k = "qoeuryfhowe8gnwr78t0948cgcnmerwhgxhr4gcmrshgr8hg85hg89hr8hgrt"
scp = SharpstoneCaptcha.data_for_form(k)
p scp.inspect
scp[:ssc_captcha_answer] = "28"
SharpstoneCaptcha.verify_captcha(scp, k)

=end
