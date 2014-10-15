require 'csv'
# create method to analyze CSV files

def match_records
  # user input for filename
  puts "Please enter the file you want to analyze."
  file = gets.chomp
  # read in csv file
  inputs = []
    # if not a csv file, throw error?
  CSV.foreach(file, :headers => true) do |row|
    inputs << row.to_hash
  end

  p inputs

  # user input for matching identifier
  puts "Please enter the identifier you want to match by (phone or email)."
  identifier = gets.chomp.downcase
  while identifier != ("phone" || "email")
    puts "Please enter either 'phone' or 'email' as an identifier."
    identifier = gets.chomp
  end


  # if identifier is phone, run match_phone method
  case identifier
    when "phone"
      match_phone(file)
    when "email"
      match_email(file)
  end

  # if identifier is email, run match_email method

  # output new csv

end

def match_phone(filename)
  # use regex to extract 10 digit phone number, excluding special chars
  puts "You matched phone!"

end

def match_email(filename)
  puts "You matched email!"

end

match_records