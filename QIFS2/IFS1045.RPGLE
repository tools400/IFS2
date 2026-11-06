**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1045
//
// Fehler beim Ermitteln der CCSID der Datei '&1' aufgetreten.
//
DCL-DS IFS1045;
  IFS10451 CHAR(256) INZ(*BLANKS);
  IFS10452 PACKED(010) INZ(*ZEROS);
  IFS10453 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1045_SIZE BINDEC(8) INZ(0390);
//
