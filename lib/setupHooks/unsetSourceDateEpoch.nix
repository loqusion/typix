{makeSetupHook}: let
  unsetSourceDateEpoch = builtins.readFile ./unsetSourceDateEpoch.sh;
in
  makeSetupHook {
    name = "unsetSourceDateEpoch";
    substitutions = {
      inherit unsetSourceDateEpoch;
    };
  }
  ./unsetSourceDateEpochHook.sh
