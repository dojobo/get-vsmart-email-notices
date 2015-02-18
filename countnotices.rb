require 'fileutils'

ARGV.each { |a|
	notices = Dir.entries("notices/#{a}")	# get all file names in notices/ and put them in an array
	tendays = 0
	onedays = 0
	reservations = 0
	invoices = 0
	notices.each { |file|
		File.chmod(0200, file)
		contents = File.read(file)
		if contents =~ /10 day overdue notice/i then
			tendays += 1
		end
		if contents =~ /first overdue notice/i then
			onedays += 1
		end
		if contents =~ /reservation notice/i then
			reservations += 1
		end
		if contents =~ /long overdue notice/i then
			invoices += 1
		end
	}
	puts "1-day overdues: #{onedays}"
	puts "10-day overdues: #{tendays}"
	puts "reservations: #{reservations}"
	puts "invoices: #{invoices}"
}