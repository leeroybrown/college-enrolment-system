module Constants
  VALID_STUDENT_ID_FORMAT = /^[A-HJ-NP-Z]{3}[0-9]{4}$/.freeze
  OUTPUT_HEADERS = %w[student_id first_name last_name course_identifier errors].freeze
  RECORDS_FILE_PATH = './course-designations/records.csv'.freeze
  COURSES_FILE_PATH = './course-designations/course-designations.csv'.freeze
end
