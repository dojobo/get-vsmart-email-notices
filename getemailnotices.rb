require 'date'
require 'net/ftp'

server = "SERVER ADDRESS"
user = "USERNAME"
pass = "PASSWORD"

Net::FTP.open(server) do |ftp|
	ftp.login(user, pass)
	print "connected to #{server} - "
	puts ftp.pwd
	#ftp.chdir('OverDrive/')
	filelist = ftp.list('em191*')
	puts filelist
	filelist.each { |file| 
		puts ftp.mtime(file).to_date

	}
=begin
	ARGV.each { |a|			# main loop, iterates over each command-line arg
		checkdate = Date.parse(a)	# convert arg to date
		puts checkdate
		count = 0
		# date comparison
		filelist.each { |file| 
			puts ftp.mtime(file)
			#if ftp.mtime(file).to_date == checkdate then
			#	puts "#{file} has mtime of #{checkdate}"
			#	count += 1
			#end
		}
		puts "total count: #{count}"
	}
=end

	ftp.close
end