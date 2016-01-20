require_relative 'contact.rb'


# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
    def initialize
        argv_menu 
    end 

    def menu 
        "\nHere is a list of available commands:\n"\
        "new             -Create a new contact\n"\
        "list            -List all contacts\n"\
        "show            -Show a contact\n"\
        "search          -Search contacts\n"\
        "update          -Update contacts\n"\
        "quit            -Quit application\n"

    end

    def greet 
        puts "Hello! Welcome to my Contact App"
    end


    def argv_menu 
    # case choice
    puts ARGV[0]
    case ARGV[0]
        when "new"
            puts "Please Enter Your Full Name: "
            fullname = STDIN.gets.chomp
            puts "Please Enter Your Full Email Address: "
            email = STDIN.gets.chomp
            # puts "Please Enter Your Phone Number Label and Phone Number separating them with a "":"" "
            # phones = $stdin.gets.chomp.split(' ')
            # phones = gets.chomp.split(' ')
            Contact.create(fullname,email)
            exit 
        when "list"
                Contact.all.each do |contact|
                    puts contact
                end
                exit 

        when "show"
            # puts "Please Enter The Id Of The Contact You Are Looking For: "
            # contact_id = gets.chomp 
            # Contact.find(contact_id)
            con_id = ARGV[1] 
            person = Contact.find(con_id)
             if person
                puts person
             else
                 puts "No contact with id #{con_id} found"
             end
            exit 

        when "search"
            term1 = ARGV[1].downcase
            Contact.search(term1)
            exit 

        when "update"
            con_id = ARGV[1]
            contact = Contact.find(con_id)
            if (contact)
                puts "Please enter the new full name to be updated: "
                fulluname = STDIN.gets.chomp
                puts "Please Enter the new email to be updated: "
                email = STDIN.gets.chomp   
                contact.name = fulluname
                contact.email = email
                contact.save
            end
            exit
        when "destroy"
            con_id = ARGV[1]
            contact = Contact.find(con_id)
            if(contact)
                contact.destroy 
            end
            exit

        when "quit"
            exit
        else
           greet
           menu
        end
    end 
end 
contactlist = ContactList.new 
# contactlist.greet
STDIN.gets.chomp.split(" ")

# end 

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  


