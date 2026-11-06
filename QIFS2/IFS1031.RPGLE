**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1031
//
// Fehler beim Löschen des Verzeichnisses '&1' aufgetreten.
//
DCL-DS IFS1031;
  IFS10311 CHAR(256) INZ(*BLANKS);
  IFS10312 PACKED(010) INZ(*ZEROS);
  IFS10313 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1031_SIZE BINDEC(8) INZ(0390);
//
