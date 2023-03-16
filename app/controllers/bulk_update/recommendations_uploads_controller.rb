# frozen_string_literal: true

module BulkUpdate
  class RecommendationsUploadsController < ApplicationController
    helper_method :bulk_recommend_count, :recommendations_upload_form, :awardable_rows_count
    before_action :redirect

    def show
      @total_rows_count = recommendations_upload.rows.size
      @missing_date_rows_count = recommendations_upload.missing_date_rows.size
      @error_rows_count = recommendations_upload.error_rows.size
    end

    def new
      @recommendations_upload_form = RecommendationsUploadForm.new
    end

    def edit
      recommendations_upload
      @recommendations_upload_form = RecommendationsUploadForm.new
    end

    def create
      @recommendations_upload_form = RecommendationsUploadForm.new(provider:, file:)

      if recommendations_upload_form.save
        create_rows!
        redirect_to(bulk_update_recommendations_upload_summary_path(recommendations_upload_form.recommendations_upload))
      else
        render(:new)
      end
    end

  private

    attr_reader :recommendations_upload_form

    def file
      @file ||= params.dig(:bulk_update_recommendations_upload_form, :file)
    end

    def provider
      @provider ||= current_user.organisation
    end

    def awardable_rows_count
      @awardable_rows_count = recommendations_upload.awardable_rows.size
    end

    def recommendations_upload
      @recommendations_upload ||= provider.recommendations_uploads.find(params[:id] || params[:recommendations_upload_id])
    end

    def bulk_recommend_count
      @bulk_recommend_count ||= policy_scope(FindBulkRecommendTrainees.call).count
    end

    # for now, if anything goes wrong during creation of trainees
    # delete the recommend_upload record (and uploaded file)
    def create_rows!
      recommendations_upload = recommendations_upload_form.recommendations_upload

      RecommendationsUploads::CreateRecommendationsUploadRows.call(
        recommendations_upload: recommendations_upload,
        csv: recommendations_upload_form.csv,
      )
    rescue StandardError => e
      recommendations_upload.destroy
      raise(e)
    end

    def redirect
      redirect_to(root_path) unless provider.is_a?(Provider)
    end
  end
end