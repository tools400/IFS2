**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1027
//
// Berechtigungen für Verzeichnis '&1' nicht gesetzt.
//
DCL-DS IFS1027;
  IFS10271 CHAR(256) INZ(*BLANKS);
  IFS10272 PACKED(010) INZ(*ZEROS);
  IFS10273 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1027_SIZE BINDEC(8) INZ(0390);
//
