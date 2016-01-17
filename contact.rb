require 'csv'
require 'pry'
# require 'contacts'

# Represents a person in an address book.
class Contact
  
  @@contacts = CSV.read('contacts.csv')
  attr_accessor :name, :email, :phones

  def initialize(name, email, phones)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
    @phones = phones
  end



  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      num_records = CSV.open('contacts.csv', 'r').readlines.count
      CSV.foreach('contacts.csv') do |row|
        puts row.to_s
      end
      puts "#{num_records} records total"
    end

    def email_duplicate?(email)
        #returns true or false if a row in the file includes the email address 
        @@contacts.any? {|row| row[2].include?(email)}  
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name,email,phones)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      phones_string = phones.join("*")
      # puts phones_string
      num_records = CSV.open('contacts.csv','r').readlines.count
      # contact_array = CSV.read('contacts.csv') 
      # contact_array.each do |row|
      if email_duplicate?(email)
         puts "A contact with this email address already exists! Contact can not be created."
      # CSV.foreach('contacts.csv') do |row|
      #     # if row[2].include?(email) 
      #     #    puts "A contact with this email address already exists! Contact can not be created."
      #     #     return true 
      else 
            CSV.open('contacts.csv', 'a+') do |csv|
              csv << [num_records+1,name,email,phones_string]
            end
            puts "New contact has been created. The Id of the new contact is #{num_records+1}"
      end
    end




    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      output = nil
      CSV.foreach('contacts.csv', 'r') do |row|
        # if row[0] == id 
        #   puts row.to_s.split(",")
         if row[0] == id 
          output =  row.to_s.split(",")
        end

       end
       puts output ? output : "Not Found!"
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    CSV.foreach('contacts.csv', 'r') do |row|
      if row[1].downcase.include?(term) || row[2].downcase.include?(term) 
         puts row.to_s
       else 
        puts "The search term does not exit within the contact list!"
      end
    end
  end

  end

end

