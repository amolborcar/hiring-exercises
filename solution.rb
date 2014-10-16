require 'csv'
require 'debugger'
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
  identifier = gets.chomp
  while identifier != "phone" && identifier != "email" do
    puts "Please enter either 'phone' or 'email' as an identifier."
    identifier = gets.chomp
  end

  # if identifier is phone, run match_phone method
  case identifier
    when "phone"
      match_phone(inputs)
    when "email"
      match_email(inputs)
  end

  # if identifier is email, run match_email method

  # output new csv

end

def match_phone(input_rows)
  puts "You matched phone!"
  id_counter = 1
  phones = {}

  input_rows.each do |row|
    # This regex will match the final 10 digits, excluding special characters and will delete an optional 1 at the beginning
    if row['Phone'] != nil
      phone_digits = row['Phone'].match(/^([0-9]{0,1})[ .-]?\(?([0-9]{3})\)?[ .-]?([0-9]{3})[ .-]?([0-9]{4})$/).captures[1..3].join('')
    else
      phone_digits = nil
    end

    if !phones.has_key?(phone_digits)
      phones[phone_digits] = id_counter
      row['id'] = phones[phone_digits]
      id_counter += 1
    else
      row['id'] = phones[phone_digits]
    end
  end

  return input_rows

end


def match_email(input_rows)
  puts "You matched email!"
  id_counter = 1

  emails = {}
  input_rows.each do |row|
    if !emails.has_key? (row['Email'])
      emails[row['Email']] = id_counter
      row['id'] = emails[row['Email']]
      id_counter += 1
    else
      row['id'] = emails[row['Email']]
    end
  end

  return input_rows

end

match_records