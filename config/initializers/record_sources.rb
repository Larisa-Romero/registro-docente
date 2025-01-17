# frozen_string_literal: true

module RecordSources
  APPLY = "apply"
  DTTP = "dttp"
  HESA_COLLECTION = "hesa_collection"
  HESA_TRN_DATA = "hesa_trn_data"
  MANUAL = "manual"
  API = "api"

  ALL = [APPLY, DTTP, HESA_COLLECTION, HESA_TRN_DATA, API, MANUAL].freeze
end
