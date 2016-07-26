require 'openssl'

key = ARGV[0] || ENV['AWS_SECRET_KEY']
dateStamp = ARGV[1] || Time.now.strftime("%Y%m%d")
regionName = ARGV[2] || 'us-east-1'
serviceName = ARGV[3] || 's3'

# puts "#{ENV['AWS_ACCESS_KEY']}/#{dateStamp}/#{regionName}/#{serviceName}/aws4_request"
# puts key

def getSignatureKey key, dateStamp, regionName, serviceName
  initial = "AWS4#{key}"
  [dateStamp, regionName, serviceName, "aws4_request"].inject(initial) do |key, data|
    OpenSSL::HMAC.digest("sha256", key, data)
  end
end

def hexEncode bindata
  result=""
  data=bindata.unpack("C*")
  data.each {|b| result+= "%02x" % b}
  result
end

puts hexEncode(getSignatureKey(key, dateStamp, regionName, serviceName))
