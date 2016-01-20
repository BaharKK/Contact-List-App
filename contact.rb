# require 'csv'
require 'pry'
require 'pg'
# require 'contacts'

# Represents a person in an address book.
class Contact
  @@conn = nil
  # @@contacts = CSV.read('contacts.csv')
  attr_accessor :name, :email, :phones
  attr_reader :id

  def to_s
    "id: #{id}, name: #{name}, email: #{email}"
  end

  def initialize(name, email,id=nil)
    # TODO: Assign parameter values to instance variables.
    @id = id 
    @name = name
    @email = email
    # @phones = phone
  end

  def destroy
    #we need self.class.connection to access class method
    res = self.class.connection.exec_params('DELETE FROM contacts WHERE id = $1::int;',[id])
  end

  def save 
    if persisted? 
      res = self.class.connection.exec_params('UPDATE contacts SET name= $1, email = $2 WHERE id = $3::int;',[name,email,id])
      # @id = res[2]['id']
    else
      res = self.class.connection.exec_params('INSERT INTO contacts(name,email) VALUES ($1,$2) RETURNING id',[name,email])
      @id = res[2]['id']
    end
  end

  def persisted?
    !id.nil? 
  end

  class << self

    def connection
      if @@conn.nil?
        @@conn = PG.connect(
          host: 'localhost',
          dbname: 'contact_list',
          user: 'development',
          password: 'development'
          ) 
      end
      @@conn
    end



  # Provides functionality for managing a list of Contacts in a database.
  

    # Returns an Array of Contacts loaded from the database.
    def all
      res = connection.exec_params('SELECT * FROM contacts ORDER BY id;')
      arr = []
      res.each do |results| 
        # results.each do |contact|
        contact = Contact.new(results['name'],results['email'],results['id'])
        arr.push(contact)
        # end
      end
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      # num_records = CSV.open('contacts.csv', 'r').readlines.count
      # CSV.foreach('contacts.csv') do |row|
      #   puts row.to_s
      # end
      # puts "#{num_records} records total"
      arr
    end

    def email_duplicate?(email)
      #returns true or false if a row in the file includes the email address 
      @@contacts.any? {|row| row[2].include?(email)}  
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name,email)
    # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
    # phones_string = phones.join("*")
    # # puts phones_string
    # num_records = CSV.open('contacts.csv','r').readlines.count

    ##contact_array = CSV.read('contacts.csv') 
    ##contact_array.each do |row|
    # if email_duplicate?(email)
    #    puts "A contact with this email address already exists! Contact can not be created."
    ## CSV.foreach('contacts.csv') do |row|
    ##     # if row[2].include?(email) 
    ##     #    puts "A contact with this email address already exists! Contact can not be created."
    ##     #     return true 
    # else 
    #       CSV.open('contacts.csv', 'a+') do |csv|
    #         csv << [num_records+1,name,email,phones_string]
    #       end
      res = connection.exec_params('SELECT * FROM contacts WHERE email = $1',[email])
      if res.num_tuples.zero?
        new_contact = Contact.new(name,email) 
        new_contact.save 
        puts "New contact has been created. The Id of the new contact is #{new_contact.id}"
        new_contact
      else
        puts "A contact with this email address already exists! Contact can not be created."
      end
    end



    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      res = connection.exec_params('SELECT * FROM contacts WHERE id = $1::int;',[id])
      unless res.num_tuples.zero? 
        person = Contact.new(res[0]['name'],res[0]['email'],res[0]['id'])
        person 
      end
    end
    #   output = nil
    #   CSV.foreach('contacts.csv', 'r') do |row|
    #     # if row[0] == id 
    #     #   puts row.to_s.split(",")
    #     if row[0] == id 
    #       output =  row.to_s.split(",")
    #     end

    #   end
    #   puts output ? output : "Not Found!"
    # end

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
# Contact.all