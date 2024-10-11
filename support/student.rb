# A college has a simple enrolment system which records the following information for new students:
# student ID, first name, last name(s), and an identifier for the course they are enrolling on.
# The student IDs follow a format of 3 upper case letters (A to Z but not including O or I) then 4 numbers (0 to 9)
require 'faker'

require_relative 'constants'
require_relative 'file_helper'

class Student
  attr_reader :student_id
  attr_accessor :first_name, :last_name, :course_identifier

  def initialize(first_name:, last_name:)
    @student_id = nil
    @first_name = first_name
    @last_name = last_name
    @course_identifier = []
    @errors = {}
  end

  def add_student
    check_records_file_exists
    generate_unique_student_id
    add_course
    student_to_add = convert_instance_variables_to_strings
    confirm = FileHelper.write_file(file_path: Constants::RECORDS_FILE_PATH, student: student_to_add)
    courses = lookup_course(course_identifier: @course_identifier)
    if confirm
      puts "New student: #{@first_name.capitalize} #{@last_name.capitalize} has been added and enrolled onto #{courses.join(', ')}"
    end
  end

  private

  def lookup_course(course_identifier:)
    return_array = []
    courses = FileHelper.read_file(file_path: Constants::COURSES_FILE_PATH)
    courses.each do |course|
      course_identifier.find do |identifier|
        if course[:identifier] == identifier.to_s.upcase
          return_array << course[:_course].strip
          next
        end
      end
    end
    return_array
  end

  def add_course
    # get list of available courses
    courses = FileHelper.read_file(file_path: Constants::COURSES_FILE_PATH)

    begin
      running = true
      while running
        puts 'Enter course identifier:'
        course_identifier = gets.chomp
        unless courses[:identifier].include?(course_identifier)
          raise NoSuchCourseError, "Course not available: #{course_identifier}"
        end
        @course_identifier << SimpleSymbolize.symbolize(course_identifier)
        puts 'Do you want to enrol on another course? (y/n)'
        user_response = gets.chomp.downcase
        unless %w[y n].include?(user_response)
          raise InvalidResponseError, "Invalid response: #{user_response}. Please try again"
        end
        running = false if user_response == 'n'
      end
    rescue InvalidResponseError, NoSuchCourseError => e
      puts e.message
      retry
    end
  end

  def generate_unique_student_id
    retry_count = 0
    begin
      # generate a student_id
      @student_id = generate_student_id
      # check if this student_id already exists
      student_records = FileHelper.read_file(file_path: Constants::RECORDS_FILE_PATH)
      raise DuplicateStudentIdError if student_records[:student_id].include?(@student_id)
    rescue DuplicateStudentIdError
      if retry_count <= 10
        retry_count += 1
        retry
      else
        @errors[:duplicate_student_id] = :duplicate_student_id
      end
    end
  end

  def check_records_file_exists
    begin
      # Open the records.csv file and check to see if this student_id already exists
      student_records = FileHelper.read_file(file_path: Constants::RECORDS_FILE_PATH)
    rescue FileNotFoundError
      # if the file does not exist then we want to create it with headers
      puts 'File does not exist, creating it...'
      student_records = FileHelper.create_file(file_path: Constants::RECORDS_FILE_PAT)
    end
    student_records
  end

  def generate_student_id
    Faker::Base.regexify(Constants::VALID_STUDENT_ID_FORMAT)
  end

  def convert_instance_variables_to_strings
    self.instance_variables.map { |attribute| self.instance_variable_get(attribute).to_s }
  end
end
