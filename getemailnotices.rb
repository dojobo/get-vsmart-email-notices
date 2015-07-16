require 'date'
require 'net/ftp'
require 'fileutils'
require 'psych'

credentialspath = __dir__ + '/credentials.yml'
credentials = Psych.load_file(credentialspath) 
server = credentials['server']
user = credentials['username']
pass = credentials['password']

Net::FTP.open(server) do |ftp|
	ftp.login(user, pass)
	print "connected to #{server} - "
	puts ftp.pwd
	#filelist = %w(em10* em11* em12* em13* em14* em15* em16* em17* em18* em19* em20* em21* em22* em23*).each_with_object([]) { |range, filelist|
	filelist = %w(em20* em21* em22* em23*).each_with_object([]) { |range, filelist|
  	begin
    	filelist.concat ftp.nlst(range)
  	rescue Net::FTPPermError
  	end
	}
	ARGV << Date.today.to_s if ARGV.empty?		# if no argument is given on command line, default to today's date
	ARGV.each { |a|		# for each command-line arg, i.e. date...
		todaysnoticedir = __dir__ + "/notices/#{a}"
		FileUtils.mkdir_p(todaysnoticedir)
		checkdate = Date.parse(a)
		puts checkdate
		count = 0
		filelist.each { |file|
			if ftp.mtime(file).to_date == checkdate then	# compare file's mtime to supplied check date
				puts "getting #{file}..."
				localpath = __dir__ + "/notices/#{a}/#{file}"
				begin
					ftp.gettextfile(file, localpath)
				rescue Net::FTPReplyError
					puts "Couldn't get #{file}!"
				end
				count += 1
			end
		}
		puts "total count: #{count}"
	}

	ftp.close
end