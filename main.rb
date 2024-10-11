# A college has a simple enrolment system which records the following information for new students:
# student ID, first name, last name(s), and an identifier for the course they are enrolling on.
# The student IDs follow a format of 3 upper case letters (A to Z but not including O or I) then 4 numbers (0 to 9)

require 'csv'
require_relative 'support/errors'
require_relative 'support/student'

def main
  running = true
  begin
    while running
      # we run the program - we can set running to false to exit the program
      puts 'add - add a new student'
      puts 'exit - exit the program'
      print 'Please enter an option: '
      user_response = gets.chomp.downcase # 'exit' command will set running to false and exit the program
      case user_response
      when 'add'
        # ask user for details...
        puts 'Enter first name: '
        first_name = gets.chomp.capitalize
        puts 'Enter last name: '
        last_name = gets.chomp.capitalize
        student = Student.new(first_name: first_name, last_name: last_name)

        student.add_student
      when 'exit'
        running = false
      else
        raise UnknownOptionError, "Invalid option entered: #{user_response}. Please select a valid option below...\n\n"
      end
    end
  rescue UnknownOptionError => e
    puts e.message
    retry
  end
end

main
