# frozen_string_literal: true

class PlacementForm
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  FIELDS = %i[school_id name urn postcode].freeze
  attr_accessor(*FIELDS)

  def initialize(trainee:, params: {})
    @trainee = trainee
    self.attributes = params
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Placement")
  end

  def fields; end

  def attributes
    FIELDS.index_with do |f|
      public_send(f)
    end
  end

  def attributes=(attrs)
    attrs.each do |k, v|
      public_send(:"#{k}=", v)
    end
  end

  def title
    new_placement_number = @trainee.placements.count + 1
    I18n.t(
      "components.placement_detail.placement_#{new_placement_number}",
      default: I18n.t("components.placement_detail.title"),
    )
  end

  def save!
    if school_id.present? && (school = School.find_by(id: school_id)).present?
      create_placement_from(school)
    else
      create_placement_from(
        School.create!(new_school_attributes.merge(lead_school: false)),
      )
    end
  end

private

  def create_placement_from(school)
    @trainee.placements.create!(
      school: school,
      urn: school.urn,
      name: school.name,
      postcode: school.postcode,
    )
  end

  def new_school_attributes
    {
      name:,
      urn:,
      postcode:,
    }
  end
end
