**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1048
//
// Fehler beim Ermitteln der Erstellungszeit des Verzeichnis '
//
DCL-DS IFS1048;
  IFS10481 CHAR(256) INZ(*BLANKS);
  IFS10482 PACKED(010) INZ(*ZEROS);
  IFS10483 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1048_SIZE BINDEC(8) INZ(0390);
//
