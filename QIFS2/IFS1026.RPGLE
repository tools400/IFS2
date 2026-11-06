**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1026
//
// Verzeichnis '&1' konnte nicht erstellt werden.
//
DCL-DS IFS1026;
  IFS10261 CHAR(256) INZ(*BLANKS);
  IFS10262 PACKED(010) INZ(*ZEROS);
  IFS10263 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1026_SIZE BINDEC(8) INZ(0390);
//
