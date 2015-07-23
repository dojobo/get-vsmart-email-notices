require 'date'
require 'net/ftp'
require 'fileutils'
require 'psych'
require 'retries'

credentialspath = __dir__ + '/credentials.yml'
credentials = Psych.load_file(credentialspath) 
server = credentials['server']
user = credentials['username']
pass = credentials['password']

Net::FTP.open(server) do |ftp|
	ftp.login(user, pass)
	print "connected to #{server} - "
	puts ftp.pwd
	# modify filelist pattern as necessary:
	#filelist = %w(em10* em11* em12* em13* em14* em15* em16* em17* em18* em19* em20* em21* em22* em23*).each_with_object([]) { |range, filelist|
	filelist = %w(em20* em21* em22* em23*).each_with_object([]) do |range, filelist|
  	begin
    	filelist.concat ftp.nlst(range)
    # handle exceptions resulting from nlst requests with zero results:
  	rescue Net::FTPPermError
  	end
	end
	ARGV << Date.today.to_s if ARGV.empty?		# if no argument is given on command line, default to today's date
	ARGV.each do |a|		# for each command-line arg, i.e. date...
		todaysnoticedir = __dir__ + "/notices/#{a}"
		FileUtils.mkdir_p(todaysnoticedir)
		checkdate = Date.parse(a)
		puts checkdate
		count = 0
		filelist.each do |file|
			if ftp.mtime(file).to_date == checkdate then	# compare file's mtime to supplied check date
				begin
					# try each file up to 3 times, rescuing for timeouts
					with_retries(:max_tries => 3, :rescue => [Net::FTPReplyError, Net::ReadTimeout]) do |attnum|
						puts "getting #{file} (attempt ##{attnum})..."
						localpath = __dir__ + "/notices/#{a}/#{file}"
						ftp.gettextfile(file, localpath)
					end
				# in case all three attempts fail, rescue and move on to next file:
				rescue Net::FTPReplyError
					puts "#{file} failed"
				rescue Net::ReadTimeout
					puts "#{file} failed"
				end
				count += 1
			end
		end
		puts "total count: #{count}"
	end 

	ftp.close
end