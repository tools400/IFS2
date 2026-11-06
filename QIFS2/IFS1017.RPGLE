**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1017
//
// Fehler beim Lesen des nächsten Eintrags aus dem Verzeichnis
//
DCL-DS IFS1017;
  IFS10171 CHAR(256) INZ(*BLANKS);
  IFS10172 PACKED(010) INZ(*ZEROS);
  IFS10173 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1017_SIZE BINDEC(8) INZ(0390);
//
