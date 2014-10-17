require 'csv'

class RecordMatcher

  def match_records
    inputs = []
    puts "Please enter the .csv file you want to analyze."
    file = check_for_valid_csv_file
    CSV.foreach(file, :headers => true) do |row|
      inputs << row.to_hash
    end

    puts "Please enter the identifier you want to match by (phone or email)."
    identifier = check_for_valid_identifier

    case identifier
      when "phone"
        outputs = match_phone(inputs)
      when "email"
        outputs = match_email(inputs)
    end
    create_output_file(outputs)
  end

private

  def check_for_valid_csv_file
    filename = gets.chomp
    while filename[-4..-1] != ".csv" do
      puts "Please enter a valid .csv file, including the extension."
      filename = gets.chomp
    end
    return filename
  end

  def check_for_valid_identifier
    identifier = gets.chomp.downcase
    while identifier != "phone" && identifier != "email" do
      puts "Please enter either 'phone' or 'email' as an identifier."
      identifier = gets.chomp
    end
    return identifier
  end

  def match_phone(input_rows)
    id_counter = 1
    phone_fields = input_rows[0].keys.select { |key| key.match(/^Phone[0-9]?$/) }
    all_phones = {}
    input_rows.each do |row|
      customer_phones = extract_raw_phone_numbers(phone_fields, row)
      matched_index = check_for_matches(all_phones, customer_phones)
      id_counter = assign_id_to_customer(row, all_phones, customer_phones, matched_index, id_counter)
    end
    return input_rows
  end

  def match_email(input_rows)
    id_counter = 1
    email_fields = input_rows[0].keys.select { |key| key.match(/^Email[0-9]?$/) }
    all_emails = {}
    input_rows.each do |row|
      customer_emails = email_fields.map { |field| row[field] }.compact
      matched_index = check_for_matches(all_emails, customer_emails)
      id_counter = assign_id_to_customer(row, all_emails, customer_emails, matched_index, id_counter)
    end
    return input_rows
  end

  def extract_raw_phone_numbers(phone_fields, row)
    customer_phones = []
    phone_fields.map do |field|
      if row[field] != nil
        # This regex will match the final 10 digits, excluding special characters
        customer_phones << row[field].match(/^([0-9]{0,1})[ .-]?\(?([0-9]{3})\)?[ .-]?([0-9]{3})[ .-]?([0-9]{4})$/).captures[1..3].join('')
      end
    end
    return customer_phones
  end

  def check_for_matches(found_values, customer_values)
    matched_index = nil
    customer_values.each_with_index do |value, index|
      if found_values.has_key?(value)
        matched_index = index
        break
      end
    end
    return matched_index
  end

  def assign_id_to_customer(row, all_values, customer_values, matched_index, id_counter)
    if matched_index != nil
      row['CustomerID'] = all_values[customer_values[matched_index]]
      # if the customer had another unmatched value, set that equal to the same id
      all_values[(customer_values-[customer_values[matched_index]])[0]] = all_values[customer_values[matched_index]] if customer_values.length > 1
    else
      # set all the values for that customer equal to the current id counter
      customer_values.each do |value|
        all_values[value] = id_counter
      end
      row['CustomerID'] = id_counter
      id_counter += 1
    end
    return id_counter
  end

  def create_output_file(outputs)
    column_names = outputs.first.keys.rotate(-1)
    CSV.open("output.csv", "wb") do |output_file|
      output_file << column_names
      outputs.each do |row|
        output_file << row.values.rotate(-1)
      end
    end
    puts "Success! Output file created as #{Dir.pwd}/output.csv"
  end
end

matcher = RecordMatcher.new
matcher.match_records