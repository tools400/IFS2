**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1036
//
// Fehler beim Abrufen der Attribute der Datei '&1' aufgetrete
//
DCL-DS IFS1036;
  IFS10361 CHAR(256) INZ(*BLANKS);
  IFS10362 PACKED(010) INZ(*ZEROS);
  IFS10363 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1036_SIZE BINDEC(8) INZ(0390);
//
