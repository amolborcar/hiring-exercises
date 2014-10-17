require 'csv'
require 'debugger'
# create method to analyze CSV files

def match_records
  # user input for filename
  puts "Please enter the .csv file you want to analyze."
  file = gets.chomp

  while file[-4..-1] != ".csv" do
    puts "Please enter a valid .csv file, including the extension."
    file = gets.chomp
  end

  # read in csv file
  inputs = []
    # if not a csv file, throw error?
  CSV.foreach(file, :headers => true) do |row|
    inputs << row.to_hash
  end

  # user input for matching identifier
  puts "Please enter the identifier you want to match by (phone or email)."
  identifier = gets.chomp
  while identifier != "phone" && identifier != "email" do
    puts "Please enter either 'phone' or 'email' as an identifier."
    identifier = gets.chomp
  end

  # if identifier is phone, run match_phone method
  # if identifier is email, run match_email method
  case identifier
    when "phone"
      outputs = match_phone(inputs)
    when "email"
      outputs = match_email(inputs)
  end

  # output new csv
  create_output_file(outputs)

end

def match_phone(input_rows)
  id_counter = 1

  phone_fields = input_rows[0].keys.select { |key| key.match(/^Phone[0-9]?$/) }
  all_phones = {}

  input_rows.each do |row|
    customer_phones = []

    phone_fields.map do |field|
      if row[field] != nil
        # This regex will match the final 10 digits, excluding special characters and will delete an optional 1 at the beginning
        customer_phones << row[field].match(/^([0-9]{0,1})[ .-]?\(?([0-9]{3})\)?[ .-]?([0-9]{3})[ .-]?([0-9]{4})$/).captures[1..3].join('')
      end
    end

    matched_index = nil

    customer_phones.each_with_index do |phone, index|
      if all_phones.has_key?(phone)
        matched_index = index
        break
      end
    end

    if matched_index != nil
      row['CustomerID'] = all_phones[customer_phones[matched_index]]
    else
      # set all the phone numbers in that customer equal to the current id counter
      customer_phones.each do |phone_num|
        all_phones[phone_num] = id_counter
      end
      # all_phones[customer_phones[0]] = id_counter
      row['CustomerID'] = id_counter
      id_counter += 1
    end

  end

  return input_rows

end


def match_email(input_rows)
  id_counter = 1

  email_fields = input_rows[0].keys.select { |key| key.match(/^Email[0-9]?$/) }
  all_emails = {}

  input_rows.each do |row|
    customer_emails = email_fields.map { |field| row[field] }.compact
    matched_index = nil

    # check to see if any of the emails have already been found
    customer_emails.each_with_index do |email, index|
      if all_emails.has_key?(email)
        matched_index = index
        break
      end
    end

    # if a customer registered an email already in use, use that email's ID, else create a new one using the customer's Email1
    if matched_index != nil
      row['CustomerID'] = all_emails[customer_emails[matched_index]]
    else
      all_emails[customer_emails[0]] = id_counter
      row['CustomerID'] = id_counter
      id_counter += 1
    end

  end

  return input_rows

end

def create_output_file(outputs)
  column_names = outputs.first.keys.rotate(-1)
  CSV.open("output.csv", "wb") do |output_file|
    output_file << column_names
    outputs.each do |row|
      output_file << row.values.rotate(-1)
    end
  end
end

match_records