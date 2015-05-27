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
	begin
		#filelist12 = ftp.nlst('em12*') # kludge to get around ftp server's limits; add to these as necessary
		#filelist13 = ftp.nlst('em13*')
		#filelist14 = ftp.nlst('em14*')
		#filelist15 = ftp.nlst('em15*')
		#filelist16 = ftp.nlst('em16*')
		#filelist17 = ftp.nlst('em17*')
		#filelist18 = ftp.nlst('em18*')
		#filelist19 = ftp.nlst('em19*')
		filelist20 = ftp.nlst('em20*')
		filelist21 = ftp.nlst('em21*')
	rescue Net::FTPPermError
		puts "Filename scope larger than existing files."
		filelist21 = []
	end
	#allfiles = filelist12 + filelist13 + filelist14 + filelist15 + filelist16 + filelist17 + filelist18 + filelist19 + filelist20 + filelist21
	allfiles = filelist20 + filelist21
	ARGV << Date.today.to_s if ARGV.empty?		# if no argument is given on command line, default to today's date
	ARGV.each { |a|		# for each command-line arg, i.e. date...
		FileUtils.mkdir_p("notices/#{a}")
		checkdate = Date.parse(a)
		puts checkdate
		count = 0
		allfiles.each { |file|
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