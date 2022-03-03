# frozen_string_literal: true

module Hesa
  class RetrieveCollectionJob < ApplicationJob
    def perform(updates_since: HesaCollectionRequest.next_from_date,
                collection_reference: Settings.hesa.current_collection_reference,
                sync_from_hesa: FeatureService.enabled?(:sync_from_hesa))
      @updates_since = updates_since
      @collection_reference = collection_reference

      return unless sync_from_hesa

      request_time = Time.zone.now
      xml_response = Hesa::Client.get(url: url)

      Nokogiri::XML(xml_response).root.children.each do |student_node|
        Trainees::CreateFromHesa.call(student_node: student_node)
      rescue Trainees::CreateFromHesa::HesaImportError => e
        Sentry.capture_exception(e)
        return save_hesa_request(xml_response, request_time).import_failed!
      end

      save_hesa_request(xml_response, request_time).import_successful!
    end

    def save_hesa_request(xml_response, request_time)
      HesaCollectionRequest.create(
        requested_at: request_time,
        collection_reference: @collection_reference,
        updates_since: @updates_since,
        response_body: xml_response,
      )
    end

    def url
      "#{Settings.hesa.collection_base_url}/#{@collection_reference}/#{@updates_since}"
    end
  end
end
