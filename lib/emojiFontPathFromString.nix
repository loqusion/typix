{
  lib,
  pkgs,
}: emojiFont: let
  inherit (builtins) isNull isString typeOf;
in
  if isString emojiFont
  then
    (
      if emojiFont == "default"
      then "${pkgs.twemoji-color-font}/share/fonts/truetype"
      else if emojiFont == "twemoji"
      then "${pkgs.twemoji-color-font}/share/fonts/truetype"
      else if emojiFont == "twemoji-cbdt"
      then "${pkgs.twitter-color-emoji}/share/fonts/truetype"
      else if emojiFont == "noto"
      then "${pkgs.noto-fonts-color-emoji}/share/fonts/noto"
      else if emojiFont == "noto-monochrome"
      then "${pkgs.noto-fonts-monochrome-emoji}/share/fonts/noto"
      else if emojiFont == "emojione"
      then "${pkgs.emojione}/share/fonts/truetype"
      else throw ''invalid value for `emojiFont`: "${emojiFont}". Must be one of: "twemoji", "twemoji-cbdt", "noto", "noto-monochrome", "emojione", null.''
    )
  else if isNull emojiFont
  then null
  else throw ''invalid type for `emojiFont`: ${typeOf emojiFont}. Must be string or null.''
