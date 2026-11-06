**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1004
//
// Fehler beim Lesen aus Datei '&1' aufgetreten.
//
DCL-DS IFS1004;
  IFS10041 CHAR(256) INZ(*BLANKS);
  IFS10042 PACKED(010) INZ(*ZEROS);
  IFS10043 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1004_SIZE BINDEC(8) INZ(0390);
//
