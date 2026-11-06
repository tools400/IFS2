**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1003
//
// Fehler beim Verschieben der Datei '&1' nach '&3' aufgetrete
//
DCL-DS IFS1003;
  IFS10031 CHAR(180) INZ(*BLANKS);
  IFS10032 CHAR(180) INZ(*BLANKS);
  IFS10033 PACKED(010) INZ(*ZEROS);
  IFS10034 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1003_SIZE BINDEC(8) INZ(0494);
//
