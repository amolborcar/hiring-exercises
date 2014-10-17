################################################
Instructions for Using My Solution
################################################

The user should begin by running the program from the Terminal/Command Line using Ruby.
```
ruby solution.rb
```
The user will then be prompted to enter a CSV filename (enter the full path, if the file is in another folder) and a matching identifier (phone or email).

The program loads the CSV file into an array of hashes, each hash being a row of data.

If the user enters phone as the identifier, the code will parse out 10-digit phone numbers from the customer's phone fields.
  * If the customer submitted only phone numbers that were not used by any other customer, that customer will be assigned a new CustomerID.
  * If either of the customer's phone numbers were used by another customer, the customer will be assigned the original customer's CustomerID and any additional phone numbers will also be assigned that CustomerID.
  * This makes an assumption that the CSV file is sorted ascending, so that the oldest customers have the first rows of data.

Email matching works the same way as phone matching, except that emails are matched as exact string (without any parsing).

After parsing the files, a new CSV file will be outputted with a CustomerID as the first column and the remaining data unchanged.  The file will be outputted as output.csv in the same folder as solution.rb.