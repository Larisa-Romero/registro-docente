# frozen_string_literal: true

module Hesa
  # If the service needs access to a HESA xml file no longer available from HESA i.e.
  # a previous collection, upload a file via `/system-admin/uploads` and pass the
  # `upload_id` to the service. For the current HESA collection, you do not need to
  # specify an upload.
  class SyncStudents
    include ServicePattern

    attr_reader :collection_reference, :upload, :from_date

    def initialize(upload_id: nil)
      @from_date = Settings.hesa.current_collection_start_date
      @collection_reference = Settings.hesa.current_collection_reference
      @upload = Upload.find_by(id: upload_id)
    end

    def call
      return sync_data(fetch_xml_from_hesa) unless upload

      upload.file.open do |xml|
        sync_data(xml.read.to_s)
      end
    end

  private

    def fetch_xml_from_hesa
      Client.get(url: "#{Settings.hesa.collection_base_url}/#{collection_reference}/#{from_date}")
    end

    def sync_data(xml)
      return if xml.empty?

      Nokogiri::XML::Reader(xml).each do |node|
        next unless node.name == "Student" && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT

        student_node = Nokogiri::XML(node.outer_xml).at("./Student")
        hesa_trainee = Hesa::Parsers::IttRecord.to_attributes(student_node:)
        hesa_student = Hesa::Student.find_or_initialize_by(
          hesa_id: hesa_trainee[:hesa_id],
          rec_id: hesa_trainee[:rec_id],
        )
        hesa_student.assign_attributes(hesa_trainee)

        if upload.nil?
          hesa_student.collection_reference = collection_reference
        else
          hesa_student.collection_reference = "C#{hesa_trainee[:rec_id]}"
        end

        hesa_student.save
      end
    end
  end
end
