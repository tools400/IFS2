**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1037
//
// Fehler bei der Ermittlung der ID der Datei '&1' aufgetreten
//
DCL-DS IFS1037;
  IFS10371 CHAR(256) INZ(*BLANKS);
  IFS10372 PACKED(010) INZ(*ZEROS);
  IFS10373 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1037_SIZE BINDEC(8) INZ(0390);
//
