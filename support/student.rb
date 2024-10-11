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
    @course_identifier = nil
    @errors = {}
  end

  def generate_unique_student_id
    begin
      # generate a student_id
      @student_id = generate_student_id
      # check if this student_id already exists
      student_records = FileHelper.read_file(file_path: Constants::RECORDS_FILE_PATH)
      student_records.each do |student_record|
        raise DuplicateStudentIdError if @student_id == student_record[:student_id]
      end
    rescue DuplicateStudentIdError
      retry
    end
  end

  private

  def check_records_file_exists
    begin
      # Open the records.csv file and check to see if this student_id already exists
      student_records = FileHelper.read_file(file_path: Constants::RECORDS_FILE_PATH)
    rescue FileNotFoundError
      # if the file does not exist then we want to create it with headers
      puts 'File does not exist, creating it...'
      student_records = FileHelper.create_file(file_path: './course-designations/records.csv')
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
