# Instapaper -> Kindle importer
# This script downloads kindle-formatted articles from your instapaper account and forwards them to your kindle via email
#
# Instalation:
# - configure this script
# - install mail gem
# - run this script
#
# Mantas Masalskis, mantas@idev.lt
# http://github.com/mantas/instapaper-kindle

require 'rubygems'
require 'mail'

instapaper_user = "mantas" # your instapaper login
instapaper_password = "instapaper_password" # your instapaper password

from_email = 'some@email.com' # your email
kindle_name = 'kindle' # your kindle id. As in kindle_name@free.kindle.com

# SMTP configuration
smtp_config = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    #:domain               => 'domain.com', uncomment this if you're using hosted google apps
    :user_name            => 'kindle@domain.com',
    :password             => 'kindle',
    :authentication       => 'plain',
    :enable_starttls_auto => true 
  }

`wget --delete-after --cookies=on --save-cookies=cookie.txt --post-data="username=#{instapaper_user}&password=#{instapaper_password}" http://www.instapaper.com/user/login`
`wget -O instapaper.mobi --cookies=on --load-cookies=cookie.txt http://www.instapaper.com/mobi`

File.delete("cookie.txt")

mail = Mail.new do
  from from_email
  to "#{kindle_name}@free.kindle.com"
  subject 'Kindle upload'
  body ""
  add_file ({:filename => 'instapaper.mobi', :content => File.read('instapaper.mobi')})
end

mail.delivery_method :smtp , smtp_config

mail.deliver!

File.delete("instapaper.mobi")

