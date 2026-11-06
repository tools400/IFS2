**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1002
//
// Fehler beim Schreiben in Datei '&1' aufgetreten.
//
DCL-DS IFS1002;
  IFS10021 CHAR(256) INZ(*BLANKS);
  IFS10022 PACKED(010) INZ(*ZEROS);
  IFS10023 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1002_SIZE BINDEC(8) INZ(0390);
//
