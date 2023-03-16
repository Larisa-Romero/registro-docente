# frozen_string_literal: true

module PageObjects
  module RecommendationsUploads
    class Show < PageObjects::Base
      set_url "/bulk-update/recommend/{id}/fix-errors"
    end
  end
end
