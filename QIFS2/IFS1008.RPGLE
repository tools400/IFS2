**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1008
//
// Fehler beim Setzen der Schreib-/Leseposition der Datei '&1'
//
DCL-DS IFS1008;
  IFS10081 CHAR(256) INZ(*BLANKS);
  IFS10082 PACKED(010) INZ(*ZEROS);
  IFS10083 CHAR(128) INZ(*BLANKS);
  IFS10084 PACKED(010) INZ(*ZEROS);
  IFS10085 PACKED(010) INZ(*ZEROS);
END-DS;
DCL-S IFS1008_SIZE BINDEC(8) INZ(0402);
//
