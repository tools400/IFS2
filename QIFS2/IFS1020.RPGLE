**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1020
//
// Fehler beim Schließen des Verzeichnisses '&1' aufgetreten.
//
DCL-DS IFS1020;
  IFS10201 CHAR(256) INZ(*BLANKS);
  IFS10202 PACKED(010) INZ(*ZEROS);
  IFS10203 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1020_SIZE BINDEC(8) INZ(0390);
//
