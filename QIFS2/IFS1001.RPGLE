**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1001
//
// Fehler beim Schließen Datei '&1' aufgetreten.
//
DCL-DS IFS1001;
  IFS10011 CHAR(256) INZ(*BLANKS);
  IFS10012 PACKED(010) INZ(*ZEROS);
  IFS10013 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1001_SIZE BINDEC(8) INZ(0390);
//
