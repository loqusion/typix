{makeSetupHook}: let
  unsetSourceDateEpochScript = builtins.readFile ./unsetSourceDateEpochScript.sh;
in
  makeSetupHook {
    name = "unsetSourceDateEpoch";
    substitutions = {
      inherit unsetSourceDateEpochScript;
    };
  }
  ./unsetSourceDateEpochHook.sh
