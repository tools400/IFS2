**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1044
//
// Der Kopiervorgang wurde mit Fehlercode &1 abgebrochen: '&2'
//
DCL-DS IFS1044;
  IFS10441 PACKED(010) INZ(*ZEROS);
  IFS10442 CHAR(128) INZ(*BLANKS);
  IFS10443 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1044_SIZE BINDEC(8) INZ(0262);
//
