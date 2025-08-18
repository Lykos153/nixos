{
  config,
  lib,
  nixosConfig,
  pkgs,
  ...
}: let
  setup = {
    laptop = {
      edid = "00ffffffffffff0009e5d60800000000251d0104a51f1178031ef5965d5b91291c505400000001010101010101010101010101010101c0398018713828403020360035ae1000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34550a0011";
    };
    samsung_curved = {
      criteria = "Samsung Electric Company C49J89x HNTR600175";
      edid = "00ffffffffffff004c2d210f4e4245301a1f0104a57822783a91a5a657529c26115054bfef80714f810081c081809500a9c0b30001011a6800a0f0381f4030203a00ac504100001a000000fd0032901eaa42000a202020202020000000fc004334394a3839780a2020202020000000ff00484e54523630303137350a2020016a020314f147901f041303125a23090707830100001eff0050f0384d400820f80cac504100001a023a801871382d40582c4500ac504100001ef4b000a0f038354030203a00ac504100001a74d600a0f038404030203a00ac504100001a0000000000000000000000000000000000000000000000000000000000000000000000d4";
    };
    samsung_syncmaster = {
      criteria = "Samsung Electric Company SyncMaster HMBB602462";
      edid = "00ffffffffffff004c2d87053736535a17150103803420782aee91a3544c99260f5054230800a9408180814081009500b30001010101283c80a070b023403020360006442100001a000000fd00323f1e5111000a202020202020000000fc0053796e634d61737465720a2020000000ff00484d42423630323436320a202001ba02010400023a801871382d40582c450006442100001e023a80d072382d40102c458006442100001e011d007251d01e206e28550006442100001e011d00bc52d01e20b828554006442100001e8c0ad090204031200c4055000644210000188c0ad08a20e02d10103e960006442100001800000000000000000000000000000096";
    };
    tv = {
      edid = "00ffffffffffff004c2dc507010000002e140103805932780aee91a3544c99260f5054bdef80714f8100814081809500950fb300a940023a801871382d40582c4500a05a0000001e662150b051001b3040703600a05a0000001e000000fd00184b1a5117000a202020202020000000fc0053414d53554e470a20202020200158020332f14b901f0413051403122021222309070783010000e2000fe305030172030c003000b82d20d0080140073f405090a0023a80d072382d40102c4580a05a0000001e011d00bc52d01e20b8285540a05a0000001e011d80d0721c1620102c2580a05a0000009e000000000000000000000000000000000000000000000098";
    };
    tv_leila = {
      criteria = "Philips Consumer Electronics Company Philips FTV 0x00000101";
    };
    benq = {
      criteria = "BNQ BenQ GL2450H 76H05996019";
      edid = "00ffffffffffff0009d1a77845540000171b010380351e782eba45a159559d280d5054a56b80810081c08180a9c0b300d1c001010101023a801871382d40582c4500132a2100001e000000ff0037364830353939363031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120474c32343530480a014f020322f14f90050403020111121314060715161f2309070765030c00100083010000023a801871382d40582c4500132a2100001f011d8018711c1620582c2500132a2100009f011d007251d01e206e285500132a2100001e8c0ad08a20e02d10103e9600132a21000018000000000000000000000000000000000000000000eb";
    };
    benq_leila = {
      criteria = "BNQ BenQ GL2450H HAF04109019";
    };
    benq_w = {
      edid = "00ffffffffffff0009d10278455400002616010380351e782eb7d5a456549f270c5054a56b80810081c08180a9c0b300d1c001010101023a801871382d40582c4500132a2100001e000000ff004d394330363339383031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120474c323435300a200175020321c149901f05141304030201230907078301000067030c000000001ee2000f011d8018711c1620582c2500c48e2100009e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000075";
    };
    work00 = {
      edid = "00ffffffffffff00226700000000000035190103803c22782a3581a656489a24125054afcf008100814081809500a940b30001010101023a801871382d40582c4500dd0c1100001e2f2640a060841a3030203500bbf91000001c000000fd00384c1f5311000a202020202020000000fc00484c3237344850420a202020200154020324f14f900504030207061f1413121116150123097f078301000067030c0010000021023a801871382d40582c450009252100001e011d8018711c1620582c250009252100009e011d007251d01e206e28550009252100001e023a80d072382d40102c458009252100001e00000000000000000000000000000000000000f3";
    };
    work01 = {
      edid = "00ffffffffffff000469a327ae930100101c0104a53c22783aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff004a344c4d54463130333334320a000000fd00184c18631e04110140f838f03c000000fc00415355532050423237380a2020010d020322714f0102031112130414051f900e0f1d1e2309170783010000656e0c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000000000096";
    };
    work10-1 = {
      edid = "00ffffffffffff000469a32739770100191c0103803c22782aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff004a364c4d54463039363035370a000000fd00184c186321000a202020202020000000fc00415355532050423237380a202001a002032571520102031112130414050e0f1d1e1f90202122230917078301000065030c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000098";
    };
    work10-2 = {
      edid = "00ffffffffffff000469a327ae930100101c0104a53c22783aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff004a344c4d54463130333334320a000000fd00184c18631e04110140f838f03c000000fc00415355532050423237380a2020010d020322714f0102031112130414051f900e0f1d1e2309170783010000656e0c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000000000096";
    };
    work11 = {
      edid = "00ffffffffffff000469a3278e330100141c0103803c22782aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff004a354c4d54463037383733340a000000fd00184c186321000a202020202020000000fc00415355532050423237380a2020019302032571520102031112130414050e0f1d1e1f90202122230917078301000065030c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000098";
    };
    gh-sil-benq = {
      edid = "00ffffffffffff0009d12178455400002114010380301b782e3581a656489a24125054a56b80710081c081408180a9c0b300d1c00101023a801871382d40582c4500dd0c1100001e000000ff004c384130323836343031390a20000000fd00324c185310000a202020202020000000fc0042656e5120473232323048440a00f3";
    };
    gh-sil-iiyama = {
      edid = "00ffffffffffff0026cd89610101010131200104a5351e783bcd35a65751a0250c5054b74f00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000ff0031323131343234393136393037000000fd00324c555512010a202020202020000000fc00504c32343933480a202020202001d502031ff1461f12900403012309070783010000681a00000101304b00e200ca023a801871382d40582c45000f282100001e8c0ad08a20e02d10103e96000f2821000018011d007251d01e206e2855000f282100001e8c0ad090204031200c4055000f28210000182a4480a070382740302035000f282100001e00000000000029";
    };
  };
  profiles = {
    home-a = {
      samsung_curved = {
        enable = true;
        primary = true;
        mode = "3840x1080";
        position = "1080x271";
        rate = "59.97";
      };
      benq = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rotate = "right";
        rate = "60.00";
      };
    };
    home-a-only-benq = {
      benq = {
        enable = true;
        primary = true;
        mode = "1920x1080";
        position = "0x0";
        rotate = "left";
        rate = "60.00";
      };
    };
    home-a-only-samsung = {
      samsung_curved = {
        enable = true;
        primary = true;
        mode = "3840x1080";
        position = "0x0";
        rate = "59.97";
      };
    };
    ch-home-a = {
      samsung_curved = {
        enable = true;
        primary = true;
        mode = "3840x1080";
        position = "0x0";
        rate = "59.97";
      };
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "960x1080";
        rate = "60.00";
      };
    };
    ch-home-a-benq = {
      samsung_curved = {
        enable = true;
        primary = true;
        mode = "3840x1080";
        position = "1080x271";
        rate = "59.97";
      };
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "2040x1351";
        rate = "60.00";
      };
      benq = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rotate = "right";
        rate = "60.00";
      };
    };
    home-w = {
      samsung_syncmaster = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60.00";
        rotate = "left";
      };
      benq_w = {
        enable = true;
        primary = true;
        mode = "1920x1080";
        position = "1080x0";
        rate = "60.00";
      };
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "1080x1080";
        rate = "60.00";
      };
    };
    mobile = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60.01";
      };
    };
    ch-w-tv = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60";
      };
      tv = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60";
      };
    };
    ch-gh-sil = {
      gh-sil-benq = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60";
      };
      gh-sil-iiyama = {
        enable = true;
        primary = true;
        mode = "1920x1080";
        position = "1920x0";
        rate = "60";
      };
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "3840x0";
        rate = "60";
      };
    };
    cah00 = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "60.01";
      };
      work00 = {
        enable = true;
        primary = true;
        mode = "1920x1080";
        position = "1920x0";
        rate = "60.00";
      };
    };
    cah01 = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "2560x595";
        rate = "60.01";
      };
      work01 = {
        enable = true;
        primary = true;
        mode = "2560x1440";
        position = "0x0";
        rate = "59.95";
      };
    };
    cah10 = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "5120x360";
        rate = "60.01";
      };
      work10-1 = {
        enable = true;
        primary = true;
        mode = "2560x1440";
        position = "0x0";
        rate = "59.95";
      };
      work10-2 = {
        enable = true;
        primary = true;
        mode = "2560x1440";
        position = "2560x0";
        rate = "59.95";
      };
    };
    cah11 = {
      laptop = {
        enable = true;
        mode = "1920x1080";
        position = "2560x689";
        rate = "60.01";
      };
      work11 = {
        enable = true;
        primary = true;
        mode = "2560x1440";
        position = "0x0";
        rate = "59.95";
      };
    };
  };

  invert = x: 1 / x;
  scale_to_transform = x: [
    [(invert x) 0.0 0.0]
    [0.0 (invert x) 0.0]
    [0.0 0.0 1.0]
  ];
in {
  programs.autorandr.profiles = lib.pipe profiles [
    (lib.mapAttrs
      (_: config: {
        fingerprint = lib.pipe setup [
          (lib.filterAttrs (n: v: builtins.elem n (builtins.attrNames config) && v?edid))
          (lib.mapAttrs (_: v: v.edid))
        ];
        inherit config; # TODO: scale -> transform
      }))
    (lib.filterAttrs (_: v: (builtins.attrNames v.fingerprint) == (builtins.attrNames v.config)))
  ];
  services.kanshi.settings =
    lib.foldlAttrs (
      acc: name: config: let
        filteredSetup = (lib.filterAttrs (n: v: (builtins.elem n (builtins.attrNames config)) && v?criteria)) setup;
      in
        acc
        ++ lib.optional ((builtins.attrNames filteredSetup) == (builtins.attrNames config)) {
          profile = {
            inherit name;
            outputs = lib.mapAttrsToList (outputName: outputConfig:
              (lib.filterAttrs (n: _: builtins.elem n ["mode" "scale"]) outputConfig)
              // {
                criteria = lib.getAttrFromPath [outputName "criteria"] filteredSetup;
                position = builtins.replaceStrings ["x"] [","] outputConfig.position;
                transform = builtins.getAttr (outputConfig.rotate or "normal") {
                  normal = "normal";
                  right = "270";
                  inverted = "180";
                  left = "90";
                  # TODO what about 90-flipped etc?
                };
              })
            config;
          };
        }
    ) []
    profiles;
  # TODO: add shikane https://docs.rs/crate/shikane/latest#configuration
}
