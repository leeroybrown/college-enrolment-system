# A college has a simple enrolment system which records the following information for new students:
# student ID, first name, last name(s), and an identifier for the course they are enrolling on.
# The student IDs follow a format of 3 upper case letters (A to Z but not including O or I) then 4 numbers (0 to 9)

# TODO:
# 1.
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

    # if the file does already exist we want to check if there is already a student with this id
    begin
      student_records.each do |student_record|
        raise DuplicateStudentIdError if student_record[:student_id] == @student_id
      end
    rescue DuplicateStudentIdError

    end
  end

  private

  def generate_student_id
    Faker::Base.regexify(Constants::VALID_STUDENT_ID_FORMAT)
  end

  def convert_instance_variables_to_strings
    self.instance_variables.map { |attribute| self.instance_variable_get(attribute).to_s }
  end
end
