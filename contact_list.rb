require_relative 'contact'


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
        "quit            -Quit application\n"

    end

    def greet 
        puts "Hello! Welcome to my Contact App"
    end


def argv_menu 
# case choice
case ARGV[0]
        when "new"
            puts "Please Enter Your Full Name: "
            fullname = $stdin.gets.chomp
            puts "Please Enter Your Full Email Address: "
            email = $stdin.gets.chomp
            puts "Please Enter Your Phone Number Label and Phone Number separating them with a "":"" "
            phones = $stdin.gets.chomp.split(' ')
            # phones = gets.chomp.split(' ')
            Contact.create(fullname,email,phones)
            exit 
        when "list"
                Contact.all
                exit 
        when "show"
            # puts "Please Enter The Id Of The Contact You Are Looking For: "
            # contact_id = gets.chomp 
            # Contact.find(contact_id)
            con_id = ARGV[1]
            puts con_id 
            Contact.find(con_id)
            exit 
        when "search"
            term1 = ARGV[1].downcase
            Contact.search(term1)
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
contactlist.greet
gets.chomp.split(" ")

# end 

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  


