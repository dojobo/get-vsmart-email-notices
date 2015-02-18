require 'date'
require 'net/ftp'
require 'fileutils'

server = "SERVER ADDRESS"
user = "USERNAME"
pass = "PASSWORD"

Net::FTP.open(server) do |ftp|
	ftp.login(user, pass)
	print "connected to #{server} - "
	puts ftp.pwd
	filelist12 = ftp.nlst('em12*') # kludge to get around ftp server's limits; add to these as necessary
	filelist13 = ftp.nlst('em13*')
	filelist14 = ftp.nlst('em14*')
	filelist15 = ftp.nlst('em15*')
	filelist16 = ftp.nlst('em16*')
	filelist17 = ftp.nlst('em17*')
	filelist18 = ftp.nlst('em18*')
	filelist19 = ftp.nlst('em19*')
	allfiles = filelist12 + filelist13 + filelist14 + filelist15 + filelist16 + filelist17 + filelist18 + filelist19
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