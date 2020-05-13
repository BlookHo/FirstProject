class Nir < ApplicationRecord
  belongs_to :university, class_name: "University",
             foreign_key: "university_id"

  belongs_to :assessment1, class_name: "Assessment",
           foreign_key: "assessment1_id"
  belongs_to :assessment2, class_name: "Assessment",
             foreign_key: "assessment2_id"
  belongs_to :assessment3, class_name: "Assessment",
             foreign_key: "assessment3_id"

end
