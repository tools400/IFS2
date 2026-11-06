**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1034
//
// Fehler beim Abrufen der Attribute des Verzeichnisses '&1' a
//
DCL-DS IFS1034;
  IFS10341 CHAR(256) INZ(*BLANKS);
  IFS10342 PACKED(010) INZ(*ZEROS);
  IFS10343 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1034_SIZE BINDEC(8) INZ(0390);
//
