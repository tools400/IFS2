**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1023
//
// Fehler beim Erstellen eines temporären Pfadnamens aufgetret
//
DCL-DS IFS1023;
  IFS10231 PACKED(010) INZ(*ZEROS);
  IFS10232 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1023_SIZE BINDEC(8) INZ(0134);
//
