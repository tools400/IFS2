**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1018
//
// Fehler beim Abrufen der Attribute des Objekts '&1' aufgetre
//
DCL-DS IFS1018;
  IFS10181 CHAR(256) INZ(*BLANKS);
  IFS10182 PACKED(010) INZ(*ZEROS);
  IFS10183 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1018_SIZE BINDEC(8) INZ(0390);
//
