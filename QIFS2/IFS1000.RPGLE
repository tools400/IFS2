**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1000
//
// Fehler beim Öffnen der Datei '&1' aufgetreten.
//
DCL-DS IFS1000;
  IFS10001 CHAR(256) INZ(*BLANKS);
  IFS10002 PACKED(010) INZ(*ZEROS);
  IFS10003 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1000_SIZE BINDEC(8) INZ(0390);
//
