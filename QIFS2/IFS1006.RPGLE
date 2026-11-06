**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1006
//
// Fehler beim Ermitteln der Größe der Datei '&1' aufgetreten.
//
DCL-DS IFS1006;
  IFS10061 CHAR(256) INZ(*BLANKS);
  IFS10062 PACKED(010) INZ(*ZEROS);
  IFS10063 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1006_SIZE BINDEC(8) INZ(0390);
//
