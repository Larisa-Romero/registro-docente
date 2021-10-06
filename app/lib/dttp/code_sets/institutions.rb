# frozen_string_literal: true

module Dttp
  module CodeSets
    module Institutions
      BIRKBECK_COLLEGE = "Birkbeck College"
      BISHOP_GROSSETESTE_UNIVERSITY = "Bishop Grosseteste University"
      BRUNEL_UNIVERSITY_LONDON = "Brunel University London"
      UNIVERSITY_OF_DURHAM = "University of Durham"
      GOLDSMITHS_COLLEGE = "Goldsmiths College"
      HARPER_ADAMS_UNIVERSITY = "Harper Adams University"
      HERIOT_WATT_UNIVERSITY = "Heriot-Watt University"
      IMPERIAL_COLLEGE_OF_SCIENCE_TECHNOLOGY_AND_MEDICINE = "Imperial College of Science, Technology and Medicine"
      THE_UNIVERSITY_OF_KEELE = "The University of Keele"
      UNIVERSITY_OF_LANCASTER = "University of Lancaster"
      UNIVERSITY_OF_NEWCASTLE_UPON_TYNE = "University of Newcastle-upon-Tyne"
      NEWMAN_UNIVERSITY = "Newman University"
      UNIVERSITY_OF_NORTHUMBRIA_AT_NEWCASTLE = "University of Northumbria at Newcastle"
      THE_QUEENS_UNIVERSITY_OF_BELFAST = "The Queen's University of Belfast"
      ROYAL_HOLLOWAY_AND_BEDFORD_NEW_COLLEGE = "Royal Holloway and Bedford New College"
      ST_GEORGES_HOSPITAL_MEDICAL_SCHOOL = "St George's Hospital Medical School"
      PLYMOUTH_MARJON_UNIVERSITY = "Plymouth Marjon University"
      UNIVERSITY_CAMPUS_SUFFOLK = "University Campus Suffolk"
      OTHER_UK = "Other UK"

      MAPPING = {
        "Aberystwyth University" => { entity_id: "443e2cff-6f42-e811-80ff-3863bb3640b8", hesa_code: "177" },
        "Anglia Ruskin University" => { entity_id: "387af34a-2887-e711-80d8-005056ac45bb", hesa_code: "47" },
        "Aston University" => { entity_id: "513e2cff-6f42-e811-80ff-3863bb3640b8", hesa_code: "108" },
        "Bangor University" => { entity_id: "92c53e05-7042-e811-80ff-3863bb3640b8", hesa_code: "178" },
        "Bath Spa University" => { entity_id: "c670f34a-2887-e711-80d8-005056ac45bb", hesa_code: "48" },
        BIRKBECK_COLLEGE => { entity_id: "9fc53e05-7042-e811-80ff-3863bb3640b8", hesa_code: "127" },
        "Birmingham City University" => { entity_id: "c870f34a-2887-e711-80d8-005056ac45bb", hesa_code: "52" },
        BISHOP_GROSSETESTE_UNIVERSITY => { entity_id: "ca70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "7" },
        "Bournemouth University" => { entity_id: "b1c53e05-7042-e811-80ff-3863bb3640b8", hesa_code: "50" },
        BRUNEL_UNIVERSITY_LONDON => { entity_id: "cc70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "113" },
        "Buckinghamshire New University" => { entity_id: "bec53e05-7042-e811-80ff-3863bb3640b8", hesa_code: "9" },
        "Canterbury Christ Church University" => { entity_id: "ce70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "12" },
        "Cardiff Metropolitan University" => { entity_id: "07f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "89" },
        "Cardiff University" => { entity_id: "0ff35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "179" },
        "Courtauld Institute of Art" => { entity_id: "18f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "201" },
        "Coventry University" => { entity_id: "1ff35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "56" },
        "Cranfield University" => { entity_id: "4e9e1d2d-3fa2-e811-812b-5065f38ba241", hesa_code: "2" },
        "Cumbria Institute of the Arts" => { entity_id: "2ef35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "192" },
        "Dartington College of Arts" => { entity_id: "34f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "15" },
        "De Montfort University" => { entity_id: "f30a4e73-a141-e811-80ff-3863bb351d40", hesa_code: "68" },
        "Edge Hill University" => { entity_id: "d070f34a-2887-e711-80d8-005056ac45bb", hesa_code: "16" },
        "Edinburgh Napier University" => { entity_id: "43f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "107" },
        "Falmouth University" => { entity_id: "6f955cae-3ea2-e811-812b-5065f38ba241", hesa_code: "17" },
        "Glasgow School of Art" => { entity_id: "51f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "97" },
        "Glyndwr University" => { entity_id: "57f35f0b-7042-e811-80ff-3863bb3640b8", hesa_code: "87" },
        GOLDSMITHS_COLLEGE => { entity_id: "d270f34a-2887-e711-80d8-005056ac45bb", hesa_code: "131" },
        "Guildhall School of Music and Drama" => { entity_id: "076e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "208" },
        HARPER_ADAMS_UNIVERSITY => { entity_id: "1b369414-75d9-e911-a863-000d3ab0da57", hesa_code: "18" },
        HERIOT_WATT_UNIVERSITY => { entity_id: "146e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "171" },
        "Heythrop College" => { entity_id: "1b6e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "205" },
        IMPERIAL_COLLEGE_OF_SCIENCE_TECHNOLOGY_AND_MEDICINE => { entity_id: "0b9017b0-a141-e811-80ff-3863bb351d40", hesa_code: "132" },
        "Institute of Education" => { entity_id: "dcd0c9d6-e897-e711-80d8-005056ac45bb", hesa_code: "133" },
        "Kent Institute of Art and Design" => { entity_id: "2f6e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "20" },
        "King's College London" => { entity_id: "d470f34a-2887-e711-80d8-005056ac45bb", hesa_code: "134" },
        "Kingston University" => { entity_id: "d670f34a-2887-e711-80d8-005056ac45bb", hesa_code: "63" },
        "Leeds Beckett University" => { entity_id: "d870f34a-2887-e711-80d8-005056ac45bb", hesa_code: "64" },
        "Leeds College of Art" => { entity_id: "436e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "211" },
        "Leeds College of Music" => { entity_id: "496e5e11-7042-e811-80ff-3863bb3640b8", hesa_code: "207" },
        "Leeds Trinity University" => { entity_id: "da70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "40" },
        "Liverpool Hope University" => { entity_id: "dc70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "23" },
        "Liverpool John Moores University" => { entity_id: "de70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "65" },
        "London Business School" => { entity_id: "6a1c7817-7042-e811-80ff-3863bb3640b8", hesa_code: "135" },
        "London Guildhall University" => { entity_id: "711c7817-7042-e811-80ff-3863bb3640b8", hesa_code: "55" },
        "London Metropolitan University" => { entity_id: "e070f34a-2887-e711-80d8-005056ac45bb", hesa_code: "202" },
        "London School of Economics and Political Science" => { entity_id: "7d1c7817-7042-e811-80ff-3863bb3640b8", hesa_code: "137" },
        "London South Bank University" => { entity_id: "e270f34a-2887-e711-80d8-005056ac45bb", hesa_code: "76" },
        "Loughborough University" => { entity_id: "e470f34a-2887-e711-80d8-005056ac45bb", hesa_code: "152" },
        "Manchester Health Academy" => { entity_id: "3d0517a7-a441-e811-80fd-3863bb349ac0" },
        "Middlesex University" => { entity_id: "e870f34a-2887-e711-80d8-005056ac45bb", hesa_code: "67" },
        "Newcastle College" => { entity_id: "20e5a08c-ee97-e711-80d8-005056ac45bb" },
        NEWMAN_UNIVERSITY => { entity_id: "ec70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "28" },
        "Non EU countries" => { entity_id: "9c7fcac0-4a37-e811-80ef-005056ac45bb" },
        "Northern School of Contemporary Dance" => { entity_id: "9a1c7817-7042-e811-80ff-3863bb3640b8", hesa_code: "191" },
        "Norwich City College of Further and Higher Education" => { entity_id: "3efe7322-e897-e711-80d8-005056ac45bb" },
        "Norwich University of the Arts" => { entity_id: "a01c7817-7042-e811-80ff-3863bb3640b8", hesa_code: "190" },
        "Not applicable" => { entity_id: "9e7fcac0-4a37-e811-80ef-005056ac45bb" },
        "Not available in EBRDMS" => { entity_id: "23f3791d-7042-e811-80ff-3863bb3640b8" },
        "Other EU countries" => { entity_id: "9a7fcac0-4a37-e811-80ef-005056ac45bb" },
        "Other UK (Northern Ireland)" => { entity_id: "a47fcac0-4a37-e811-80ef-005056ac45bb" },
        "Other UK (Scotland)" => { entity_id: "a07fcac0-4a37-e811-80ef-005056ac45bb" },
        "Other UK (Wales)" => { entity_id: "a27fcac0-4a37-e811-80ef-005056ac45bb" },
        OTHER_UK => { entity_id: "5070f34a-2887-e711-80d8-005056ac45bb" },
        "Oxford Brookes University" => { entity_id: "f070f34a-2887-e711-80d8-005056ac45bb", hesa_code: "72" },
        PLYMOUTH_MARJON_UNIVERSITY => { entity_id: "3a71f34a-2887-e711-80d8-005056ac45bb" },
        "Prestolee SCITT" => { entity_id: "027bf34a-2887-e711-80d8-005056ac45bb" },
        "Queen Margaret University, Edinburgh" => { entity_id: "40f3791d-7042-e811-80ff-3863bb3640b8", hesa_code: "100" },
        "Queen Mary University of London" => { entity_id: "47f3791d-7042-e811-80ff-3863bb3640b8", hesa_code: "139" },
        "Ravensbourne" => { entity_id: "4ff3791d-7042-e811-80ff-3863bb3640b8", hesa_code: "30" },
        "Roehampton University" => { entity_id: "f270f34a-2887-e711-80d8-005056ac45bb", hesa_code: "31" },
        "Rose Bruford College" => { entity_id: "5af3791d-7042-e811-80ff-3863bb3640b8", hesa_code: "32" },
        "Royal Academy of Music" => { entity_id: "61f3791d-7042-e811-80ff-3863bb3640b8", hesa_code: "33" },
        "Royal College of Art" => {
          entity_id: "64407223-7042-e811-80ff-3863bb3640b8",
          synonyms: ["RCA"],
          hesa_code: "3",
        },
        "Royal College of Music" => { entity_id: "49e01caa-a141-e811-80ff-3863bb351d40", hesa_code: "34" },
        ROYAL_HOLLOWAY_AND_BEDFORD_NEW_COLLEGE => { entity_id: "6c407223-7042-e811-80ff-3863bb3640b8", hesa_code: "141" },
        "Royal Northern College of Music" => { entity_id: "74407223-7042-e811-80ff-3863bb3640b8", hesa_code: "35" },
        "Royal Welsh College of Music and Drama" => { entity_id: "7b407223-7042-e811-80ff-3863bb3640b8", hesa_code: "182" },
        "Salford College of Technology" => { entity_id: "81407223-7042-e811-80ff-3863bb3640b8", hesa_code: "36" },
        "Sheffield Hallam University" => { entity_id: "f470f34a-2887-e711-80d8-005056ac45bb", hesa_code: "75" },
        "Southampton Solent University" => { entity_id: "c10b1d33-3fa2-e811-812b-5065f38ba241", hesa_code: "37" },
        ST_GEORGES_HOSPITAL_MEDICAL_SCHOOL => { entity_id: "94407223-7042-e811-80ff-3863bb3640b8", hesa_code: "145" },
        "St Mary's University College" => { entity_id: "9b407223-7042-e811-80ff-3863bb3640b8", hesa_code: "194" },
        "St Mary's University, Twickenham" => { entity_id: "f670f34a-2887-e711-80d8-005056ac45bb", hesa_code: "39" },
        "Staffordshire University" => { entity_id: "f870f34a-2887-e711-80d8-005056ac45bb", hesa_code: "77" },
        "Swansea University" => {
          entity_id: "b3407223-7042-e811-80ff-3863bb3640b8",
          synonyms: ["University of Wales, Swansea"],
          hesa_code: "180",
        },
        "Teach First" => { entity_id: "5a3385b1-2506-ea11-a811-000d3ab4df6c" },
        "Teesside University" => { entity_id: "2a96fc9d-a141-e811-80ff-3863bb351d40", hesa_code: "79" },
        "The Arts University Bournemouth" => { entity_id: "c6407223-7042-e811-80ff-3863bb3640b8", hesa_code: "197" },
        "The City University" => { entity_id: "7bdb7129-7042-e811-80ff-3863bb3640b8", hesa_code: "115" },
        "The Liverpool Institute for Performing Arts" => { entity_id: "84db7129-7042-e811-80ff-3863bb3640b8", hesa_code: "209" },
        "The Manchester Metropolitan University" => { entity_id: "e670f34a-2887-e711-80d8-005056ac45bb", hesa_code: "66" },
        "The Nottingham Trent University" => { entity_id: "ee70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "71" },
        "The Open University" => { entity_id: "5c9e1d2d-3fa2-e811-812b-5065f38ba241", hesa_code: "1" },
        THE_QUEENS_UNIVERSITY_OF_BELFAST => { entity_id: "a7db7129-7042-e811-80ff-3863bb3640b8", hesa_code: "184" },
        "The Royal Central School of Speech and Drama" => { entity_id: "d90a4e73-a141-e811-80ff-3863bb351d40", hesa_code: "10" },
        "The Royal Veterinary College" => { entity_id: "b6db7129-7042-e811-80ff-3863bb3640b8", hesa_code: "143" },
        "The School of Oriental and African Studies" => { entity_id: "bddb7129-7042-e811-80ff-3863bb3640b8", hesa_code: "146" },
        "The Surrey Institute of Art and Design, University College" => { entity_id: "c4db7129-7042-e811-80ff-3863bb3640b8", hesa_code: "44" },
        "The University of Aberdeen" => { entity_id: "cbdb7129-7042-e811-80ff-3863bb3640b8", hesa_code: "170" },
        "The University of Bath" => { entity_id: "3e7af34a-2887-e711-80d8-005056ac45bb", hesa_code: "109" },
        "The University of Birmingham" => { entity_id: "fe70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "110" },
        "The University of Brighton" => { entity_id: "0071f34a-2887-e711-80d8-005056ac45bb", hesa_code: "51" },
        "The University of Bristol" => { entity_id: "0271f34a-2887-e711-80d8-005056ac45bb", hesa_code: "112" },
        "The University of Buckingham" => { entity_id: "0471f34a-2887-e711-80d8-005056ac45bb", hesa_code: "203" },
        "The University of Cambridge" => { entity_id: "0671f34a-2887-e711-80d8-005056ac45bb", hesa_code: "114" },
        "The University of Central Lancashire" => { entity_id: "59e01caa-a141-e811-80ff-3863bb351d40", hesa_code: "53" },
        "The University of Chichester" => { entity_id: "0a71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "82" },
        "The University of Dundee" => { entity_id: "bbed6e2f-7042-e811-80ff-3863bb3640b8", hesa_code: "172" },
        "The University of East Anglia" => { entity_id: "1271f34a-2887-e711-80d8-005056ac45bb", hesa_code: "117" },
        "The University of East London" => { entity_id: "1471f34a-2887-e711-80d8-005056ac45bb", hesa_code: "58" },
        "The University of Edinburgh" => { entity_id: "d7ed6e2f-7042-e811-80ff-3863bb3640b8", hesa_code: "167" },
        "The University of Exeter" => { entity_id: "1671f34a-2887-e711-80d8-005056ac45bb", hesa_code: "119" },
        "The University of Glasgow" => { entity_id: "6ceb7735-7042-e811-80ff-3863bb3640b8", hesa_code: "168" },
        "The University of Greenwich" => { entity_id: "1a71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "59" },
        "The University of Hull" => { entity_id: "2071f34a-2887-e711-80d8-005056ac45bb", hesa_code: "120" },
        THE_UNIVERSITY_OF_KEELE => { entity_id: "3a7af34a-2887-e711-80d8-005056ac45bb", hesa_code: "121" },
        "The University of Leeds" => { entity_id: "2271f34a-2887-e711-80d8-005056ac45bb", hesa_code: "124" },
        "The University of Leicester" => { entity_id: "2471f34a-2887-e711-80d8-005056ac45bb", hesa_code: "125" },
        "The University of Lincoln" => { entity_id: "035b7f3b-7042-e811-80ff-3863bb3640b8", hesa_code: "62" },
        "The University of Liverpool" => { entity_id: "f58f17b0-a141-e811-80ff-3863bb351d40", hesa_code: "126" },
        "The University of Manchester Institute of Science and Technology" => { entity_id: "1b5b7f3b-7042-e811-80ff-3863bb3640b8", hesa_code: "165" },
        "The University of Manchester" => { entity_id: "2671f34a-2887-e711-80d8-005056ac45bb", hesa_code: "204" },
        "The University of North London" => { entity_id: "235b7f3b-7042-e811-80ff-3863bb3640b8", hesa_code: "70" },
        "The University of Northampton" => { entity_id: "2871f34a-2887-e711-80d8-005056ac45bb", hesa_code: "27" },
        "The University of Oxford" => { entity_id: "2e71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "156" },
        "The University of Portsmouth" => { entity_id: "3271f34a-2887-e711-80d8-005056ac45bb", hesa_code: "74" },
        "The University of Reading" => { entity_id: "3471f34a-2887-e711-80d8-005056ac45bb", hesa_code: "157" },
        "The University of Salford" => { entity_id: "425b7f3b-7042-e811-80ff-3863bb3640b8", hesa_code: "158" },
        "The University of Sheffield" => { entity_id: "3671f34a-2887-e711-80d8-005056ac45bb", hesa_code: "159" },
        "The University of St Andrews" => { entity_id: "34228041-7042-e811-80ff-3863bb3640b8", hesa_code: "173" },
        "The University of Stirling" => { entity_id: "3b228041-7042-e811-80ff-3863bb3640b8", hesa_code: "174" },
        "The University of Strathclyde" => { entity_id: "42228041-7042-e811-80ff-3863bb3640b8", hesa_code: "169" },
        "The University of Sunderland" => { entity_id: "3c71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "78" },
        "The University of Wales (central functions)" => { entity_id: "6a228041-7042-e811-80ff-3863bb3640b8" },
        "The University of Wales, Newport" => { entity_id: "73228041-7042-e811-80ff-3863bb3640b8", hesa_code: "86" },
        "The University of Warwick" => { entity_id: "4271f34a-2887-e711-80d8-005056ac45bb", hesa_code: "163" },
        "The University of West London" => { entity_id: "84228041-7042-e811-80ff-3863bb3640b8", hesa_code: "80" },
        "The University of York" => { entity_id: "4a71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "164" },
        "Trinity Laban Conservatoire of Music and Dance" => { entity_id: "054b9247-7042-e811-80ff-3863bb3640b8", hesa_code: "41" },
        "Trinity University College" => { entity_id: "0e4b9247-7042-e811-80ff-3863bb3640b8", hesa_code: "92" },
        UNIVERSITY_CAMPUS_SUFFOLK => { entity_id: "154b9247-7042-e811-80ff-3863bb3640b8", hesa_code: "210" },
        "University Church Free School CH1 1QP" => { entity_id: "7678f34a-2887-e711-80d8-005056ac45bb" },
        "University College Birmingham" => { entity_id: "fa70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "200" },
        "University College Cardiff" => { entity_id: "264b9247-7042-e811-80ff-3863bb3640b8" },
        "University College London" => {
          entity_id: "a27af34a-2887-e711-80d8-005056ac45bb",
          synonyms: ["UCL"],
          hesa_code: "149",
        },
        "University for the Creative Arts" => { entity_id: "354b9247-7042-e811-80ff-3863bb3640b8", hesa_code: "206" },
        "University of Bedfordshire" => { entity_id: "fc70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "26" },
        "University of Bolton" => { entity_id: "dfdb7129-7042-e811-80ff-3863bb3640b8", hesa_code: "49" },
        "University of Bradford" => { entity_id: "7fed6e2f-7042-e811-80ff-3863bb3640b8", hesa_code: "111" },
        "University of Chester" => { entity_id: "0871f34a-2887-e711-80d8-005056ac45bb", hesa_code: "11" },
        "University of Cumbria" => { entity_id: "0c71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "38" },
        "University of Derby" => { entity_id: "0e71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "57" },
        UNIVERSITY_OF_DURHAM => { entity_id: "1071f34a-2887-e711-80d8-005056ac45bb", hesa_code: "116" },
        "University of Essex" => { entity_id: "5aeb7735-7042-e811-80ff-3863bb3640b8", hesa_code: "118" },
        "University of Glamorgan" => { entity_id: "b49fd8d5-3829-e911-a82f-000d3ab0d976" },
        "University of Gloucestershire" => { entity_id: "1871f34a-2887-e711-80d8-005056ac45bb", hesa_code: "54" },
        "University of Hertfordshire" => { entity_id: "1c71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "60" },
        "University of Huddersfield" => { entity_id: "1e71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "61" },
        "University of Kent" => { entity_id: "99eb7735-7042-e811-80ff-3863bb3640b8", hesa_code: "122" },
        UNIVERSITY_OF_LANCASTER => { entity_id: "a4eb7735-7042-e811-80ff-3863bb3640b8", hesa_code: "123" },
        "University of London" => { entity_id: "0d791c39-3fa2-e811-812b-5065f38ba241" },
        "University of Manchester" => { entity_id: "5b43a44d-7042-e811-80ff-3863bb3640b8", hesa_code: "204" },
        UNIVERSITY_OF_NEWCASTLE_UPON_TYNE => { entity_id: "ea70f34a-2887-e711-80d8-005056ac45bb", hesa_code: "154" },
        UNIVERSITY_OF_NORTHUMBRIA_AT_NEWCASTLE => { entity_id: "2a71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "69" },
        "University of Nottingham" => { entity_id: "2c71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "155" },
        "University of Plymouth" => { entity_id: "3071f34a-2887-e711-80d8-005056ac45bb", hesa_code: "73" },
        "University of South Wales" => { entity_id: "8723a753-7042-e811-80ff-3863bb3640b8", hesa_code: "90" },
        "University of Southampton" => { entity_id: "4f5b7f3b-7042-e811-80ff-3863bb3640b8", hesa_code: "160" },
        "University of Surrey" => { entity_id: "58228041-7042-e811-80ff-3863bb3640b8", hesa_code: "161" },
        "University of Sussex" => { entity_id: "3e71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "162" },
        "University of Ulster" => { entity_id: "a823a753-7042-e811-80ff-3863bb3640b8", hesa_code: "185" },
        "University of Wales Trinity Saint David" => { entity_id: "b123a753-7042-e811-80ff-3863bb3640b8", hesa_code: "176" },
        "University of Wales, Cardiff" => { entity_id: "b923a753-7042-e811-80ff-3863bb3640b8" },
        "University of Westminster" => { entity_id: "7eda4db6-a141-e811-80ff-3863bb351d40", hesa_code: "83" },
        "University of Winchester" => { entity_id: "4471f34a-2887-e711-80d8-005056ac45bb", hesa_code: "21" },
        "University of Wolverhampton" => { entity_id: "4671f34a-2887-e711-80d8-005056ac45bb", hesa_code: "85" },
        "University of Worcester" => { entity_id: "4871f34a-2887-e711-80d8-005056ac45bb", hesa_code: "46" },
        "University of the Arts London" => { entity_id: "ca781c39-3fa2-e811-812b-5065f38ba241", hesa_code: "24" },
        "University of the West of England, Bristol" => { entity_id: "4071f34a-2887-e711-80d8-005056ac45bb", hesa_code: "81" },
        "West London Institute of HE" => { entity_id: "c323a753-7042-e811-80ff-3863bb3640b8", hesa_code: "43" },
        "West Suffolk College" => { entity_id: "82ff7322-e897-e711-80d8-005056ac45bb" },
        "Wimbledon School of Art" => { entity_id: "cb23a753-7042-e811-80ff-3863bb3640b8", hesa_code: "84" },
        "Winchester School of Art" => { entity_id: "d123a753-7042-e811-80ff-3863bb3640b8", hesa_code: "45" },
        "Writtle College" => { entity_id: "d723a753-7042-e811-80ff-3863bb3640b8", hesa_code: "189" },
        "York St John University" => { entity_id: "4c71f34a-2887-e711-80d8-005056ac45bb", hesa_code: "13" },
      }.freeze
    end
  end
end
