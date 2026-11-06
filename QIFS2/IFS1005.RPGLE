**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1005
//
// Fehler beim Löschen der Datei '&1' aufgetreten.
//
DCL-DS IFS1005;
  IFS10051 CHAR(256) INZ(*BLANKS);
  IFS10052 PACKED(010) INZ(*ZEROS);
  IFS10053 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1005_SIZE BINDEC(8) INZ(0390);
//
