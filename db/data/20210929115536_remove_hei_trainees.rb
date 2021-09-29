# frozen_string_literal: true

class RemoveHeiTrainees < ActiveRecord::Migration[6.1]
  def up
    # We verified in the console that the following trainees
    # are draft and have an Apply application where the course
    # accredited_provider_type is “university”, hence a HEI trainee.
    %w[
      rjHvKLQxe8icgNL3kvhtVa18
      KSnRAnH84MN8KHHHaCCEcEbv
      wenERQP48kYjKwWa4CroE2wd
      u6bQAq7z2nh3dwBLTijExL2K
      geSkxKF1FZX4o7jhB4QQA552
      CfWEfnocHPYuackD92p6aX4x
      9jC2AUVp2yTuFzTBGmvHERgm
      fZ3rNtLVZTrcLx39e2bv98ML
      zjUoCVGCY7D8MKfsTmrabUDr
      bMcZr3qJU7fsq793HMZ9H8hv
      Q9HZamUVTKRzNgxM95dJv7Ug
      JNdDdwBp5eDM9NtEhNe8ajxH
      vbMbXhZnRrWufcKNehJ75hrL
      BJQFjFAwc1w4JJmM8CBX5FoM
      7dc75Ho6JcmCRT83P48b1ne7
      Tip4imfVBFn6Si9bGcT7jkif
      jztGxzsuvEGpipDM3DuRqJ6b
      G1TgkGQJRWrFik1pdvUWUeJd
      JFCTzgFdTogkGAARrPvotDkr
      BLrXTty1P14juFsB4t58gPKP
      BYbUpWR4g9wjqYTh6wgNEqBR
      V9Ahp9QAFYgzw86zemNfwkPo
      VvaQvjCzJfXo2PWWB2hV67Lm
      Zn5uPPGgajTxZCFjpGd6H9Rd
      EgcgBVj3f7fZTfFK8LjqwEtZ
      fV4Kmhk3Q574AyaQJsFCkuf5
      413dR6pQ1hEEWTbQELgLSbdx
      8V7stedWqxPBKyFqveqwVpkA
      CYzp67oM57ywzCkej3zNdiAp
      XEaqfWG6KijyPsC2zkU78XKb
      jWRSz3qMsw91asrdo47QR4nb
      rqaMLeXXVG4GY7r8eMjMLtke
      JCJ53aae96nUipm4hkxTg691
      6z47KDWrpocUoQBW8KP3Z6gh
      a9GJe6W9TfrYeAik896AThyP
      VD8dMPrDKkTHUbwpZN9jncB3
      HEqZCWTyWTYkyCVUvuaYtip2
      kBMdwcM6tPxxPLdNhVHZn8Rb
      a4gMDLiSrV3LJV4B1KnjzKK6
      4FCvGraTWsiw835XppbF9hUF
      VVgU7mL7PxWqDgw3Eyz8LNmP
      kmuhW7NZCq63fmXS1fmxXuFr
      NDiM1Q9PzqusVjvoFM5HAm1u
      dExJZy37jH7A5umPFjSiitQ2
      5k8WjtaXzGjxZFz2ZY2YFUJZ
      6mkgeU57V8BtA8SLCZXxc1ZG
      esZdKMBph3DSNHisE5Eg4G2m
      EY6vnswpwGapKXaQfrdttikp
      cxFPynR8bfoiVFYGPZfFZenj
      jYYuvVAPvh5Qs2raGJ6VhSa9
      UMYVpCZofmZJQSMxBgy4Bkns
      BPHa4cBu36sJYae83qpJxFUU
      VSTp8La5kvtk7Wp9Z6TxMRX4
      b3od3gNxxRZ9cxZjyjuj9fnn
      w8NrR2Fw4rSSkAXzdrZeX8vm
      MnJkncPj2qF6GNrFA19XifYV
      PX7dW3YgN2T3A8V21HCh6d6Z
      kox4NzTqAbnCkc5XWxwm7GQp
      suVfB91zcNjKQv9U1x6218oN
      jEzz1B7ypzBM3eZHTBre5LQ2
      EcEPARf8H78hSprMiCc55HBv
      ATePxQayff3CB7aBnmqPKGff
      sqvKe3o3fM2WqQVAVp9P2jaG
      7ZPYxyG4bxDjrAQJH7bLsBJo
      wiGaWoenRqk8P9hDcrZpE958
      gpNKJM1UPVkoM7XmHvheE8aR
      mjjfqD3EmjQLwWH2HDSTu8Rb
      MDi8aC3VeMEs8pmrEVe6uyS1
      1Bkqw3JXoJP1PE4pBP3J7rmi
      5DoATp9rF5tJpPFaXCpUuJSC
      MHT5SeFYbpWFkDkvSp6q7Q88
      N3w4DZggmsWHFzsg9TZTeUhb
      LeX2QDWF7t6K53j8x4ExQagq
      Mp6hznMaMdPd5DvuHbSgQovS
      MUWoUhe3DbQHnbo3z8u5HK5N
      BV4WCDh1XhabMXTYXDmF1hzN
      Fyn9c3p8yfEAJ2r73WXQDUdm
      CjAdeXAHSsdD2SaKZsiKf22h
      GeA6tc1RnJpB6BuX8WxpB7en
      Xqyhun8ZTqYaU1RYUvAfRRMS
      obwUTRzQbcziFMQ9MEzrz253
      PMT556U3Ei3MFLY1KJBkh6dg
      VFxrnVrQfrfoLkAK54F7v664
      VMSC6i4gzpm2Zfuu7fb7AWdt
      bu4yB4kkhyMWwhHq2VGdf2Ho
      azpLrS9beNJVoUbBr5USvFxK
      cL5WmLBkQMpmhWQMpc9K1cYb
      R9cZKmhu88a7pZy2knvyKnUb
      pRVr241PE1cZqH21ieTsUhZn
      NaAmqHGH5Gs69A9RE8Mk8Kas
      ehHjJEj7sB22QqzsqHiugT8V
      32auTUMxePmkHMrgXw4eU5UC
      g4UJGYG36mNRSnhY9AynvSN6
      FYxvJJVoUQehHw5k8uj3dHB4
      fMSo5QHNbytYCKgh33efkHtx
      XRfPDXjpPhyakCFaLhHUHpM5
      3L1TJ55VKerfbhioYE9ToP6J
      umNdYyN2iTBMoMB3ZxhKsPLt
      qnn4bNxJhqrbRiLsUJf15s6d
      8ppzWVQeKLF8RzwWa3RdQK7i
      n1M3aiV7ybC5okbBNfJZ3zTs
      4i7mNpdbRtRMyyVfcrFTEGCA
      YStvVFUb4BgQhzN4kf1rVWwm
      hUU2cWKEjpjuC5j7mTCMBpFC
      jn7zFNcDYkyGV1tpmiojj4KY
      tBNHn5mBDm3bnh5u3LJd4VtW
      f5NDMjkcde47syFTcvokLxW9
      Uun5m5mGyeChFDVbsAdkMPBU
      b98dbWxpAbmYnuX8ApN39DCN
      FEQzs7Zfyd6XWhLJo29cjdGy
      zmoKxfCgZLKremZN3WWKFi61
      x5AUC9iLYDt43nShnYLoWqRX
      iFtoYXea7y5RjVKiZX5nHsLR
      7HJCXeYyE1moGE1aMXSvgUw7
      ood8PJmGKTVzhscyfEV36pC8
      3qZydt2PTy54me2A9KbPm5L6
      fXF2kMGi68qMUbWMX3TABC8b
      n6m9KbGvg2H8NmigR3grhceF
      XmgQqCZKHVKn4WL7SbiADTJo
      nDe5vJbYbbo6f9F8KejBx12h
      1RqAZoN3qWFL8PjwycdZcKPP
      JBbzpwbjfPmfyu9eGeHUDHqk
      h3p8XKk7zvbk1mceC1FrhWLt
      kFYeAu4ktx6TWwBbLLwsFUBg
      Qt4ec3Uq2GJ2j7qZzHKiBcxC
      sZnHkdrsUFbzjwi7nexgTTcw
      twZi97vQfx4VrGS6amqVyJ5f
      jpqGCw29Dc8FSfF8QMduWZGF
      gbHbjY7Tdxz7jdn7qaGxGxv8
      UAC5RzYnCv5o4rbFhQNwtJRR
      PniML2iML7rHGjmKY2ku9onq
      wDyUGExDG4XYyrGxEYyE9qys
      LsCahHztoWKpHD7AKuCmfCPX
      knWCMnaGpreZBk8FW8xkCUnM
      AdiyXrMPBbGL3UUTba8Q5tvr
      wzcUC8tUyDR1QngcKGpCRgwB
      4Hy2s7RdGQyHSygmW7yFqqrf
      KLbbVcsL6rJT6nyUecfp32pr
      ePfkG5u7F6EXm7gxPZKHoA61
      GwAgwmtFhjscYw89ifzbVLzw
      pBGGyjNTNvtp9BXjzftnhND8
      D5Rug1iTHvoHQXK26oKR3CgU
      9o7MgfUMshRARFbkWNcWA5Vj
      MxtjgvZE69ft8wmUgiQoJaTw
      mbhc5sDvomWcozjrqfqG35Bb
      w9K2hRRJv6hsB3bY4WjX5Auq
      CwRr9hyXmuaFqJy2L4s63utQ
      qTqLnn533ygxQaT2GVMxLgLn
      Hmd3sTt1EsVnes84jbCsb8Yn
      RPFY6RW8kCLo9voDcQCGM4g2
      cvJDpppKBoq7mhAk4xkidseM
      tkXWXqm6QQKLU8x2A1cxheTo
      3DchCSy45huLrXXW64AsjjNd
      Jtp4614JhKwYBfqiFCnHLPaT
      QBfBgHn9yEWsFojLnNZBahoA
      wPQwB952SRcv9R8bMbJfoLxN
      yLdCs1tAPkzaKf6o3vYkc3zR
      5uTdiDDWgNsa2bbPPaJdQz1t
      3LDEE5qc76uevGXuCpRmokSA
      mR8kY6buBLw9TyVJmfc47N3x
      rsiJ4XRzZufqk4SLExkuvBWj
      YGKeNfkCatPY498XPs363Vx4
      uvew1WR4Fnd6MF28LVRQJWfv
      LiJ6TP2YWoALhjHwWqbLmGJv
      u9nra25NPhdyb3gq51PfU65X
      dpS9ePb9sto6krUg3D8YYE4L
      M1Y7FSDYgcTfcA75tkHtHzCP
      8s24evQSygY49FhnDBKLr8eN
      g67o6yYh7Dz8tn4KsPczfFmi
      53kwtaf4smBM55kF21BA6Psq
      nJ7fThoMyUfJ8ZdAAjxqwMSc
      f4uaW5Q7L4tUbut9UwvPC6N4
      eJBR58nY9JzF9pFmpLyUAzzA
      9Uidz1HV9dDzJLkkXiuoESod
      KqCvFtkArNB4daLGhweuw7ih
      GsTpVEJTecpVn451UcEKfj4n
      y9GeBzyKLPukGRkTeRWDJeX3
      x4RX39XAzB7t7auf3FRx1kGh
      qV15BMZ4HNCkA4XKEvu5qZLT
    ].each do |slug|
      trainee = Trainee.find_by(slug: slug)
      if trainee&.draft? # double check just in case it has changed since
        trainee.apply_application.non_importable_hei!
        trainee.destroy
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
