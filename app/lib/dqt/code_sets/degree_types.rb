# frozen_string_literal: true

module Dqt
  module CodeSets
    module DegreeTypes
      FOUNDATIONS = %w[
        be08f598-0860-4de0-b95a-3c448a16cc99
        7022c4c2-ec9a-4eec-98dc-315bfeb1ef3a
        2b5b8af4-cade-421b-9e3d-026f71f143b7
        a02be347-1d5b-485a-a845-40c2d4b6ee8f
      ].freeze

      # Until DQT accept these UUIDs from the DfE Reference Data gem, we have
      # agreed to keep this mapping in Register codebase.
      MAPPING = {
        "db695652-c197-e711-80d8-005056ac45bb" => "BachelorOfArts",
        "dd695652-c197-e711-80d8-005056ac45bb" => "BachelorOfArtsEconomics",
        "df695652-c197-e711-80d8-005056ac45bb" => "BachelorOfArtsInArchitecture",
        "e1695652-c197-e711-80d8-005056ac45bb" => "BachelorOftheArtOfObstetrics",
        "e3695652-c197-e711-80d8-005056ac45bb" => "BachelorOfArchitecture",
        "e5695652-c197-e711-80d8-005056ac45bb" => "BachelorOfAppliedScience",
        "e7695652-c197-e711-80d8-005056ac45bb" => "BachelorOfAgriculture",
        "e9695652-c197-e711-80d8-005056ac45bb" => "BachelorOfAccountancy",
        "eb695652-c197-e711-80d8-005056ac45bb" => "BachelorOfAdministration",
        "ed695652-c197-e711-80d8-005056ac45bb" => "BachelorOfBusinessAdministration",
        "ef695652-c197-e711-80d8-005056ac45bb" => "BachelorOfCombinedStudies",
        "f1695652-c197-e711-80d8-005056ac45bb" => "BachelorOfCommerce",
        "f3695652-c197-e711-80d8-005056ac45bb" => "BachelorOfDivinity",
        "f5695652-c197-e711-80d8-005056ac45bb" => "BachelorOfDentalSurgery",
        "f7695652-c197-e711-80d8-005056ac45bb" => "BachelorOfEngineering",
        "f9695652-c197-e711-80d8-005056ac45bb" => "BachelorOfEngineeringWithBusinessStudies",
        "fb695652-c197-e711-80d8-005056ac45bb" => "BachelorOfFineArt",
        "fd695652-c197-e711-80d8-005056ac45bb" => "BachelorOfGeneralStudies",
        "ff695652-c197-e711-80d8-005056ac45bb" => "BachelorOfHumanities",
        "016a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfHygiene",
        "036a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfLaw",
        "056a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfLibrarianship",
        "076a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfLibrarianshipAndInfoStudies",
        "096a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfLiterature",
        "0b6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfLandEconomy",
        "0d6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfMedicalScience",
        "0f6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfMedicine",
        "116a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfMetallurgy",
        "136a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfMetallurgyAndEngineering",
        "156a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfMusic",
        "176a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfNursing",
        "196a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfPharmacy",
        "1b6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScience",
        "1d6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScienceEconomics",
        "1f6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScienceAndEngineering",
        "216a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScienceAndTechnology",
        "236a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScienceInSocialScience",
        "256a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfScienceISpeechTherapy",
        "276a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfSocialScience",
        "296a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfSurgery",
        "2b6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfChirurgiae",
        "2d6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfTechnology",
        "2f6a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfTheology",
        "316a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfVeterinaryMedicine",
        "336a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfVeterinaryMedicineAndSurgery",
        "356a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfVeterinaryScience",
        "376a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfEducationScotlandAndNIreland",
        "396a5652-c197-e711-80d8-005056ac45bb" => "BachelorOfPhilosophy",
        "c1695652-c197-e711-80d8-005056ac45bb" => "BEd",
        "d5695652-c197-e711-80d8-005056ac45bb" => "BAwithIntercalatedPGCE",
        "3b6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfArts",
        "3d6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfLibrarianship",
        "3f6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfLiterature",
        # Master of Mathematics - mapped to HigherDegree temporarily
        "f3eaa983-d543-4d4b-a239-f46d7cc94825" => "HigherDegree",
        "416a5652-c197-e711-80d8-005056ac45bb" => "MasterOfMusic",
        "436a5652-c197-e711-80d8-005056ac45bb" => "MasterOfPhilosophy",
        # Master of Research - mapped to HigherDegree temporarily
        "cfae21bd-2b03-4048-bfdd-5f768c5b85e9" => "HigherDegree",
        # Master in Science - mapped to HigherDegree temporarily
        "b6d2c5aa-cf99-4831-9bfe-6279349d8ea9" => "HigherDegree",
        "456a5652-c197-e711-80d8-005056ac45bb" => "MasterOfScience",
        "476a5652-c197-e711-80d8-005056ac45bb" => "MasterOfTheology",
        "496a5652-c197-e711-80d8-005056ac45bb" => "CertificateOfMembershipOfCranfieldInstituteOfTechnology",
        "4b6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfEducation",
        "4d6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfBusinessStudies",
        "4f6a5652-c197-e711-80d8-005056ac45bb" => "MasterOfSocialStudies",
        "516a5652-c197-e711-80d8-005056ac45bb" => "MasterOfEngineering",
        "536a5652-c197-e711-80d8-005056ac45bb" => "MasterOfLaw",
        "556a5652-c197-e711-80d8-005056ac45bb" => "MasterOfBusinessAdministration",
        "576a5652-c197-e711-80d8-005056ac45bb" => "MasterOfChemistry",
        "596a5652-c197-e711-80d8-005056ac45bb" => "MasterOfPhysics",
        "5b6a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfDivinity",
        "5d6a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfCivilLaw",
        "5f6a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfMedicine",
        "616a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfMusic",
        "636a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfScience",
        "656a5652-c197-e711-80d8-005056ac45bb" => "DoctorOfPhilosophy",
        "676a5652-c197-e711-80d8-005056ac45bb" => "PHD",
        # Doctor of Education - mapped to HigherDegree temporarily
        "03d6b7af-499c-49e3-96cc-e63f9beda6e5" => "HigherDegree",
        "7ba49954-7595-437c-8df0-6a777c97307b" => "BSc_Education",
        "c6aeedca-9147-4e88-886a-a90302f3d097" => "BTechEducation",
        "007a0999-87f7-4afc-8ccd-ce1e1d92c9ac" => "BA_Education",
        "da47d378-f4bb-45ec-bda0-14af40ad974e" => "BACombinedStudies_EducationOfTheDeaf",
        "0584565a-1c98-4c1d-ae64-c241542c0879" => "FirstDegree",
        "fdafdcd7-5f21-4363-b7d5-c1f44a852af1" => "HigherDegree",
        "03c4fa67-345e-4d09-8e9b-68c36a450947" => "DegreeEquivalent",
      }.freeze
    end
  end
end
