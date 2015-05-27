require 'date'
require 'net/ftp'
require 'fileutils'
require 'psych'

credentials = Psych.load_file('credentials.yml') 
server = credentials['server']
user = credentials['username']
pass = credentials['password']

Net::FTP.open(server) do |ftp|
	ftp.login(user, pass)
	print "connected to #{server} - "
	puts ftp.pwd
	filelist = %w(em20* em21*).each_with_object([]) { |range, filelist|
  	begin
    	filelist.concat ftp.nlst(range)
  	rescue Net::FTPPermError
  	end
	}
	ARGV << Date.today.to_s if ARGV.empty?		# if no argument is given on command line, default to today's date
	ARGV.each { |a|		# for each command-line arg, i.e. date...
		FileUtils.mkdir_p("notices/#{a}")
		checkdate = Date.parse(a)
		puts checkdate
		count = 0
		filelist.each { |file|
			if ftp.mtime(file).to_date == checkdate then	# compare file's mtime to supplied check date
				puts "getting #{file}..."
				localpath = "notices/#{a}/#{file}"
				ftp.gettextfile(file, localpath)
				count += 1
			end
		}
		puts "total count: #{count}"
	}

	ftp.close
end