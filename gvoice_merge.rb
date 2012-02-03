require 'rubygems'
require 'googlevoiceapi'
require 'csv'

@user = 'your@gmail.com'
@pass = 'yourgmailpassword'
@salutation = 'Hey'
@message = "are you coming to AIESEC's info session tonight?"

# A simple hack for SSL issues in Windows
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# Signs into your Google account, does not work with two step verification
# Tried to add that support but couldn't get it to work
api = GoogleVoice::Api.new(@user, @pass)

# Reads the CSV into an array of hashes
csv_data = CSV.read 'test.csv'
headers = csv_data.shift.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
names = string_data.map {|row| Hash[*headers.zip(row).flatten] }

# Basically loops the array of hashes and sends out the message
names.each do |n|
  number = n["Mobile Phone"]
  name = n["First Name"]
  api.sms(number, @salutation + ' ' + name + ' ' + @message)
end
