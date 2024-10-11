# A college has a simple enrolment system which records the following information for new students:
# student ID, first name, last name(s), and an identifier for the course they are enrolling on.
# The student IDs follow a format of 3 upper case letters (A to Z but not including O or I) then 4 numbers (0 to 9)

require 'csv'
require_relative 'support/errors'
require_relative 'support/student'

# config = DVLA::Herodotus.config do |configuration|
#   configuration.display_pid = true
# end
# LOG = DVLA::Herodotus.logger('College Enrolment System', config:)
# LOG.level = Logger.const_get('DEBUG')
def main
  running = true
  while running
    # we run the program - we can set running to false to exit the program
    puts 'add - add a new student'
    puts 'exit - exit the program'
    puts 'Please enter an option: '
    user_response = gets.chomp # 'exit' command will set running to false and exit the program
    case user_response
    when 'add'
      # ask user for details...
      puts 'Enter first name: '
      first_name = gets.chomp
      puts 'Enter last name: '
      last_name = gets.chomp
      student = Student.new(first_name: first_name, last_name: last_name)
      # generate student_id
      student.generate_unique_student_id
    when 'exit'
      running = false
    else
      raise UnknownOptionError, 'The user has entered an invalid option'
    end
  end
end

main
