**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1039
//
// Fehler beim Umbenennen des Verzeichnisses '&1' in '&2' aufg
//
DCL-DS IFS1039;
  IFS10391 CHAR(180) INZ(*BLANKS);
  IFS10392 CHAR(180) INZ(*BLANKS);
  IFS10393 PACKED(010) INZ(*ZEROS);
  IFS10394 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1039_SIZE BINDEC(8) INZ(0494);
//
