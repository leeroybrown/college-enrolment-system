# frozen_string_literal: true

module StudentHelpers
  def check_records_file_exists()
    begin
      # Open the records.csv file and check to see if this student_id already exists
      student_records = FileHelper.read_file(file_path: Constants::RECORDS_FILE_PATH)
    rescue FileNotFoundError
      # if the file does not exist then we want to create it and put the student data in as the student_id will be unique
      puts 'File does not exist, creating it...'
      student_info = convert_instance_variables_to_strings
      student_records = FileHelper.write_file(file_path: './course-designations/records.csv', student: student_info)
    end
    student_records
  end
end

