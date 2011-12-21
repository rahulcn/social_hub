class Info < ActiveRecord::Base
  belongs_to :user

  ALL_FIELDS = %w(first_name last_name gender dob education occupation
                  address city state zip_code)
  VALID_GENDERS = ["Male", "Female"]
  START_YEAR = 1990
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  ZIP_CODE_LENGTH = 5

  validates :gender, :inclusion => { :with => VALID_GENDERS }

  validates :dob,    :inclusion => { :with => VALID_DATES }

  validates :zip_code, :format => { :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/ }
end
# == Schema Information
#
# Table name: infos
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)     default("")
#  last_name  :string(255)     default("")
#  gender     :string(255)
#  dob        :date
#  education  :string(255)     default("")
#  occupation :string(255)     default("")
#  address    :string(255)     default("")
#  city       :string(255)     default("")
#  state      :string(255)     default("")
#  zip_code   :string(255)     default("")
#  created_at :datetime
#  updated_at :datetime
#
